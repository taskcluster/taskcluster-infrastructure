// Created for https://bugzilla.mozilla.org/show_bug.cgi?id=1467876

resource "aws_iam_policy" "ciduty_access" {
  name        = "ciduty_access"
  path        = "/"
  description = "Permissions for the ciduty team to inspect the account. Used via cross-account from releng account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:Get*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Deny",
            "Action": "ec2:GetPasswordData",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ciduty_access" {
  name = "ciduty_access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.releng_aws_account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ciduty_access" {
    role       = "${aws_iam_role.ciduty_access.name}"
    policy_arn = "${aws_iam_policy.ciduty_access.arn}"
}
