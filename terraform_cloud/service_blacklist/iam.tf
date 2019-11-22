resource "aws_iam_policy" "policy" {
    name        = "test-policy"
    description = "Policy to allow users to assume test-role"
    policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:iam::1234567890:role/test-role"
            ]
        }
    ],
    "Version": "2012-10-17"
}
EOF
}
