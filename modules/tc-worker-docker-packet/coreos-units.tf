### Cores OS systemd units
# This file contains coreos systemd unit files for disabling services we don't
# care about and enabling logging to papertrail.

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
