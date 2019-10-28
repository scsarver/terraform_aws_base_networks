#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191028-141435
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
echo "Check for Terraform Cloud auth configuration:"
if [ ! -f ~/.terraformrc ]; then
  echo "You will need to setup an access token in your ~/.terraformrc file to use authenticate to the the terraform cloud api."
  echo " "
  echo "The contents should hold your users token see getting started documentation here: https://www.terraform.io/docs/cloud/getting-started/index.html"
  echo "credentials \"app.terraform.io\" {"
  echo "     token = \"CHANGE_ME\""
  echo "}"
else
  echo " "
  echo "Using ~/.terraformrc cli configuration file"
fi

echo "############################################################"
echo "Check for Terraform Cloud backend configuration:"

if [ ! -f ./backend.conf ]; then
  echo "You will need to supply backend configuration when executing the teraform init, this can be done by supplying the cammand line parameter --backend-config"
  echo "     Example: terraform init --backend-config=./backend.conf "
  echo "     Note: ./backend.conf is .gitignored for this project so your organization/workspace details will not be version controlled."
  echo " "
  echo "The contents should hold your users token see getting started documentation here: https://www.terraform.io/docs/cloud/getting-started/index.html"
  echo "hostname = \"app.terraform.io\""
  echo "organization = \"CHANGE_ME\""
  echo "workspaces {"
  echo "  name = \"CHANGE_ME\""
  echo "}"
else
  echo " "
  echo "Showing: ./backend.conf configuration settings:"
  cat ./backend.conf
fi

echo "############################################################"
echo "Terraform version: $(terraform --version)"

echo "############################################################"
echo "Running terraform validate:"
terraform validate
