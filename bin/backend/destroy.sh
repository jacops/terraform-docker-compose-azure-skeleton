#!/usr/bin/env bash

set -euo pipefail

function usage {
    echo "Usage: $0 -e <env> -s <arm subscription id> -l <location>"; exit 1;
}

while getopts "s:e:" opt; do
    case $opt in
        s)
            ARM_SUBSCRIPTION_ID=$OPTARG
        ;;
        e)
            ENVIRONMENT=$OPTARG
        ;;
    esac
done

if [[ -z "${ENVIRONMENT}" || -z "${ARM_SUBSCRIPTION_ID}" ]]; then
    usage
fi

RESOURCES_PREFIX="te-${ENVIRONMENT}-"
TERRAFORM_RG_NAME="${RESOURCES_PREFIX}terraform-rg"

az account set --subscription "$ARM_SUBSCRIPTION_ID"

echo "Remove Terraform RG"
az group delete -n "$TERRAFORM_RG_NAME" -y