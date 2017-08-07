# Top-level configuration, region-by-region

/*
# ---

module "us-west-1" {
    source = "./modules/worker-region"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-west-1"
}

module "us-west-1-gecko-workers" {
    source = "./modules/worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-1"

    name = "gecko-workers"
    cidr = "10.143.0.0/16"
    availability_zones = [
        "us-west-1b",
        "us-west-1c",
    ]
}

# ---

module "us-west-2" {
    source = "./modules/worker-region"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-west-2"
}

module "us-west-2-gecko-workers" {
    source = "./modules/worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-1"

    name = "gecko-workers"
    cidr = "10.144.0.0/16"
    availability_zones = [
        "us-west-2a",
        "us-west-2b",
        "us-west-2c",
    ]
}

# ---

module "us-east-1" {
    source = "./modules/worker-region"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

module "us-east-1-gecko-workers" {
    source = "./modules/worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-1"

    name = "gecko-workers"
    cidr = "10.145.0.0/16"
    availability_zones = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e",
        "us-east-1f",
    ]
}

# ---

module "us-east-2" {
    source = "./modules/worker-region"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-2"
}

module "us-east-2-gecko-workers" {
    source = "./modules/worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "us-east-2"

    name = "gecko-workers"
    cidr = "10.146.0.0/16"
    availability_zones = [
        "us-east-2a",
        "us-east-2b",
        "us-east-2c",
    ]
}

# ---
*/

module "eu-central-1" {
    source = "./modules/worker-region"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "eu-central-1"
}

module "eu-central-1-gecko-workers" {
    source = "./modules/worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "eu-central-1"

    name = "gecko-workers"
    cidr = "10.147.0.0/16"
    availability_zones = [
        "eu-central-1a",
        "eu-central-1b",
        "eu-central-1c",
    ]
}

