variable "log_host" {
  type = "string"
}

variable "log_port" {
  type = "string"
}

variable "nametag" {
  type = "string"
}

variable "servicetag" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "runtime_name" {
  type = "string"
}

variable "runtime_description" {
  type = "string"
}

variable "runtime_port_map" {
  type = "string"
}

variable "image_tag" {
  type = "string"
}

variable "image_hash" {
  type = "string"
}

variable "env_vars" {
  type = "string"
}

variable "security_groups" {
  type = "list"
}
