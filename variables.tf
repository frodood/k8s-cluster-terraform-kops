variable "vpc" {
  type = "map"
  default = {
    main          = "10.0.0.0/16"
    subnet-1a-public = "10.0.32.0/20"
    subnet-1b-public = "10.0.96.0/20"
  }
}

variable "route53_zone" {
  type = "string"
  default = "egghead27.de"
}

variable "kubernetes_version" {
  type = "string"
  default = "1.11.3"
}

variable "s3_bucket_prefix" {
  type = "string"
  default = "kops-messagebird"
}

variable "private_ssh_key_filename" {
  type = "string"
  default = "/home/dasun/.ssh/id_rsa"
}

variable "app_defaults"{
  type = "map"
  default ={
    name = "app-server"
    ami_id      = "ami-04169656fea786776"
    public_ip            = true
    key_name = "dasun"
    instance_type = "t2.micro"
  }
}

variable "region"{
  type = "string"
  default = "us-east-1"
}
