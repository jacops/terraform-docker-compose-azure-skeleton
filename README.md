# Terraform 0.12 Docker Compose Skeleton For Azure

## Use locally

To run terraform scripts locally you should use your own AD account, so that accountability is visualised in resource activity logs. Otherwise use service accounts (likely with different permission models per stack) in CI/CD environemt of your choice.

### Prerequisites

To use this repository you just need Docker and Docker Compose although it's possible to run commands within a local context of Terraform.

### Setup

1. Either run `make setup` or:
    * Create `.env` file from `.env.dist`
    * Create `docker-compose.local.yml` file from `docker-compose.local.yml.dist`

2. Populate `.env` file with basic values:
    * `ENVIRONMENT`: name of the environment to be deployed/managed
    * `ARM_SUBSCRIPTION_ID`: subscription ID where the environment will be deployed
    * `ARM_TENANT_ID`: AAD Tenant ID
    
3. Run `make` or `make build` to build Docker image, which includes Terraform and Azure cli

4. Login to Azure cli: `make az-login`

5. Create or get storage account for holding state files: `make backend-create`
    
6. Populate `.env` file with terraform backend values:
    * `TERRAFORM_STORAGE_ACCOUNT_NAME`: backend storage account name
    * `TERRAFORM_RESOURCE_GROUP_NAME`: backed storage account resource group name
    * `TERRAFORM_STORAGE_ACCOUNT_ACCESS_KEY`: access key used to connect to storage account
    
### Execution

This repository contains a `Makefile`, which main purpose is to wrap `docker-compose` commands into single task.

Few tasks, that speed up development and testing:

* `make build` - build terraform docker image for local usage
* `make setup` - setup local repo for local usage
* `make az-login` - authenticate your personal account against Azure
* `make backend-destroy` - destroy backend for the state files

And wrapped terraform commands:

* `make init` - initialise stack
* `make plan` - plan changes
* `make apply` - apply changes

To run other terraform commands, which are not in `Makefile`, please run:
```bash
docker-compose run --rm terraform [COMMAND]
```

## Notes

* Please don't store any secrets in state files if possible.
* Tag resources as much as possible, but don't go crazy
* Don't make stacks complex. Create a new one to simplify management of resources and reference them in other stacks when required
* Don't use default values for variables too often
