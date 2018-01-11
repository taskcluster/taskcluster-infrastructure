module "artifacts_domain" {
    source = "modules/artifacts-domain"
    domain = "${var.artifacts_domain}"
    primary_bucket = "${var.artifacts_primary_bucket}"
    primary_bucket_region = "${var.artifacts_primary_bucket_region}"
    logging_bucket = "${var.artifacts_logging_bucket}"
    logging_bucket_region = "${var.artifacts_logging_bucket_region}"
    ssl_support_method = "${var.artifacts_ssl_support_method}"
}
