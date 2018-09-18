resource "aws_internet_gateway" "kubernetes-vpc" {
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.kubernetes-vpc.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.kubernetes-vpc.id}"
}

resource "aws_route_table" "kubernetes-vpc" {
  vpc_id = "${aws_vpc.kubernetes-vpc.id}"

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/kops/role"                       = "public"
  }
}

resource "aws_route_table_association" "subnet-kubernetes-1" {
  subnet_id      = "${aws_subnet.subnet-kubernetes-1.id}"
  route_table_id = "${aws_route_table.kubernetes-vpc.id}"
}

resource "aws_route_table_association" "subnet-kubernetes-2" {
  subnet_id      = "${aws_subnet.subnet-kubernetes-2.id}"
  route_table_id = "${aws_route_table.kubernetes-vpc.id}"
}

resource "aws_subnet" "subnet-kubernetes-1" {
  vpc_id            = "${aws_vpc.kubernetes-vpc.id}"
  cidr_block        = "${var.vpc["subnet-1a-public"]}"
  availability_zone = "${var.region}a"

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.region}a.${var.cluster_name}"
    SubnetType                                      = "Public"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                        = "1"
  }
}
resource "aws_subnet" "subnet-kubernetes-2" {
  vpc_id            = "${aws_vpc.kubernetes-vpc.id}"
  cidr_block        = "${var.vpc["subnet-1b-public"]}"
  availability_zone = "${var.region}b"

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.region}b.${var.cluster_name}"
    SubnetType                                      = "Public"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                        = "1"
  }
}
resource "aws_vpc" "kubernetes-vpc" {
  cidr_block           = "${var.vpc["main"]}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "kubernetes-vpc" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                               = "${var.cluster_name}"
    Name                                            = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "kubernetes-vpc" {
  vpc_id          = "${aws_vpc.kubernetes-vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.kubernetes-vpc.id}"
}
