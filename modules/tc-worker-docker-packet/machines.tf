resource "packet_device" "workers" {
  count    = "${var.number_of_machines}"
  hostname = "${var.worker_id_prefix}-${count.index}.${var.worker_type}"

  project_id       = "${var.packet_project_id}"
  plan             = "${var.packet_instance_type}"
  facility         = "${var.facility}"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"

  user_data = "${data.ignition_config.worker_config.rendered}"
}

data "ignition_config" "worker_config" {
  # Disable various coreos services, add logging and worker service
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
    "${data.ignition_systemd_unit.worker_service.id}",
  ]

  # Install taskcluster-worker and a config file
  files = [
    "${data.ignition_file.taskcluster_worker.id}",
    "${data.ignition_file.worker_config.id}",
  ]
}

data "ignition_file" "taskcluster_worker" {
  filesystem = "root"
  path       = "/opt/taskcluster-worker"
  mode       = 0555

  source {
    source       = "https://github.com/taskcluster/taskcluster-worker/releases/download/v${var.taskcluster_worker_version}/taskcluster-worker-${var.taskcluster_worker_version}-linux-amd64"
    verification = "${var.taskcluster_worker_hash}"
  }
}

data "ignition_file" "worker_config" {
  filesystem = "root"
  path       = "/etc/taskcluster-worker.yml"
  mode       = 0400

  content {
    content = <<EOF
# Configuration file for taskcluster-worker
transforms: []
config:
  credentials:
    # This example uses the following scopes:
    #   assume:worker-type:terraform-packet/tc-worker-docker-v1
    #   auth:sentry:tc-worker-docker-v1
    #   auth:statsum:tc-worker-docker-v1
    #   auth:webhooktunnel
    #   queue:worker-id:*
    clientId:       "${var.taskcluster_client_id}"
    accessToken:    "${var.taskcluster_access_token}"
  engine:           docker
  engines:
    docker:
      privileged:   allow
  minimumDiskSpace:   10000000  # 10 GB
  minimumMemory:      1000000   # 1 GB
  monitor:
    logLevel:       debug
    project:        "${var.project}"
  plugins:
    disabled:
      - reboot
      - interactive
    interactive:    {}
    artifacts:      {}
    env:            {}
    livelog:        {}
    logprefix:
      instance-type:   "${var.packet_instance_type}"
    tcproxy:        {}
    cache:          {}
    maxruntime:
      maxRunTime:   '4 hours'
      perTaskLimit: 'allow'
    success:        {}
    watchdog:       {}
    relengapi:
      token:  "${var.relengapi_token}"
      host:   "api.pub.build.mozilla.org"
  temporaryFolder:  /mnt/tmp
  webHookServer:
    provider:       localhost
  worker:
    concurrency:          ${var.concurrency}
    minimumReclaimDelay:  30
    pollingInterval:      5
    reclaimOffset:        300
    provisionerId:        "${var.provisioner_id}"
    workerType:           "${var.worker_type}"
    workerGroup:          "${var.worker_group_prefix}-${var.facility}"
    workerId:             "${var.worker_id_prefix}-${count.index}"
EOF
  }
}

data "ignition_systemd_unit" "worker_service" {
  name    = "taskcluster-worker.service"
  enabled = true

  content = <<EOF
[Unit]
Description=taskcluster worker process
Requires=papertrail.service docker.service

[Service]
Restart=always
Environment=DEBUG=*
ExecStart=/opt/taskcluster-worker work /etc/taskcluster-worker.yml

[Install]
WantedBy=multi-user.target
EOF
}
