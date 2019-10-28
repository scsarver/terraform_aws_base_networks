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
