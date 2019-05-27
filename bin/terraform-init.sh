#!/usr/bin/env sh

set -e

cd manifests

terraform init \
    -backend-config="storage_account_name=${TF_VAR_terraform_storage_account_name}" \
    -backend-config="resource_group_name=${TF_VAR_terraform_resource_group_name}"
