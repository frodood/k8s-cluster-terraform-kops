k8s-cluster-terraform-kops

Terraform scripts will provision Kubernetes cluster using Kops on AWS

![alt text](https://raw.githubusercontent.com/frodood/k8s-cluster-terraform-kops/master/k8s.png)
- VPC with 2 Public Subnets
- Kubernetes cluster with two worker nodes
- EC2 application server. (Ansible,Jenkins)

Required variables: 
- Route53_zone - Domain name to be used on provisioning the cluster.
- Private_ssh_key_filename - Path of your private ssh key file.
- Region - Desire region to be deploy.

Steps
```

terraform init
terraform plan
terraform apply

```
to destory infrastructure
```
terraform destory
```