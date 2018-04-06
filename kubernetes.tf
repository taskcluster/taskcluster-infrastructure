# Setup underlying support stuff to allow us to provision
# kubernetes clusters with kops

resource "aws_s3_bucket" "kops_state" {
  bucket = "taskcluster-kops-state"
  acl    = "private"

  versioning = {
    enabled = true
  }

  lifecycle_rule {
    id                                     = "cleanup-cruft"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = 14
    }
  }
}
