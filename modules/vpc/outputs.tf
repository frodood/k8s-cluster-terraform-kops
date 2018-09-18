output "vpcid" {
  value = "${aws_vpc.kubernetes-vpc.id}"
}

output "PublicSubnets-1" {
  value = "${aws_subnet.subnet-kubernetes-1.id}"
}

output "PublicSubnets-2" {
  value = "${aws_subnet.subnet-kubernetes-2.id}"
}
