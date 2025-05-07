#!/usr/bin/env bash

source ../../scripts/switch-terraform-version.sh
export TF_WORKSPACE=development
export TF_VAR_management_role=operator
export TF_VAR_default_role=operator
export TF_VAR_timestream_connector_artifact_name=bootstrap
export TF_CLI_ARGS_init="-backend-config=\"assume_role={role_arn=\\\"arn:aws:iam::311462405659:role/operator\\\"}\" -upgrade -reconfigure"

aws-vault exec identity -- terraform init
all_aws_access_keys=$(aws-vault exec identity --  terraform state list | grep aws_api_gateway_api_key | sed 's/*//g')
for access_key in $all_aws_access_keys
do
  aws-vault exec identity -- terraform taint $access_key
done
