#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191028-145937
#
# Purpose and References:
#
#
# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
set -e #errexit
set -u #nounset

echo "############################################################"
echo " "
echo "Error: No configuration files."
echo " "
echo "     Are you in the correct directory to run your terraform config or is your path to the config correct?"
echo " "

echo "############################################################"
echo " "
echo "Error: Initialization required. Please see the error message above."
echo " "
echo "     Have you run terraform init? When you ran terraform init did you use the --backend-config parameter?"
echo " "

echo "############################################################"
echo " "
echo "Error: No valid credential sources found for AWS Provider."
echo " "
echo "     Have you added credentials to your workspace for AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY (or an assumable role)"
echo " "

echo "############################################################"
echo " "
echo "Error: invalid value for parent_id (see https://docs.aws.amazon.com/organizations/latest/APIReference/API_CreateOrganizationalUnit.html#organizations-CreateOrganizationalUnit-request-ParentId)"
echo " "
echo "     Did you set the parent id correctly for your OU, the id needs to come from the orgs roots list as shown in the documnetation:"
echo '          parent_id = "${aws_organizations_organization.org.roots.0.id}"'
echo " "
echo "     Setting it in the following manner caused this error:"
echo '          parent_id = "${aws_organizations_organization.org.id}"'
echo " "




# echo " Did you have a dependency error and need to verify the email address for the account before adding resources to the organization?"
# echo "     Are you creating a new aws organization if so you may need to verify the email before resources can be associated to the org:"
# echo "          Amazon Web Services needs to verify the email address associated with the master account of your AWS organization before"
# echo "          you can invite existing AWS accounts to join your organization."
# echo " "
# echo "          To verify your email address, click the following link: ..."
# echo " "
# echo "      After clicking and verifying email the aws account landing page gives the following message:"
# echo " "
# echo "          Your email address has been verified"
# echo "          You can now invite existing AWS accounts to join your organization."
# echo " "
# echo "    I added explicit depends_on code blocks to enforce a dependency chain."
