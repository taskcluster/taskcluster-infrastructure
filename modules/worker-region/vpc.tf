variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
    description = "AWS region to configure"
}

variable "gecko_cidr" {
    description = "CIDR block allocated to the Gecko workers in this region"
}

variable "availability_zones" {
    description = "A list of Availablity Zones to use"
    default = []
}

# ---

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

# ---

module "vpc" {
    source = "../worker-vpc"

    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    region = "${var.region}"

    name = "${var.region}:gecko-workers"
    cidr = "${var.gecko_cidr}"
    availability_zones = "${var.availability_zones}"
}
