// Variables that might differ for another installation of Taskcluster

// The domain name used to host artifacts; this must be a distinct zone
// from other Taskcluster-related domains, to avoid XSS vulnerabilities. You
// will need to register this domain yourself and point the registration
// to the generated AWS Route53 nameservers

variable "artifacts_domain" {
    type = "string"
    default = "taskcluster-artifacts.net"
}
