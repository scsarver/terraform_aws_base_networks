#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191104-214726
#
# Purpose and References:
#
#
# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
set -e #errexit
# set -u #nounset

echo " "
echo "************************************************************"
echo "Executing Sentinel simulator: test "
echo "     Uses only test files and mocks found in the sentinel_policy_directory structure"
echo "************************************************************"
echo " "

sentinel_policy_directory=

if [ "" == "$(which sentinel)" ]; then
  echo "The sentinel (Simulator) executable was not found see the following for installation instructions: https://docs.hashicorp.com/sentinel/intro/getting-started/install"
  exit 1
fi

if [ "" == "$1" ]; then
  echo "Enterting the path to your sentinel policy directory as the first parameter is required"
  exit 1
else
  if [ "." == "$1" ]; then
    sentinel_policy_directory="$(pwd)"
  else
    sentinel_policy_directory="$1"
  fi
  if [ ! -d "$sentinel_policy_directory" ]; then
    echo "The path entered to your sentinel policy directory is not valid: [$sentinel_policy_directory]"
    exit 1
  fi
fi


echo ' '
echo "Change directory to where the policy files are located: $sentinel_policy_directory"

cd "$sentinel_policy_directory"

echo ' '
echo "Executing [sentinel test -verbose]"
sentinel test -verbose
