resource "aws_route_table" "mod" {
  vpc_id = "${aws_vpc.mod.id}"

  tags {
    Name = "${var.name}"
  }
}

# Internet access

resource "aws_route" "mod" {
  route_table_id         = "${aws_route_table.mod.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}
