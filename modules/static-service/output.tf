output instance_hostname {
  value = "${aws_instance.service_instance.public_dns}"
}
