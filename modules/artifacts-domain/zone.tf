resource "aws_route53_zone" "artifacts-domain" {
    name = "${var.domain}"
}

resource "aws_route53_record" "artifacts-domain-ns" {
    zone_id = "${aws_route53_zone.artifacts-domain.zone_id}"
    name = "${var.domain}"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.artifacts-domain.name_servers.0}",
        "${aws_route53_zone.artifacts-domain.name_servers.1}",
        "${aws_route53_zone.artifacts-domain.name_servers.2}",
        "${aws_route53_zone.artifacts-domain.name_servers.3}",
    ]
}

resource "aws_route53_record" "artifacts-domain-spf" {
    zone_id = "${aws_route53_zone.artifacts-domain.zone_id}"
    name = "${var.domain}"
    type = "TXT"
    ttl = "30"
    records = [
        "v=spf1 -all",
    ]
}

resource "aws_route53_record" "artifacts-domain-alias" {
    zone_id = "${aws_route53_zone.artifacts-domain.zone_id}"
    name = "${var.domain}"
    type = "A"

    alias {
        name = "${aws_cloudfront_distribution.artifact_distribution.domain_name}"
        // http://docs.aws.amazon.com/Route53/latest/APIReference/CreateAliasRRSAPI.html
        zone_id = "Z2FDTNDATAQYW2"
        evaluate_target_health = false
    }
}
