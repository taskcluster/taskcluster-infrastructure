output static_ips {
  value = "${aws_eip.static_ip.*.public_ip}"
}
