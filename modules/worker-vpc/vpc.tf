resource "aws_vpc" "mod" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags { Name = "${var.name}" }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { Name = "${var.name}" }
}

resource "aws_route_table" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { Name = "${var.name}" }
}

resource "aws_route" "mod" {
  route_table_id = "${aws_route_table.mod.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_subnet" "mod" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.mod.id}"
  # NOTE: this starts at subnet 1, leaving subnet zero (a /20) open for other purposes
  cidr_block = "${cidrsubnet(var.cidr, 4, count.index + 1)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  tags { Name = "${var.name}:${element(var.availability_zones, count.index)}" }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "mod" {
  count = "${length(var.availability_zones)}"
  subnet_id = "${element(aws_subnet.mod.*.id, count.index)}"
  route_table_id = "${aws_route_table.mod.id}"
}

## administrative subnet

resource "aws_subnet" "admin" {
  count = "${var.admin_subnet}"
  vpc_id = "${aws_vpc.mod.id}"
  # Use the first /24 of the VPC
  cidr_block = "${cidrsubnet(var.cidr, 8, 0)}"
  # default to the first AZ
  availability_zone = "${element(var.availability_zones, 0)}"
  tags { Name = "${var.name}:admin" }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "admin" {
  count = "${var.admin_subnet}"
  subnet_id = "${aws_subnet.admin.0.id}"
  route_table_id = "${aws_route_table.mod.id}"
}

