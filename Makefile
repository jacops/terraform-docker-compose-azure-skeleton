.PHONY: bin data images modules stacks
.DEFAULT_GOAL := build

build:
	docker-compose build terraform

setup:
	cp -n .env.dist .env
	cp -n docker-compose.local.yml.dist docker-compose.local.yml

az-login:
	docker-compose run --rm az-login

backend-create:
	docker-compose run --rm backend-create

backend-destroy:
	docker-compose run --rm backend-destroy

remove-local-backends:
	find . -name "terraform.tfstate" -exec rm -r "{}" \;

env-dev: remove-local-backends
	cp -rf .env .env-prev
	cp -rf .env-dev .env
	bin/dev/tf-vars.sh dev

env-qa: remove-local-backends
	cp -rf .env .env-prev
	cp -rf .env-qa .env
	bin/dev/tf-vars.sh qa
	
env-prod: remove-local-backends
	cp -rf .env .env-prev
	cp -rf .env-prod .env
	bin/dev/tf-vars.sh prod

##########################################################################
#######################            JOBS            #######################
##########################################################################

init:
	docker-compose run --rm terraform-init

plan:
	docker-compose run --rm terraform plan -out tfplan

apply:
	docker-compose run --rm terraform apply tfplan