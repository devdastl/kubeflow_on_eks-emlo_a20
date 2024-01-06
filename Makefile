NOTEBOOK-DOCKER = kubeflow_aws_p310-pt21_cpu:notebook
KSERVE-DOCKER = kubeflow_aws_p310-pt21_cpu:serve
COMPONENT-DOCKER = kubeflow_aws_p310-pt21_cpu:tasks
DEV-ENV = kubeflow_docker:development

#setup make commands
help:
	@echo "Makefile supported commands:"
	@echo "1. build-images: Build required images"
	@echo "2. create-eks-cluster: create EKS cluster on AWS"


build-images:
	@echo "building docker image for notebook"
	cd src/notebook_dockerfile && docker build -t ${NOTEBOOK-Docker} .

	@echo "building docker image for components"	
	cd src/components_dockerfile && docker build -t ${COMPONENT-Docker} .

	@echo "building docker image for Kserve"	
	cd src/kserve_dockerfile && docker build -t ${KSERVE-Docker} .

create-eks-cluster:
	@echo "Creating EKS cluster from eks-cluster.yaml file"
	export CLUSTER_NAME=emlo-test-cluster
	export REGION=us-west-2
	export ACCOUNT_ID==****
	export CLUSTER_REGION=us-west-2
	eksctl create cluster -f eks-cluster.yaml
	eksctl utils associate-iam-oidc-provider --region ${REGION} --cluster ${CLUSTER_NAME} --approve
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

setup-kubeflow:
	@echo "setting up environment for kubeflow"
	@echo "building docker image for kubeflow setup"
	cd src/kubeflow_dockerfile && DOCKER_BUILDKIT=1 docker build  --build-arg -t ${DEV-ENV} --secret id=aws,src=${HOME}/.aws/credentials .

	@echo "starting docker container in interactive mode"
	docker run -it --rm -v ${HOME}/.aws/credentials:/root/.aws/credentials:ro ${DEV-ENV} bash