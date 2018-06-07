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

variable "log_host" {
  type        = "string"
  description = "hostname that log should be sent to, see also log_port"
}

variable "log_port" {
  type        = "string"
  description = "port on log_host that logs should be sent to"
}

variable "taskcluster_worker_version" {
  type        = "string"
  description = "version of taskcluster-worker to install"
  default     = "0.1.19"
}

variable "taskcluster_worker_hash" {
  type        = "string"
  description = "hash of the binary, curl -L <url> | sha512sum -"
  default     = "sha512-0c2a721b52498be31bf3c0b9c166447018dffd18784b028b2237c8a5e32f067aafcc3254a27a3110a984a81086582c12ed8263c3a97eb6c671c32493f1643d46"
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

variable "relengapi_token" {
  type        = "string"
  description = "Releng API token"
}
