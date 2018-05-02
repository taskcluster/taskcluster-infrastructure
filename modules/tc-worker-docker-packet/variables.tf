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
  default     = "0.1.16"
}

variable "taskcluster_worker_hash" {
  type        = "string"
  description = "accessToken to pass to the worker"
  default     = "sha512-3469e02c92b3bb4b7f1d81115a060a41a07f66989b5297d0c06f410095f79c3dd30b3d78f7b2f44db6bb654a786d467da8b71fbfac644214f828c7b4b956aa6b"
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
