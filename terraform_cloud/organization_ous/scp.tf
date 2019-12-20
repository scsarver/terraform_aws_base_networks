data "template_file" "sandbox-ou-scp-policy" {
  template = "${file("policies/sandbox-ou.json")}"
}

resource "aws_organizations_policy" "sandbox" {
  name        = "sandbox"
  description = "This is a service control policy to restrict actions that can be done in accounts under the sandbox OU."
  content     = "${data.template_file.sandbox-ou-scp-policy.rendered}"
  type        = "SERVICE_CONTROL_POLICY"
  depends_on  = [aws_organizations_organization.org]
}

resource "aws_organizations_policy_attachment" "sandox" {
  policy_id  = "${aws_organizations_policy.sandbox.id}"
  target_id  = "${aws_organizations_organizational_unit.sandbox.id}"
  depends_on = [aws_organizations_organizational_unit.sandbox]
}


# Add additional NIST-800-53 policy statements where applicable
resource "aws_organizations_policy" "nist-800-53" {
  name = "nist-800-53"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyStopCloudTrail",
      "Effect": "Deny",
      "Action": [ "cloudtrail:StopLogging" ],
      "Resource": [ "arn:aws:cloudtrail:::trail/*" ]
    },
    {
      "Sid": "DenyPutS3ObjectNoSSEAES256",
      "Effect": "Deny",
      "Action": [ "s3:PutObject" ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    },
    {
      "Sid": "DenyPutS3ObjectSSEFalse",
      "Effect": "Deny",
      "Action": [ "s3:PutObject" ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "s3:x-amz-server-side-encryption": false
        }
      }
    }
  ]
}
CONTENT
}


# I want to restrict bucket creation without server side encryption set something like this but I am not sur eit is posible
# BucketEncryption {
#   - ServerSideEncryptionConfiguration:  [
#     - ServerSideEncryptionRule
#       - {
#           "ServerSideEncryptionByDefault" : ServerSideEncryptionByDefault
#         }
#   ]
# }


# Used the following policy to test sentinel when there is a destroy resource in the plan.
#
# resource "aws_organizations_policy" "deny-rds" {
#   name = "deny-rds"
#
#   content = <<CONTENT
# {
#     "Version": "2012-10-17",
#     "Statement": {
#         "Effect": "Deny",
#         "Action": [ "rds:*" ],
#         "Resource": "*"
#     }
# }
# CONTENT
# }
