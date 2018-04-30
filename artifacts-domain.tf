module "artifacts_domain" {
  source             = "modules/artifacts-domain"
  domain             = "${var.artifacts_domain}"
  primary_bucket     = "${var.artifacts_primary_bucket}"
  logging_bucket     = "${var.artifacts_logging_bucket}"
  ssl_support_method = "${var.artifacts_ssl_support_method}"

  // NOTE: these are values a user might want to change, but cannot be based
  // on variables
  providers = {
    "aws.primary_bucket" = "aws.us-west-2"
    "aws.logging_bucket" = "aws.us-west-2"
  }
}
