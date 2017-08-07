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
  default     = []
}

variable "admin_subnet" {
  description = "Should this VPC have an 'admin' subnet?"
  default     = false
}

variable "mozilla_vpn_tunnel" {
  description = "Should this VPC have tunnels configured to Mozilla DCs?"
  default     = false
}
