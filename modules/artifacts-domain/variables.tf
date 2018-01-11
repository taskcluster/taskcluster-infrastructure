// Domain name for hosting artifacts for download.  This must be a different
// top-level domain than the Taskcluster APIs and UIs, to avoid XSS
// vulnerabilities.

variable "domain" {
    type = "string"
}

// The "ssl_support_method" used for the artifacts CloudFront distribution. Use
// "sni-only" unless you require access by ancient TLS implementations (and are
// OK with $600/mo charge from Amazon)

variable "ssl_support_method" {
    type = "string"
}

// The S3 bucket into which artifacts are written; this will be the origin
// for the CloudFront distribution

variable "primary_bucket" {
    type = "string"
}

variable "primary_bucket_region" {
    type = "string"
    // NOTE: this is assumed to be us-west-2 right now (TODO)
}

// The S3 bucket into which logs from the cloudfront distribution are written

variable "logging_bucket" {
    type = "string"
}

variable "logging_bucket_region" {
    type = "string"
    // NOTE: this is assumed to be us-west-2 right now (TODO)
}
