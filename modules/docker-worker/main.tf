resource "packet_device" "docker_worker" {
  count    = "${var.number_of_machines}"
  hostname = "${var.worker_id_prefix}-${count.index}.${var.worker_type}"

  project_id       = "${var.packet_project_id}"
  plan             = "${var.packet_instance_type}"
  facility         = "${var.facility}"
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  tags             = ["desired_worker_count:${var.concurrency}"]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${var.ssh_priv_key}"
  }

  user_data = <<EOF
#cloud-config
#image_repo=https://gitlab.com/walac/packet-images
#image_tag=dd807cb6fea560c418a31990bc0cbff7568fa32f
#taskclusterRootUrl=https://taskcluster.net
#clientId=${var.taskcluster_client_id}
#accessToken=${var.taskcluster_access_token}
#workerPoolId=${var.provisioner_id}/${var.worker_type}
EOF
}

resource "packet_ssh_key" "key1" {
  name       = "ssh_key"
  public_key = "${var.ssh_pub_key}"
}
