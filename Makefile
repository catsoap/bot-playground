.PHONY: dev help install tg-cleanup tg-updates tg-webhook tg-webhook-delete tg-webhook-info

SHELL := /bin/bash

default: help

define read_env
	@set -o allexport && source .env && set +o allexport
endef

#######################################
#               APP                   #
#######################################
dev: ## to start the local server
	@if [ ! -f .env -a -f .env.dist ]; then cp .env.dist > .env; fi
	@$(call read_env) && scripts/tg.sh webhook-check
	@firebase serve

install: ## to install dependencies
	 @npm i --prefix functions

#######################################
#             TELEGRAM                #
#######################################
tg-cleanup: ## to cleanup pending updates
	make tg-webhook-delete
	@$(call read_env) && scripts/tg.sh cleanup

tg-updates: ## to poll updates
	@$(call read_env) && scripts/tg.sh updates | jq

tg-webhook: ## to update the webhook (make webhook URL=https://xxx.yy or empty to delete)
	@$(call read_env) && scripts/tg.sh webhook-set $(URL)| jq

tg-webhook-delete: ## to delete webhook
	@$(call read_env) && scripts/tg.sh webhook-delete | jq

tg-webhook-info: ## to get info about webhook
	@$(call read_env) && scripts/tg.sh webhook-info | jq

#######################################
#               MISC                  #
#######################################
help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
