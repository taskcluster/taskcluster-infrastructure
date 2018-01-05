resource "packet_device" "workers" {
  count    = "${var.number_of_machines}"
  hostname = "${var.worker_id_prefix}-${count.index}.${var.worker_type}"

  project_id       = "${packet_project.taskcluster.id}"
  plan             = "baremetal_0"
  facility         = "${var.facility}"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"

  user_data = <<EOF
#cloud-config
coreos:
  units:
    # Disable SSH
    - name:    sshd.socket
      mask:    true
      command: stop
    - name:    sshd.service
      mask:    true
      command: stop
    # Stop updates of coreos
    - name:    locksmithd.service
      mask:    true
      command: stop
    # Disable fleet socket activation
    - name:    fleet.socket
      mask:    true
      command: stop
    # Disable etcd2
    - name:    etcd2.service
      mask:    true
      command: stop
    # Enable debug-level logging
    - name:    systemd-journald.service
      command: restart
      drop-ins:
        - name: 10-debug.conf
          content: |
            [Service]
            Environment=SYSTEMD_LOG_LEVEL=debug
    # Setup logging to papertrail
    - name:    papertrail.service
      command: start
      content: |
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
    # Reload kvm_intel with nested virtualization allowed
    - name:    kvm_intel_nested.service
      command: start
      content: |
        [Unit]
        Description=Reload kvm_intel to allow nested virtualization.

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=/bin/sh -c 'modprobe -r kvm_intel && modprobe kvm_intel nested=1'
        ExecStop=/bin/sh -c 'modprobe -r kvm_intel && modprobe kvm_intel'
    # Setup taskcluster-worker
    - name:    taskcluster-worker.service
      command: start
      content: |
        [Unit]
        Description=taskcluster worker process
        Requires=papertrail.service docker.service kvm_intel_nested.service

        [Service]
        Restart=always
        ExecStart=/usr/bin/docker \
          run -p 443:443 --rm --privileged \
          --env-file /etc/taskcluster-worker-env.list \
          --name taskcluster-worker \
          taskcluster/tc-worker@sha256:${var.taskcluster_worker_hash}
        ExecStop=/usr/bin/docker kill taskcluster-worker

        [Install]
        WantedBy=multi-user.target
# Add file with environment variables for taskcluster-worker
write_files:
  - path:         /etc/taskcluster-worker-env.list
    permissions:  '0400'
    owner:        root
    content: |
      ENGINE=qemu
      TASKCLUSTER_CLIENT_ID=${var.taskcluster_client_id}
      TASKCLUSTER_ACCESS_TOKEN=${var.taskcluster_access_token}
      PORT=443
      PROVISIONER_ID=${var.provisioner_id}
      WORKER_TYPE=${var.worker_type}
      WORKER_GROUP=${var.worker_group_prefix}-${var.facility}
      WORKER_ID=${var.worker_id_prefix}-${count.index}
      PROJECT=${var.project}
      DEBUG=*
EOF
}
