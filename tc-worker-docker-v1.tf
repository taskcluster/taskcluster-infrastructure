module "tc-worker-docker-v1" {
  source                   = "modules/tc-worker-docker-packet"
  number_of_machines       = "1"
  log_host                 = "${var.tc_worker_log_host}"
  log_port                 = "${var.tc_worker_log_port}"
  taskcluster_client_id    = "project/taskcluster/taskcluster-worker/terraform-packet/tc-worker-docker-v1"
  taskcluster_access_token = "${var.tc_worker_docker_access_token}"
  provisioner_id           = "terraform-packet"
  worker_type              = "tc-worker-docker-v1"
  packet_instance_type     = "c1.small.x86"
  facility                 = "sjc1"
  project                  = "tc-worker-docker-v1"
  packet_project_id        = "d701a359-ae99-43ec-868b-6dd551336b1e"
}
