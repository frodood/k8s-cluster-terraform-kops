output "app-server-public-ip"{
  value = "${aws_instance.app-server.public_ip}"
}
