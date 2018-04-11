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

resource "aws_security_group" "basic_https" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id      = "vpc-24233046" # default vpc in us-west-2
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

module "statsum" {
  source                   = "modules/static-service"
  log_host                 = "${var.static_service_log_host}"
  log_port                 = "${var.static_service_log_port}"
  security_groups          = ["${aws_security_group.basic_https.id}"]
  nametag                  = "Statsum"
  servicetag               = "statsum"
  instance_type            = "c4.2xlarge"
  runtime_name             = "statsum"
  runtime_description      = "statsum metrics aggregator"
  runtime_port_map         = "443:12345"
  image_tag                = "jonasfj/statsum"
  image_hash               = "b8e12b57ef3fa430a5f7b0281098d5c488afae136012be7f8551ada9053065b6"
  providers = {
    aws = "aws.us-west-2"
  }
  env_vars = <<EOF
PORT=12345
JWT_SECRET_KEY=${var.statsum_jwt_secret_key}
SENTRY_DSN=${var.statsum_sentry_dsn}
SIGNALFX_TOKEN=${var.statsum_signalfx_token}
EOF
}

module "webhooktunnel" {
  source                   = "modules/static-service"
  log_host                 = "${var.static_service_log_host}"
  log_port                 = "${var.static_service_log_port}"
  security_groups          = ["${aws_security_group.basic_https.id}"]
  nametag                  = "Webhook Tunnel"
  servicetag               = "webhooktunnel"
  instance_type            = "t2.medium"
  runtime_name             = "webhooktunnel"
  runtime_description      = "tunnel for webhooks"
  runtime_port_map         = "443:12345"
  image_tag                = "taskcluster/webhooktunnel"
  image_hash               = "ed9a8c9f3949f3c8251d1d9a1ae3cfb0aaa99d584b707d12acfdf60f356cc3d5"
  providers = {
    aws = "aws.us-west-2"
  }
  env_vars = <<EOF
PORT=12345
ENV='production'
HOSTNAME=${var.webhooktunnel_hostname}
TASKCLUSTER_PROXY_SECRET_A=${var.webhooktunnel_secret_a}
TASKCLUSTER_PROXY_SECRET_B=${var.webhooktunnel_secret_b}
TLS_KEY='HELP WHAT IS THE PLAN HERE'
TLS_CERTIFICATE='HELP WHAT IS THE PLAN HERE'
EOF
}

output stateless_dns_us_west_2_ip {
  value = "${module.stateless_dns_us_west_2.static_ip}"
}

output stateless_dns_eu_west_1_ip {
  value = "${module.stateless_dns_eu_west_1.static_ip}"
}

output statsum_ip {
  value = "${module.statsum.static_ip}"
}

output webhooktunnel_ip {
  value = "${module.webhooktunnel.static_ip}"
}
