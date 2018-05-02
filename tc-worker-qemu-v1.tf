module "tc-worker-qemu-v1" {
  source                   = "modules/taskcluster-worker-packet"
  number_of_machines       = "1"
  log_host                 = "${var.tc_worker_qemu_log_host}"
  log_port                 = "${var.tc_worker_qemu_log_port}"
  taskcluster_client_id    = "${var.tc_worker_qemu_client_id}"
  taskcluster_access_token = "${var.tc_worker_qemu_access_token}"
  taskcluster_worker_hash  = "fe8c29966c48dc48e61cf2ef1b47bb373ea729867b93192cfa53bf7b7b043dc6"
  provisioner_id           = "terraform-packet"
  worker_type              = "tc-worker-qemu-v1"
  facility                 = "ams1"
  project                  = "tc-worker-qemu-v1"
  packet_project_id        = "d701a359-ae99-43ec-868b-6dd551336b1e"
}
