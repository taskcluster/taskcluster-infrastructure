// Variables that might differ for another installation of Taskcluster

// The domain name used to host artifacts; this must be a distinct zone
// from other Taskcluster-related domains, to avoid XSS vulnerabilities.
//
// You will need to register this domain and, once it is configured by terraform,
// configure the nameservers for that registration to match those generated
// by AWS Route53.  You will also need to manually set up an AWS ACM certificate
// for this domain (in us-east-1, AWS demans).

variable "artifacts_domain" {
  type    = "string"
  default = "taskcluster-artifacts.net"
}

// The "ssl_support_method" used for the artifacts CloudFront distribution. Use
// "sni-only" unless you require access by ancient TLS implementations (and are
// OK with $600/mo charge from Amazon)

variable "artifacts_ssl_support_method" {
  type    = "string"
  default = "vip"
}

// The S3 bucket and region into which artifacts are written; this will be the
// origin for the CloudFront distribution

variable "artifacts_primary_bucket" {
  type    = "string"
  default = "taskcluster-public-artifacts"
}

// The S3 bucket into which logs from the artifacts cloudfront distribution are
// written.

variable "artifacts_logging_bucket" {
  type    = "string"
  default = "taskcluster-public-artifacts-logs"
}

