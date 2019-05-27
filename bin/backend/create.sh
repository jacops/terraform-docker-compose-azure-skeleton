#!/usr/bin/env bash

set -e

function usage {
    echo "Usage: $0 -e <env> -s <arm subscription id> -l <location>"; exit 1;
}

while getopts "s:l:e:" opt; do
    case $opt in
        s)
            ARM_SUBSCRIPTION_ID=$OPTARG
        ;;
        l)
            ARM_LOCATION=$OPTARG
        ;;
        e)
            ENVIRONMENT=$OPTARG
        ;;
    esac
done

if [[ -z "${ENVIRONMENT}" || -z "${ARM_SUBSCRIPTION_ID}" || -z "${ARM_LOCATION}" ]]; then
    usage
fi

TERRAFORM_RG_NAME="${ENVIRONMENT}-terraform-rg"

az account set --subscription "$ARM_SUBSCRIPTION_ID"

function create_resource_group()
{
    if [[ "$(az group exists --name "$1")" == "false" ]]; then
        echo "Creating $1 resource group..."
        az group create \
            -l "$ARM_LOCATION" \
            -n "$1" > /dev/null
    fi
}

function create_storage_account()
{
    TERRAFORM_STORAGE_ACCOUNT_NAME="tfstate$(cksum <<< "$ARM_SUBSCRIPTION_ID$ENVIRONMENT$1" | cut -f 1 -d ' ')"
    TERRAFORM_STORAGE_ACCOUNT_CONTAINER_NAME="tfstate"

    if [[ "$(az storage account check-name -n "$TERRAFORM_STORAGE_ACCOUNT_NAME" --query "nameAvailable" --output tsv)" == "true" ]]; then
        echo "Creating $TERRAFORM_STORAGE_ACCOUNT_NAME storage account..."
        az storage account create \
            -n "$TERRAFORM_STORAGE_ACCOUNT_NAME" \
            -g "$TERRAFORM_RG_NAME" \
            --location "$ARM_LOCATION" \
            --encryption blob \
            --sku Standard_LRS \
            --https-only true \
            --tags Role=TerraformState Environment=${ENVIRONMENT} > /dev/null
    fi

    if [[ "$(az storage container exists -n "$TERRAFORM_STORAGE_ACCOUNT_CONTAINER_NAME" --account-name "$TERRAFORM_STORAGE_ACCOUNT_NAME" --query "exists" --output tsv)" == "false" ]]; then
        echo "Creating $TERRAFORM_STORAGE_ACCOUNT_CONTAINER_NAME container..."
        az storage container create \
            -n "$TERRAFORM_STORAGE_ACCOUNT_CONTAINER_NAME" \
            --account-name "$TERRAFORM_STORAGE_ACCOUNT_NAME" > /dev/null
    fi
    echo "Environment: ${ENVIRONMENT}"
    echo "TERRAFORM_STORAGE_ACCOUNT_NAME=$TERRAFORM_STORAGE_ACCOUNT_NAME"
    echo "TERRAFORM_RESOURCE_GROUP_NAME=$TERRAFORM_RG_NAME"
    echo "TERRAFORM_STORAGE_ACCOUNT_ACCESS_KEY=$(az storage account keys list --resource-group "$TERRAFORM_RG_NAME" --account-name "$TERRAFORM_STORAGE_ACCOUNT_NAME" --query "[].value | [0]" --output tsv)"
}

create_resource_group "${TERRAFORM_RG_NAME}"
create_storage_account