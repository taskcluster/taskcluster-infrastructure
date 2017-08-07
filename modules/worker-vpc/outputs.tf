output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "subnet_ids" {
  value = "${join(", ", aws_subnet.mod.*.id)}"
}
