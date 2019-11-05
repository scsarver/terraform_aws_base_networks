#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191101-141652
#
# Purpose and References:
#
# This script is built to quickly run a sentinel policy apply against a downloaded set of mock files
# This script takes as imput the following:
#     1.) the path to where the sentinel policy file is located
#     2.) the name of the sentinel policy file
#     3.) the path to where the sentinel mock files are located
#
# References:
# https://learn.hashicorp.com/terraform/sentinel/sentinel-testing
# https://docs.hashicorp.com/sentinel/intro/getting-started/install
# https://github.com/hashicorp/tfe-policies-example
#
# Usage Example:
#     ./applysentinelmock.sh  ../organization_ous/sentinel organization_ous.sentinel ~/Downloads/sentinel-mocks-directory


# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
# set -e #errexit
# set -u #nounset

sentinel_policy_directory=
sentinel_policy_name=
sentinel_mocks_directory=
sentinel_functions_directory=

sentinel_config_file='sentinel.json'


echo " "
echo "************************************************************"
echo "Executing Sentinel simulator: apply "
echo "     Uses a path to the mock files downloaded from Terraform Cloud as the third parameter."
echo "************************************************************"
echo " "

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

if [ "" == "$2" ]; then
  echo "Enterting the name of your sentinel policy file as the second parameter is required"
  exit 1
else
  sentinel_policy_name="$2"
  if [ ! -f "$sentinel_policy_directory/$sentinel_policy_name" ]; then
    echo "Entering a valid file name for the sentinel policy is required"
    exit 1
  fi
fi

if [ "" == "$3" ]; then
  echo "Enterting the path to your downloaded sentinel mocks directory or a period (indicating current directory) as the second parameter is required"
  exit 1
else
  if [ "." == "$3" ]; then
    sentinel_mocks_directory="$(pwd)"
  else
    sentinel_mocks_directory="$3"
  fi
  if [ ! -d "$sentinel_mocks_directory" ]; then
    echo "The path entered to your downloaded sentinel mocks directory is not valid: [$sentinel_mocks_directory]"
    exit 1
  fi
fi


if [ "" == "$4" ]; then
  echo " "
  echo "No functions path was provided, so no additional functions will be added to $sentinel_config_file"
  echo " "
else
  if [ "." == "$4" ]; then
    sentinel_functions_directory="$(pwd)"
  else
    sentinel_functions_directory="$4"
  fi
  if [ ! -d "$sentinel_functions_directory" ]; then
    echo "The path entered to your sentinel functions directory is not valid: [$sentinel_functions_directory]"
    exit 1
  fi
fi

echo ' '
echo "Change directory to where the policy file is located: $sentinel_policy_directory"

cd "$sentinel_policy_directory"

echo ' '
echo 'Creating a Sentinel Simulator configuration file called sentinel.json this file tells the simulator to load the mock plan, config, state and run files.'
SENTINEL_MOCK_CONTENTS1=$(cat <<COMMENTBLOCK
{
  "mock": {
COMMENTBLOCK
)

# Iterate through the function directory and add all files ending in .sentinel as import objects prefixed with sentinel_lib_${file%.*}
SENTINEL_MOCK_CONTENTS2=

if [ -d "$sentinel_functions_directory" ]; then
  for file in $(ls $sentinel_functions_directory)
  do
    if [[ "$file" == *.sentinel ]]; then
      SENTINEL_MOCK_CONTENTS2+="   \"sentinel_lib_${file%.*}\": \"$sentinel_functions_directory/$file\","
    fi
  done
fi
SENTINEL_MOCK_CONTENTS3=$(cat <<COMMENTBLOCK
    "tfrun": "$sentinel_mocks_directory/mock-tfrun.sentinel",
    "tfconfig": "$sentinel_mocks_directory/mock-tfconfig.sentinel",
    "tfplan": "$sentinel_mocks_directory/mock-tfplan.sentinel",
    "tfstate": "$sentinel_mocks_directory/mock-tfstate.sentinel"
  }
}
COMMENTBLOCK
)

echo "$SENTINEL_MOCK_CONTENTS1">"$sentinel_config_file"
if [ "" != "$SENTINEL_MOCK_CONTENTS2" ]; then
  echo "$SENTINEL_MOCK_CONTENTS2">>"$sentinel_config_file"
fi
echo "$SENTINEL_MOCK_CONTENTS3">>"$sentinel_config_file"

echo ' '
echo "Executing [sentinel apply -trace -config=$sentinel_config_file \"$sentinel_policy_name\"]"
sentinel apply -trace -config=$sentinel_config_file "$sentinel_policy_name"

echo ' '
echo "Removing the sentinal simulator configuration file: sentinel.json"
# rm "sentinel.json"
