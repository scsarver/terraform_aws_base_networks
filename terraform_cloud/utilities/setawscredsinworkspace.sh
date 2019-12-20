#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191029-133707
#
# Purpose and References:
#
# This script is used to push aws credentials from the locally installed default
# profile up to the terraform cloud workspace by using the locally installed Terraform Cloud api token.
#
# Assumptions:
#     ~/.terraformrc has a valid api token
#     ~/.aws/credentials has a default profile with a valid aws_access_key_id & aws_secret_access_key set.
#
# References:
# https://www.terraform.io/docs/cloud/api/index.html
# https://www.terraform.io/docs/cloud/api/variables.html
#
#
# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
set -e #errexit
# set -u #nounset

# User/org specific variables
tf_org=$1
workspace_name=$2
aws_profile=default

if [ "" == "$1" ]; then
  echo "Enterting the terraform cloud organization name as the first parameter is required"
  exit 1
fi

if [ "" == "$2" ]; then
  echo "Enterting the terraform cloud workspace name to be looked upas the second parameter is required"
  exit 1
fi

if [ "" != "$3" ]; then
  aws_profile="$3"
fi
echo "Using the $aws_profile aws profile to look up credentials in [~/.aws/credentials]"


#Extract Terraform cloud API token
rawtoken=$(grep "token" ~/.terraformrc | cut -d " " -f 5)
rawtoken=${rawtoken#\"}
token=${rawtoken%\"}

if [ "" == "$token" ]; then
  echo "ERROR: Unable to lookup the terraform cloud api token from: [~/.terraformrc]"
  exit 1
fi

workspaces_api_path=organizations/$tf_org/workspaces
vars_api_path=vars
http_verb=POST

# Look up the workspace id by its name"
workspace_id=
while read -r line ; do
  if [[ "$line" =~ "$workspace_name|"* ]]; then
    # echo "$line"
    workspace_id=${line#*|}
  fi
done <<< $(curl \
  --header "Authorization: Bearer $token" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/$workspaces_api_path | jq -r '.data[] | "\(.attributes.name)|\(.id)"')

if [ "" == "$workspace_id" ]; then
  echo "ERROR: Unable to lookup the terraform cloud workspace: [$workspace_name] for the organization: [$tf_org] "
  exit 1
fi

# Extract default aws credentials to use for the workspace
access=
secret=
while read -r line ; do
    if [[ "$line" =~ aws_access_key_id* ]]; then
      # Trim variable assignment
      access=${line#*=}
      # trim leading space
      access=${access##*[ ]}
    fi
    if [[ "$line" =~ aws_secret_access_key* ]]; then
      # Trim variable assignment
      secret=${line#*=}
      # trim leading space
      secret=${secret##*[ ]}
    fi
done <<< $(grep -a2 $aws_profile ~/.aws/credentials)

if [ "" == "$access" ]; then
  echo "ERROR: Unable to lookup the aws credential aws_access_key_id for the default profile from the following file: [~/.aws/credentials] "
  exit 1
fi
if [ "" == "$secret" ]; then
  echo "ERROR: Unable to lookup the aws credential aws_secret_access_key for the default profile from the following file: [~/.aws/credentials] "
  exit 1
fi

payload1=$(cat <<COMMENTBLOCK
{
  "data": {
    "type":"vars",
    "attributes": {
      "key":"AWS_ACCESS_KEY_ID",
      "value":"$access",
      "category":"env",
      "hcl":false,
      "sensitive":true
    },
    "relationships": {
      "workspace": {
        "data": {
          "id":"$workspace_id",
          "type":"workspaces"
        }
      }
    }
  }
}
COMMENTBLOCK
)

payload2=$(cat <<COMMENTBLOCK
{
  "data": {
    "type":"vars",
    "attributes": {
      "key":"AWS_SECRET_ACCESS_KEY",
      "value":"$secret",
      "category":"env",
      "hcl":false,
      "sensitive":true
    },
    "relationships": {
      "workspace": {
        "data": {
          "id":"$workspace_id",
          "type":"workspaces"
        }
      }
    }
  }
}
COMMENTBLOCK
)

# Post access key
curl \
  --header "Authorization: Bearer $token" \
  --header "Content-Type: application/vnd.api+json" \
  --request $http_verb \
  --data "$payload1" \
  https://app.terraform.io/api/v2/$vars_api_path

# Post secret
curl \
  --header "Authorization: Bearer $token" \
  --header "Content-Type: application/vnd.api+json" \
  --request $http_verb \
  --data "$payload2" \
  https://app.terraform.io/api/v2/$vars_api_path
