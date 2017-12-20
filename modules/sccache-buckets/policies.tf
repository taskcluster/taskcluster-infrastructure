resource "aws_iam_policy" "sccache_policies" {
  count = "${length(var.levels)}"

  name        = "${var.prefix}-level-${var.levels[count.index]}-sscache"
  description = "Read and write to level-${var.levels[count.index]} sccache buckets prefix ${var.prefix}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPutGetDelete",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-2/*",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-1/*",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-east-2/*",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-eu-central-1/*"
      ]
    },
    {
      "Sid": "AllowListLocationTagging",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:GetBucketTagging",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-2",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-west-1",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-us-east-2",
        "arn:aws:s3:::${var.prefix}-level-${var.levels[count.index]}-sccache-eu-central-1"
      ]
    }
  ]
}
EOF
}
