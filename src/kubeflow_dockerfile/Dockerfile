FROM python:3.8 

ARG CLUSTER
ARG REGION

#setup required ENV variables
ENV CLUSTER_NAME = ${CLUSTER}
ENV CLUSTER_REGION = ${REGION}
ENV KUBEFLOW_RELEASE_VERSION = v1.7.0
ENV AWS_RELEASE_VERSION = v1.7.0-aws-b1.0.3


RUN apt-get update && apt-get install build-essential git
WORKDIR /workspace
COPY ebs_irsa_setup.sh .

#install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
&& unzip awscliv2.zip && \
./aws/install

#install aws IAM authenticator
RUN curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64 &&\
chmod +x ./aws-iam-authenticator && \
cp ./aws-iam-authenticator /usr/local/bin

#update kube config
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials aws eks update-kubeconfig --name ${CLUSTER} --region ${REGION}

#install kubeflow
RUN git clone https://github.com/awslabs/kubeflow-manifests.git && cd kubeflow-manifests \
&& git checkout ${AWS_RELEASE_VERSION} && \
git clone --branch ${KUBEFLOW_RELEASE_VERSION} https://github.com/kubeflow/manifests.git upstream

WORKDIR /workspace/kubeflow-manifests
RUN make install-tools

#setup EBS and IRSA via shell script by passing aws creds
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials sh /workspace/ebs_irsa_setup.sh
