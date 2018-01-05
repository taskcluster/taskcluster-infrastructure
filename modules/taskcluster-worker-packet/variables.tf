variable "number_of_machines" {
  type        = "string"
  description = "number of machines to create"
  default     = "1"
}

variable "log_host" {
  type        = "string"
  description = "hostname that log should be sent to, see also log_port"
}

variable "log_port" {
  type        = "string"
  description = "port on log_host that logs should be sent to"
}

variable "taskcluster_worker_hash" {
  type        = "string"
  description = "docker image hash for taskcluster-worker image"
  default     = "1e44d165ef38ec85637778d2c413cdf2e27f3c99782e3585470593e3196085a1"
}

variable "taskcluster_client_id" {
  type        = "string"
  description = "clientId to pass to the worker"
}

variable "taskcluster_access_token" {
  type        = "string"
  description = "accessToken to pass to the worker"
}

variable "provisioner_id" {
  type    = "string"
  default = "manual-packet"
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
  default     = "tc-worker-qemu-v1"
}

variable "packet_project_name" {
  type        = "string"
  description = "packet project name"
  default     = "taskcluster"
}
