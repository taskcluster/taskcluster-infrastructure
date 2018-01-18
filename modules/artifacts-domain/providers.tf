// The regions in which to find these buckets

provider "aws" {
    alias = "primary_bucket"
}

provider "aws" {
    alias = "logging_bucket"
}
