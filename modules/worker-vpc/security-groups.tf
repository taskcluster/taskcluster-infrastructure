resource "aws_security_group" "docker-worker" {
  name        = "docker-worker - ${var.name}"
  description = "Allow inbound traffic to ephemeral ports, all outbound"

  tags {
    Name = "docker-worker"
    Vpc  = "${var.name}"
  }

  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "livelog-direct" {
  name        = "livelog-direct - ${var.name}"
  description = "For connecting to livelog GET interface running directly on host"

  tags {
    Name = "livelog-direct"
    Vpc  = "${var.name}"
  }

  ingress {
    from_port   = 60023
    to_port     = 60023
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rdp-only" {
  name        = "rdp-only - ${var.name}"
  description = "RDP only"

  tags {
    Name = "rdp-only"
    Vpc  = "${var.name}"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-only" {
  name        = "ssh-only - ${var.name}"
  description = "SSH only"

  tags {
    Name = "ssh-only"
    Vpc  = "${var.name}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "no-inbound" {
  name        = "no-inbound - ${var.name}"
  description = "Deny all inbound traffic. Allow all outbound traffic only"

  tags {
    Name = "no-inbound"
    Vpc  = "${var.name}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
