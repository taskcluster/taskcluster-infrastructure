variable "number_of_machines" {
  type        = "string"
  description = "number of machines to create"
  default     = "1"
}

variable "packet_instance_type" {
  type        = "string"
  description = "Packet machine to create"
  default     = "baremetal_0"
}

variable "concurrency" {
  type        = "string"
  description = "number of concurrent tasks to run on each worker machine"
  default     = "1"
}

variable "taskcluster_client_id" {
  type        = "string"
  description = "clientId to pass to the worker"
}

variable "taskcluster_client_id_ffci" {
  type        = "string"
  description = "clientId of firefox-ci deployment"
}

variable "taskcluster_access_token" {
  type        = "string"
  description = "accessToken to pass to the worker"
}

variable "taskcluster_access_token_ffci" {
  type        = "string"
  description = "accessToken of firefox-ci deployment"
}

variable "provisioner_id" {
  type    = "string"
  default = "terraform-packet"
}

variable "worker_type" {
  type = "string"
}

variable "facility" {
  type    = "string"
  default = "sjc1"
}

variable "worker_group_prefix" {
  type        = "string"
  description = "workerGroup prefix, this will be suffixed with '-<facility>'"
  default     = "packet"
}

variable "worker_id_prefix" {
  type        = "string"
  description = "workerId prefix, this will be suffixed with '-<count>'"
  default     = "machine"
}

variable "project" {
  type        = "string"
  description = "sentry and statsum project the worker should use"
  default     = "tc-worker-docker-v1"
}

variable "packet_project_id" {
  type        = "string"
  description = "packet project id"
}

variable "private_key" {
  type = "string"
}

variable "ssl_certificate" {
  type = "string"
}

variable "cert_key" {
  type = "string"
}

variable "papertrail" {
  type    = "string"
  default = "logs2.papertrailapp.com:22395"
}

variable "ssh_pub_key" {}

variable "ssh_priv_key" {}

variable "relengapi_token" {
  type        = "string"
  description = "Releng API token"
}

variable "stateless_hostname" {
  default = ""
}
