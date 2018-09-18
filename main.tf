provider "aws" {
  shared_credentials_file = "/home/dasun/.aws/credentials"
  profile                 = "default"
  region                  = "${var.region}"
}

locals {
  cluster_name = "${random_id.name.hex}.kops.${var.route53_zone}"
  bucket_name = "${var.s3_bucket_prefix}-${random_id.name.hex}"
  public_ssh_key_location = "${var.private_ssh_key_filename}.pub"
}


resource "random_id" "name" {
  byte_length = 8
}

module "vpc" {
  source = "./modules/vpc"
  cluster_name = "${random_id.name.hex}.kops.${var.route53_zone}"
  region = "${var.region}"
  vpc = "${var.vpc}"

}
module "ec2" {
  source = "./modules/ec2"
  vpc-id = "${module.vpc.vpcid}"
  app_defaults = "${var.app_defaults}"
  subnet-public = "${module.vpc.PublicSubnets-1}"
  key_name = "${local.public_ssh_key_location}"
}

resource "tls_private_key" "ssh" {
  algorithm   = "RSA"
}


resource "null_resource" "kops" {
  provisioner "local-exec" {
    command = <<EOF
ssh-keygen -P "" -t rsa -f ./${var.private_ssh_key_filename}
export CLUSTER_NAME=${local.cluster_name}
export BUCKET_NAME=${local.bucket_name}
export VPC=${module.vpc.vpcid}
export SUBNET_IDS=${module.vpc.PublicSubnets-1},${module.vpc.PublicSubnets-2}
export KUBERNETES_VERSION=${var.kubernetes_version}
export IP_ADDRESS=0.0.0.0/0
export ZONES=${var.region}a,${var.region}b
export SSH_PUBKEY_PATH=${local.public_ssh_key_location}
./scripts/kops-create.sh
EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    command = <<EOF
export CLUSTER_NAME=${local.cluster_name}
export BUCKET_NAME=${local.bucket_name}
./scripts/kops-delete.sh
EOF
  }

}

resource "aws_key_pair" "utility-keypair" {
  key_name   = "${var.app_defaults["key_name"]}"
  public_key = "${file("${local.public_ssh_key_location}")}"
}

output "cluster_name" {
  value = "${local.cluster_name}"
}

output "app-server-public-ip" {
  value = "${module.ec2.app-server-public-ip}"
}
