variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
    description = "AWS region to configure"
}

variable "name" {
    description = "The name of the vpc to be used in tagging"
}

variable "cidr" {
    description = "IP CIDR block of the vpc network"
}

variable "availability_zones" {
    description = "A list of Availablity Zones to use (up to 15)"
    default = []
}

# ---

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

# ---

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

resource "aws_route" "igw" {
  route_table_id = "${aws_route_table.mod.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_subnet" "mod" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.mod.id}"
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

output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "subnet_ids" {
 value = "${join(", ", aws_subnet.mod.*.id)}"
}

resource "aws_security_group" "docker-worker" {
  name = "docker-worker - ${var.name}"
  description = "Allow inbound traffic to ephemeral ports, all outbound"
  tags {
    Name = "docker-worker"
    Vpc = "${var.name}"
  }

  ingress {
    from_port = 32768
    to_port = 61000
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "livelog-direct" {
  name = "livelog-direct - ${var.name}"
  description = "For connecting to livelog GET interface running directly on host"
  tags {
    Name = "livelog-direct"
    Vpc = "${var.name}"
  }

  ingress {
    from_port = 60023
    to_port = 60023
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rdp-only" {
  name = "rdp-only - ${var.name}"
  description = "RDP only"
  tags {
    Name = "rdp-only"
    Vpc = "${var.name}"
  }

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-only" {
  name = "ssh-only - ${var.name}"
  description = "SSH only"
  tags {
    Name = "ssh-only"
    Vpc = "${var.name}"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "no-inbound" {
  name = "no-inbound - ${var.name}"
  description = "Deny all inbound traffic. Allow all outbound traffic only"
  tags {
    Name = "no-inbound"
    Vpc = "${var.name}"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
