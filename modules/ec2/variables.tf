variable "app_defaults"{
  type = "map"
  default ={
    name = ""
    ami_id      = ""
    public_ip            = ""
    key_name             = ""
    instance_type = ""
  }
}

variable "key_name"{
  default = ""
}
variable "subnet-public"{
  default = ""
}


variable "vpc-id"{
  default = ""
}
