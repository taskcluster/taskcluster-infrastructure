# Declarations of secret variables to be read from password-store
#
# Environment variables expected by built-in provisioners:
#  * ARM_ACCESS_KEY, access creds for azure state file.
#  * PACKET_AUTH_TOKEN, auth token for packet.net

variable "tc_worker_qemu_log_host" {
  type = "string"
}

variable "tc_worker_qemu_log_port" {
  type = "string"
}

variable "tc_worker_qemu_client_id" {
  type = "string"
}

variable "tc_worker_qemu_access_token" {
  type = "string"
}

variable "static_service_log_host" {
  type = "string"
}

variable "static_service_log_port" {
  type = "string"
}

variable "stateless_dns_primary_key" {
  type = "string"
}

variable "stateless_dns_secondary_key" {
  type = "string"
}

variable "statsum_jwt_secret_key" {
  type = "string"
}

variable "statsum_sentry_dsn" {
  type = "string"
}

variable "statsum_signalfx_token" {
  type = "string"
}

variable "webhooktunnel_hostname" {
  type = "string"
}

variable "webhooktunnel_secret_a" {
  type = "string"
}

variable "webhooktunnel_secret_b" {
  type = "string"
}

variable "cloudmirror_aws_access_key_id" {
  type = "string"
}

variable "cloudmirror_aws_secret_access_key" {
  type = "string"
}

variable "cloudmirror_pulse_username" {
  type = "string"
}

variable "cloudmirror_pulse_password" {
  type = "string"
}

variable "cloudmirror_redis_host" {
  type = "string"
}

variable "cloudmirror_redis_pass" {
  type = "string"
}

variable "cloudmirror_redis_port" {
  type = "string"
}

variable "cloudmirror_tc_client_id" {
  type = "string"
}

variable "cloudmirror_tc_access_token" {
  type = "string"
}
