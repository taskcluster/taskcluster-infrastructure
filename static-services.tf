resource "aws_security_group" "stateless_dns_us_west_2" {
  name        = "allow_dns"
  description = "Allow dns inbound traffic"
  vpc_id      = "vpc-24233046" # default vpc in us-west-2
  provider    = "aws.us-west-2"

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "stateless_dns_eu_west_1" {
  name        = "allow_dns"
  description = "Allow dns inbound traffic"
  vpc_id      = "vpc-fd19fa98" # default vpc in eu-west-1
  provider    = "aws.eu-west-1"

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "stateless_dns_us_west_2" {
  source                   = "modules/static-service"
  log_host                 = "${var.static_service_log_host}"
  log_port                 = "${var.static_service_log_port}"
  security_groups          = ["${aws_security_group.stateless_dns_us_west_2.id}"]
  nametag                  = "Stateless DNS"
  servicetag               = "stateless-dns"
  instance_type            = "t2.nano"
  runtime_name             = "stateless_dns"
  runtime_description      = "stateless dns server implementation"
  runtime_port_map         = "53:55553/udp"
  image_tag                = "taskcluster/stateless-dns-server"
  image_hash               = "764e325a266d429f8cd4d6693f6f0fed941f726cee5e38eb3a84f210731aae4c"
  providers = {
    aws = "aws.us-west-2"
  }
  env_vars = <<EOF
PORT=55553
DOMAIN=taskcluster-worker.net
PRIMARY_SECRET=${var.stateless_dns_primary_key}
SECONDARY_SECRET=${var.stateless_dns_secondary_key}
EOF
}

module "stateless_dns_eu_west_1" {
  source                   = "modules/static-service"
  log_host                 = "${var.static_service_log_host}"
  log_port                 = "${var.static_service_log_port}"
  security_groups          = ["${aws_security_group.stateless_dns_eu_west_1.id}"]
  nametag                  = "Stateless DNS"
  servicetag               = "stateless-dns"
  instance_type            = "t2.nano"
  runtime_name             = "stateless_dns"
  runtime_description      = "stateless dns server implementation"
  runtime_port_map         = "53:55553/udp"
  image_tag                = "taskcluster/stateless-dns-server"
  image_hash               = "764e325a266d429f8cd4d6693f6f0fed941f726cee5e38eb3a84f210731aae4c"
  providers = {
    aws = "aws.eu-west-1"
  }
  env_vars = <<EOF
PORT=55553
DOMAIN=taskcluster-worker.net
PRIMARY_SECRET=${var.stateless_dns_primary_key}
SECONDARY_SECRET=${var.stateless_dns_secondary_key}
EOF
}

output stateless_dns_us_west_2_ip {
  value = "${module.stateless_dns_us_west_2.instance_public_ip}"
}

output stateless_dns_eu_west_1_ip {
  value = "${module.stateless_dns_eu_west_1.instance_public_ip}"
}
