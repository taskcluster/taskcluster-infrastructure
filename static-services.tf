# Please feel free to DRY this up a bit if you have the time

# These are all services that used to run in docker-cloud
# for one reason or another. Services run on static instances
# that we must treat as pets rather than cattle :(

# Note: The docker env files we use to configure things
# _do_ pass along quotes on strings, so do not quote strings
# if you don't want them. As an example `NODE_ENV='production'`
# will not work the way you might think!

resource "aws_security_group" "stateless_dns_us_west_2" {
  name        = "allow_dns"
  description = "Allow dns inbound traffic"
  vpc_id      = "vpc-24233046"              # default vpc in us-west-2
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
  vpc_id      = "vpc-fd19fa98"              # default vpc in eu-west-1
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

resource "aws_security_group" "basic_https" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id      = "vpc-24233046"                # default vpc in us-west-2
  provider    = "aws.us-west-2"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "deny_all" {
  name        = "deny_all"
  description = "Deny all inbound traffic"
  vpc_id      = "vpc-24233046"             # default vpc in us-west-2
  provider    = "aws.us-west-2"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "stateless_dns_us_west_2" {
  source              = "modules/static-service"
  log_host            = "${var.static_service_log_host}"
  log_port            = "${var.static_service_log_port}"
  security_groups     = ["${aws_security_group.stateless_dns_us_west_2.id}"]
  nametag             = "Stateless DNS"
  servicetag          = "stateless-dns"
  instance_type       = "t2.nano"
  runtime_name        = "stateless_dns"
  runtime_description = "stateless dns server implementation"
  runtime_port_map    = "53:55553/udp"
  image_tag           = "taskcluster/stateless-dns-server"
  image_hash          = "764e325a266d429f8cd4d6693f6f0fed941f726cee5e38eb3a84f210731aae4c"

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
  source              = "modules/static-service"
  log_host            = "${var.static_service_log_host}"
  log_port            = "${var.static_service_log_port}"
  security_groups     = ["${aws_security_group.stateless_dns_eu_west_1.id}"]
  nametag             = "Stateless DNS"
  servicetag          = "stateless-dns"
  instance_type       = "t2.nano"
  runtime_name        = "stateless_dns"
  runtime_description = "stateless dns server implementation"
  runtime_port_map    = "53:55553/udp"
  image_tag           = "taskcluster/stateless-dns-server"
  image_hash          = "764e325a266d429f8cd4d6693f6f0fed941f726cee5e38eb3a84f210731aae4c"

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

# The following outputs are all static ip addresses that we can point
# dns at even when the underlying instance changes

output stateless_dns_ips {
  value = "${concat(module.stateless_dns_us_west_2.static_ips, module.stateless_dns_eu_west_1.static_ips)}"
}
