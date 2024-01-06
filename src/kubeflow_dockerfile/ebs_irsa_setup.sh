#Make sure OIDC is enabled for your Cluster
eksctl utils associate-iam-oidc-provider --region ${CLUSTER_REGION} --cluster ${CLUSTER_NAME} --approve

#create the IRSA for EBS
eksctl create iamserviceaccount \
--name ebs-csi-controller-sa \
--namespace kube-system \
--cluster ${CLUSTER_NAME} \
--role-name AmazonEKS_EBS_CSI_DriverRole \
--role-only \
--attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
--approve

#Create the EBS CSI Driver Addon
eksctl create addon \
--name aws-ebs-csi-driver \
--cluster ${CLUSTER_NAME} \
--service-account-role-arn arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole \
--force