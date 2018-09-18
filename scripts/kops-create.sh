#!/bin/bash
#create k8s cluster using Kops
export NODE_SIZE=t2.micro
export MASTER_SIZE=t2.medium
export KOPS_STATE_STORE="s3://${BUCKET_NAME}"

aws s3api create-bucket --acl=private --bucket $BUCKET_NAME && \
kops create cluster --cloud=aws \
  --name=$CLUSTER_NAME \
  --state=$KOPS_STATE_STORE \
  --zones=$ZONES \
  --master-size=$NODE_SIZE \
  --node-size=$MASTER_SIZE \
  --vpc=$VPC \
  --subnets=${SUBNET_IDS} \
  --node-count=2 \
  --kubernetes-version=$KUBERNETES_VERSION \
  --ssh-public-key=${SSH_PUBKEY_PATH} \
  --ssh-access=${IP_ADDRESS} \
  --admin-access=${IP_ADDRESS} \
  --yes

EXIT_CODE=$?
if [ $EXIT_CODE == 0 ]; then
   ./scripts/kops-waiter.sh 120
else
  exit $EXIT_CODE
fi
