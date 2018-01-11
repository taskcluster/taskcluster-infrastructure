module "artifacts_domain" {
  source = "modules/artifacts-domain"
  domain = "taskcluster-artifacts.net"
  cf_distribution_id = "d15i1wtwi4py6w"
}

