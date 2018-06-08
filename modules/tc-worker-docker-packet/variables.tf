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
  default     = "sha512-3beafe59d2009120fe923de976a3f954dc0918019d227d90cdef0b37987c609c37b1172e4808c13426bf17519e89ea6b05c1c8792cb6b702b49dca6a43048c76"
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
