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
