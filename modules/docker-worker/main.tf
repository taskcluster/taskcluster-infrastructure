resource "packet_device" "docker_worker" {
  count    = "${var.number_of_machines}"
  hostname = "${var.worker_id_prefix}-${count.index}.${var.worker_type}"

  project_id       = "${var.packet_project_id}"
  plan             = "${var.packet_instance_type}"
  facility         = "${var.facility}"
  operating_system = "ubuntu_14_04"
  billing_cycle    = "hourly"
  tags             = ["desired_worker_count:${var.concurrency}"]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${var.ssh_priv_key}"
  }

  provisioner "file" {
    destination = "/etc/apt/sources.list"

    content = <<EOF
deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted
deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted
deb http://us.archive.ubuntu.com/ubuntu/ trusty universe
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty universe
deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe
deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty multiverse
deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates multiverse
deb http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu trusty-security main restricted
deb-src http://security.ubuntu.com/ubuntu trusty-security main restricted
deb http://security.ubuntu.com/ubuntu trusty-security universe
deb-src http://security.ubuntu.com/ubuntu trusty-security universe
deb http://security.ubuntu.com/ubuntu trusty-security multiverse
deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse
EOF
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y git rng-tools",
      "git clone -b packet-net git://github.com/taskcluster/docker-worker /tmp/docker-worker",
    ]
  }

  provisioner "file" {
    destination = "/tmp/docker-worker/deploy/deploy.json"

    content = <<EOF
{
  "debug.level": "",
  "privateKeyLocation": "/tmp/docker-worker.key",
  "sslCertificateLocation": "/tmp/docker-worker.crt",
  "sslKeyLocation": "/tmp/docker-worker-cert.key",
  "cotSigningKey": "/tmp/docker-worker-cot-signing.key",
  "papertrail": "logs.papertrailapp.com:52806"
}
EOF
  }

  provisioner "file" {
    content     = "${var.private_key}"
    destination = "/etc/docker-worker-priv.pem"
  }

  provisioner "file" {
    content     = "${var.ssl_certificate}"
    destination = "/etc/star_taskcluster-worker_net.crt"
  }

  provisioner "file" {
    content     = "${var.cert_key}"
    destination = "/etc/star_taskcluster-worker_net.key"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown root:root /etc/docker-worker-priv.pem",
      "sudo chown root:root /etc/star_taskcluster*",
      "sudo chmod 600 /etc/docker-worker-priv.pem",
      "sudo chmod 600 /etc/star_taskcluster*",
      "cd /tmp/docker-worker",
      "PAPERTRAIL=${var.papertrail} deploy/packer/base/scripts/configure_syslog.sh",
      "PAPERTRAIL=${var.papertrail} deploy/packer/base/scripts/packages.sh",
      "PAPERTRAIL=${var.papertrail} deploy/packer/base/scripts/node.sh",
      "sudo bash -c 'echo net.ipv4.tcp_challenge_ack_limit = 999999999 >> /etc/sysctl.conf'",
      "deploy/bin/gen-signing-key",
      "npm install -g yarn",
      "yarn install --frozen-lockfile",
      "deploy/bin/build app",
      "cp docker-worker.tgz deploy/deploy.tar.gz deploy/packer/app/scripts/deploy.sh ~",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo reboot &",
      "sleep 3",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/deploy.sh",
      "~/deploy.sh ~/deploy.tar.gz ~/docker-worker.tgz",
    ]
  }

  provisioner "file" {
    destination = "/etc/default/docker-worker"

    content = <<EOF
#!/bin/bash
export TASKCLUSTER_CLIENT_ID='${var.taskcluster_client_id}'
export TASKCLUSTER_ACCESS_TOKEN='${var.taskcluster_access_token}'
export WORKER_TYPE='${var.worker_type}'
export PROVISIONER_ID='${var.provisioner_id}'
export CAPACITY='${var.concurrency}'
export WORKER_GROUP='${var.worker_group_prefix}-${var.facility}'
export WORKER_ID='${var.worker_id_prefix}-${count.index}'
export RELENG_API_TOKEN='${var.relengapi_token}'
export STATELESS_HOSTNAME='${var.stateless_hostname}'
export TASKCLUSTER_ROOT_URL='https://taskcluster.net'
EOF
  }

  provisioner "remote-exec" {
    inline = [
      "start docker-worker",
    ]
  }
}

resource "packet_ssh_key" "key1" {
  name       = "ssh_key"
  public_key = "${var.ssh_pub_key}"
}
