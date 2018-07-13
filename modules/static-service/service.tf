data "aws_ami" "coreos" {
  filter {
    // Always be specific enough to only get single AMI.
    // Feel free to update the version number, by searching in AWS console
    // and finding a more recent one. Using most_recent = true, causes changes
    // when coreos updates their AMIs, and breaks our ability to rollback.
    name = "name"

    values = ["CoreOS-stable-1688.5.3-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] # CoreOS
}

data "ignition_systemd_unit" "ssh_socket_off" {
  name    = "sshd.socket"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "ssh_service_off" {
  name    = "sshd.service"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "locksmithd_off" {
  name    = "locksmithd.service"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "update_engine_off" {
  name    = "update-engine.service"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "fleet_off" {
  name    = "fleet.socket"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "etcd2_off" {
  name    = "etcd2.service"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "metadata_ssh_off" {
  name    = "coreos-metadata-sshkeys@core.service"
  mask    = true
  enabled = false
}

data "ignition_systemd_unit" "debug_logging" {
  name = "systemd-journald.service"

  dropin = [
    {
      name    = "10-debug.conf"
      content = "[Service]\nEnvironment=SYSTEMD_LOG_LEVEL=debug"
    },
  ]
}

data "ignition_systemd_unit" "papertrail_logging" {
  name    = "papertrail.service"
  enabled = true

  content = <<EOF
[Unit]
Description=forward syslog to papertrail
After=systemd-journald.service
Before=docker.service
Requires=systemd-journald.service
[Service]
ExecStart=/bin/sh -c "journalctl -f | ncat --ssl ${var.log_host} ${var.log_port}"
TimeoutStartSec=0
Restart=on-failure
RestartSec=5s
EOF
}

data "ignition_systemd_unit" "service_runtime" {
  count   = "${var.service_copies_per_instance}"
  name    = "${var.runtime_name}-${count.index}.service"
  enabled = true

  content = <<EOF
[Unit]
Description=${var.runtime_description}
Requires=papertrail.service docker.service
[Service]
Restart=always
ExecStart=/usr/bin/docker \
  run ${var.runtime_port_map != "" ? "-p" : ""} ${var.runtime_port_map} --rm \
  --env-file /etc/static-service-env.list \
  --name ${var.runtime_name} \
  ${var.image_tag}@sha256:${var.image_hash} ${var.runtime_command}
ExecStop=/usr/bin/docker kill ${var.runtime_name}
[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_file" "env" {
  filesystem = "root"
  path       = "/etc/static-service-env.list"
  mode       = "0400"

  content {
    content = "${var.env_vars}"
  }
}

data "ignition_file" "hostname" {
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "0420"

  content {
    content = "${var.runtime_name}"
  }
}

data "ignition_config" "static_service" {
  systemd = [
    "${data.ignition_systemd_unit.ssh_socket_off.id}",
    "${data.ignition_systemd_unit.ssh_service_off.id}",
    "${data.ignition_systemd_unit.locksmithd_off.id}",
    "${data.ignition_systemd_unit.update_engine_off.id}",
    "${data.ignition_systemd_unit.fleet_off.id}",
    "${data.ignition_systemd_unit.etcd2_off.id}",
    "${data.ignition_systemd_unit.metadata_ssh_off.id}",
    "${data.ignition_systemd_unit.debug_logging.id}",
    "${data.ignition_systemd_unit.papertrail_logging.id}",
    "${data.ignition_systemd_unit.service_runtime.*.id}",
  ]

  files = [
    "${data.ignition_file.env.id}",
    "${data.ignition_file.hostname.id}",
  ]
}

resource "aws_instance" "service_instance" {
  count         = "${var.instances}"
  ami           = "${data.aws_ami.coreos.id}"
  instance_type = "${var.instance_type}"

  vpc_security_group_ids = ["${var.security_groups}"]

  tags {
    Name                = "${var.nametag} ${count.index}"
    taskcluster_service = "${var.servicetag}"
    managed_by          = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.ignition_config.static_service.rendered}"
}

resource "aws_eip" "static_ip" {
  count    = "${(var.runtime_port_map != "" ? 1 : 0) * var.instances}"
  instance = "${element(aws_instance.service_instance.*.id, count.index)}"
  vpc      = true

  tags {
    Name                = "${var.nametag}"
    taskcluster_service = "${var.servicetag}"
    managed_by          = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
