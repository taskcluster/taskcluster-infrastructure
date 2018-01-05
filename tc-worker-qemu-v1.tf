module "tc-worker-qemu-v1" {
  source                   = "modules/taskcluster-worker-packet"
  number_of_machines       = "1"
  log_host                 = "${var.tc_worker_qemu_log_host}"
  log_port                 = "${var.tc_worker_qemu_log_port}"
  taskcluster_client_id    = "${var.tc_worker_qemu_client_id}"
  taskcluster_access_token = "${var.tc_worker_qemu_access_token}"
  provisioner_id           = "terraform-packet"
  worker_type              = "tc-worker-qemu-v1"
  facility                 = "ams1"
  project                  = "tc-worker-qemu-v1"
}
