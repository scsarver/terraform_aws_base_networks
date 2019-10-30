resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = "${aws_organizations_organization.org.roots.0.id}"
  depends_on = [aws_organizations_organization.org]
}

# Add accounts here and assign OUs
# resource "aws_organizations_account" "account1" {
#   name  = "${var.ENV_aws_account_1_name}"
#   email = "${var.ENV_aws_account_1_email_prefix}@${var.ENV_aws_account_1_email_provider}"
#   parent_id = "${aws_organizations_organizational_unit.sandbox.id}"
#   depends_on = [aws_organizations_organizational_unit.sandbox]
# }
