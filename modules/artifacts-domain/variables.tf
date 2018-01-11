// The domain name to define
variable "domain" {
    type = "string"
}

// The CloudFront distribution ID this domain name should alias to
variable "cf_distribution_id" {
    type = "string"
}
