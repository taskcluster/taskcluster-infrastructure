output instance_public_ip {
  value = "${aws_instance.service_instance.public_ip}"
}
