output "org_id" {
  value = "${aws_organizations_organization.org.id}"
}

output "org_accounts" {
  value = "${aws_organizations_organization.org.accounts}"
}

output "org_arn" {
  value = "${aws_organizations_organization.org.arn}"
}

output "org_master_account_arn" {
  value = "${aws_organizations_organization.org.master_account_arn}"
}

output "org_master_account_email" {
  value = "${aws_organizations_organization.org.master_account_email}"
}

output "org_master_account_id" {
  value = "${aws_organizations_organization.org.master_account_id}"
}

output "org_non_master_accounts" {
  value = "${aws_organizations_organization.org.non_master_accounts}"
}

output "org_roots" {
  value = "${aws_organizations_organization.org.roots}"
}

output "org_ou_sandbox_id" {
  value = "${aws_organizations_organizational_unit.sandbox.id}"
}

output "org_ou_sandbox_arn" {
  value = "${aws_organizations_organizational_unit.sandbox.arn}"
}

output "org_ou_sandbox_accounts" {
  value = "${aws_organizations_organizational_unit.sandbox.accounts}"
}

output "org_account1_id" {
  value = "${aws_organizations_account.account1.id}"
}

output "org_account1_arn" {
  value = "${aws_organizations_account.account1.arn}"
}
