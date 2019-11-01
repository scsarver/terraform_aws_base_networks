#!/usr/bin/env bash
#
# Created By: stephansarver
# Created Date: 20191031-144555
#
# Purpose and References:
#
#
# Where you want the options to take effect, use set -o option-name or, in short form, set -option-abbrev, To disable an option within a script, use set +o option-name or set +option-abbrev: https://www.tldp.org/LDP/abs/html/options.html
set +x #xtrace
set +v #verbose
set -e #errexit
set -u #nounset


if [ "" == "$1" ]; then
  echo "Enterting the aws account number to assume into as the first parameter is required"
  exit 1
fi

if [ "" == "$2" ]; then
  echo "Enterting the the profile name to setup the temp credentials as the second parameter is required"
  exit 1
fi

aws_account=$1
aws_profile="$2"

aws_shared_credentials_file='~/.aws/credentials'

aws_account_default_region="us-east-1"
aws_account_provider_prefix='arn:aws:iam::'
aws_account_provider_suffix=':role/'
aws_account_provider_role='OrganizationAccountAccessRole'

aws_account_provider_arn="$aws_account_provider_prefix$aws_account$aws_account_provider_suffix$aws_account_provider_role"
aws_account_provider_session="assume-role-session-$aws_account-$aws_account_provider_role"
aws_assumed_role_out_file='awstmp'


unset AWS_PROFILE

assume_out=$((aws sts assume-role --role-arn $aws_account_provider_arn --role-session-name $aws_account_provider_session)2>&1)
touch $aws_assumed_role_out_file
echo "$assume_out" |  jq -r '.Credentials.AccessKeyId, .Credentials.SecretAccessKey, .Credentials.SessionToken'>$aws_assumed_role_out_file

aws configure set aws_access_key_id $(sed -n '1p' $aws_assumed_role_out_file) --profile $aws_profile
aws configure set aws_secret_access_key $(sed -n '2p' $aws_assumed_role_out_file) --profile $aws_profile
aws configure set aws_session_token $(sed -n '3p' $aws_assumed_role_out_file) --profile $aws_profile
aws configure set region "$aws_account_default_region" --profile $aws_profile

# Remove the tmp file writen to when storing the sts response.
rm "$aws_assumed_role_out_file"


echo " "
echo " "
echo "To use temp AWS credentials requires you to set your profile in ENV variables:"
echo "          export AWS_PROFILE=$aws_profile"
echo " "
echo "To revert back unset the ENV variable for profile:"
echo "          unset AWS_PROFILE"
