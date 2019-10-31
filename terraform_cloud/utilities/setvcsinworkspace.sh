#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191030-115248
#
# Purpose and References:
#
#
# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
set -e #errexit
# set -u #nounset

terraform_version="0.12.12"
tf_org=$1
workspace_name=$2
repo_user=$3
repo_name=$4
repo_path=$5
repo_branch=$6

function usage {
  echo "############################################################"
  echo "USAGE:"
  echo " "
  echo "  Name: $0"
  echo " "
  echo "  Description: "
  echo "      This script is used to set version control configuration on your workspace after"
  echo "      you have created your workspace with a terraform init."
  echo " "
  echo " "
  echo "  Command inputs:"
  echo " "
  echo '      $1 = Terraform Cloud organizations name'
  echo '      $2 = Terraform Cloud workspace name (same as in your terraform backend configuration)'
  echo '      $3 = Your Github user name'
  echo '      $4 = Your Github repo name'
  echo '      $5 = The path in your github repo where the terraform code is i.e. the working directory'
  echo '      $6 = The branch of code your working directory should be using.'
  echo " "
  echo " "
  echo "  Additional Notes:"
  echo "      This script is assuming you have setup a Github OAuth provider in your Github organization."
  echo " "
  echo " "
  echo "     ./$0 terraform_cloud_org_name workspace_name github_user github_repo terraform/terraform_config my_github_branch"
  echo "############################################################"
}

if [ "" == "$1" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "     Enterting the terraform cloud organization name as the first parameter is required"
  echo " "
  exit 1
fi

if [ "" == "$2" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "     Enterting the terraform cloud workspace name to be looked upas the second parameter is required"
  echo " "
  exit 1
fi

if [ "" == "$3" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "     Enterting the Github repo user is required."
  echo " "
  exit 1
fi

if [ "" == "$4" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "      Enterting the Github repo name is required."
  echo " "
  exit 1
fi

if [ "" == "$5" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "     Enterting the Github repo path user is required. (This is your terraform working directory!)"
  echo " "
  exit 1
fi

if [ "" == "$5" ]; then
  usage
  echo " "
  echo "Error:"
  echo " "
  echo "     Enterting the Github branch user is required."
  echo " "
  exit 1
fi

#Extract Terraform cloud API token
rawtoken=$(grep "token" ~/.terraformrc | cut -d " " -f 5)
rawtoken=${rawtoken#\"}
token=${rawtoken%\"}
http_verb=GET

if [ "" == "$token" ]; then
  echo "ERROR: Unable to lookup the terraform cloud api token from: [~/.terraformrc]"
  exit 1
fi

# Here we look up the client OAuth id - We are assuming only a single oauth client TODO: Add more robust code if and when we need more clients.
oauth_clients_api_path=organizations/$tf_org/oauth-clients
tf_oauth_client_id=
tf_oauth_client_id_output=$(curl --header "Authorization: Bearer $token" --header "Content-Type: application/vnd.api+json" --request $http_verb https://app.terraform.io/api/v2/$oauth_clients_api_path)

if [ "" != "$(echo "$tf_oauth_client_id_output" | jq -r '.errors')" ]; then
  tf_oauth_client_id=$( echo "$tf_oauth_client_id_output" | jq -r ".data[0] | .id")
else
  echo " "
  echo "Error requesting the OAuth clients confirgured for Terraform Cloud: see responsse below"
  echo " "
  echo "$tf_oauth_client_id_output" | jq -r "."
  echo " "
  exit 1
fi

# Here we look up the token id for the OAuth client so it can be set on the workspace
oauth_clients_tokens_api_path=oauth-clients/$tf_oauth_client_id/oauth-tokens
tf_oauth_token_id=
tf_oauth_token_id_output=$(curl --header "Authorization: Bearer $token" https://app.terraform.io/api/v2/$oauth_clients_tokens_api_path)

if [ "" != "$(echo "$tf_oauth_token_id_output" | jq -r '.errors')" ]; then
  tf_oauth_token_id=$( echo "$tf_oauth_token_id_output" | jq -r '.data[0] | .id')
  if [ "" == "$tf_oauth_token_id" ]; then
    echo " "
    echo "Error parsing the OAuth client token id from the response: see responsse below"
    echo " "
    echo "$tf_oauth_token_id_output" | jq -r "."
    echo " "
    exit 1
  fi
else
  echo " "
  echo "Error requesting the OAuth client token id: see responsse below"
  echo " "
  echo "$tf_oauth_token_id_output" | jq -r "."
  echo " "
  exit 1
fi

workspace_update_api_path=organizations/$tf_org/workspaces/$workspace_name
http_verb=PATCH
payload=$(cat <<COMMENTBLOCK
{
  "data": {
    "attributes": {
      "name": "$workspace_name",
      "terraform_version": "$terraform_version",
      "working-directory": "$repo_path",
      "vcs-repo": {
        "identifier": "$repo_user/$repo_name",
        "branch": "$repo_branch",
        "ingress-submodules": false,
        "oauth-token-id": "$tf_oauth_token_id"
      }
    },
    "type": "workspaces"
  }
}
COMMENTBLOCK
)

# echo "$payload" | jq -r "."

# # Patch workspace attributes
workspace_update_output=$(curl \
  --header "Authorization: Bearer $token" \
  --header "Content-Type: application/vnd.api+json" \
  --request $http_verb \
  --data "$payload" \
  https://app.terraform.io/api/v2/$workspace_update_api_path)

echo "$workspace_update_output" | jq -r "."
