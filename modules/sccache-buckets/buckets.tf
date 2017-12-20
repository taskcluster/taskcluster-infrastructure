// WARNING: terraform is stupid, it can't do nested loops.
// So we have to type one of the iteration levels, emulating nested loops breaks
// things if we changes the number of elements in lists we iterate over.
// Hence, just type put the regions, and dream of a brighter future.

resource "aws_s3_bucket" "sccache_bucket_us_west_2" {
  count = "${length(var.levels)}"

  bucket   = "${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-2"
  region   = "us-west-2"
  provider = "aws.us_west_2"

  lifecycle_rule {
    id      = "expired-after-15d"
    enabled = true
    prefix  = "/"

    expiration {
      days = 15
    }
  }
}

resource "aws_s3_bucket" "sccache_bucket_us_west_1" {
  count = "${length(var.levels)}"

  bucket   = "${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-1"
  region   = "us-west-1"
  provider = "aws.us_west_1"

  lifecycle_rule {
    id      = "expired-after-15d"
    enabled = true
    prefix  = "/"

    expiration {
      days = 15
    }
  }
}

resource "aws_s3_bucket" "sccache_bucket_us_east_2" {
  count = "${length(var.levels)}"

  bucket   = "${var.prefix}-level-${var.levels[count.index]}-sccache-us-east-2"
  region   = "us-east-2"
  provider = "aws.us_east_2"

  lifecycle_rule {
    id      = "expired-after-15d"
    enabled = true
    prefix  = "/"

    expiration {
      days = 15
    }
  }
}

resource "aws_s3_bucket" "sccache_bucket_eu_central_1" {
  count = "${length(var.levels)}"

  bucket   = "${var.prefix}-level-${var.levels[count.index]}-sccache-eu-central-1"
  region   = "eu-central-1"
  provider = "aws.eu_central_1"

  lifecycle_rule {
    id      = "expired-after-15d"
    enabled = true
    prefix  = "/"

    expiration {
      days = 15
    }
  }
}
