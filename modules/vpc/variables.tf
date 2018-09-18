
variable "cluster_name" {
  default = ""
}

variable "vpc" {
  type = "map"
  default = {
    main          = ""
    subnet-1a-public = ""
    subnet-1b-public = ""
  }
}

variable "region"{
  type = "string"
  default = ""
}
