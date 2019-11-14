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

resource "aws_organizations_policy" "example" {
  name = "deny-acct-allow-billing"

  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "aws-portal:*Billing",
          "aws-portal:*Usage",
          "aws-portal:*PaymentMethods"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": "aws-portal:*Account",
      "Resource": "*"
    }
  ]
}
CONTENT
}
