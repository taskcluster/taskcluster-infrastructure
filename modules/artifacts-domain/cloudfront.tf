data "aws_s3_bucket" "primary_bucket" {
    bucket = "${var.primary_bucket}"
    provider = "aws.primary_bucket"
}

data "aws_s3_bucket" "logging_bucket" {
    bucket = "${var.logging_bucket}"
    provider = "aws.logging_bucket"
}

data "aws_acm_certificate" "domain" {
  domain   = "${var.domain}"
  // CloudFront requires that this cert is in us-east-1
  provider = "aws.us-east-1"
}

resource "aws_cloudfront_distribution" "artifact_distribution" {
    origin {
        domain_name = "${data.aws_s3_bucket.primary_bucket.bucket_domain_name}"
        origin_id = "primary_bucket"
    }

    enabled = true
    is_ipv6_enabled = false
    comment = "${var.domain}"

    logging_config {
        bucket = "${data.aws_s3_bucket.logging_bucket.bucket_domain_name}"
    }

    aliases = ["${var.domain}"]

    default_cache_behavior {
        allowed_methods = ["GET", "HEAD", "OPTIONS"]
        cached_methods = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = "primary_bucket"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }

            headers = [
                "Access-Control-Request-Headers",
                "Access-Control-Request-Method",
                "Origin",
            ]
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 604800
        default_ttl = 604800
        max_ttl = 31536000
    }

    // use all edge locations
    price_class = "PriceClass_All"

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
		acm_certificate_arn = "${data.aws_acm_certificate.domain.arn}"
        ssl_support_method = "${var.ssl_support_method}"
    }
}
