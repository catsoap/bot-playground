.PHONY: config deploy dev help webhook cleanup

default: help

BOT_TOKEN = $(shell jq -r '.bot.token' .runtimeconfig.json | sed 's/\"//g')

#######################################
#             FIREBASE                #
#######################################
config: ## to create a local configuration file
	@firebase functions:config:get > .runtimeconfig.json
	@echo '.runtimeconfig.json' created
	@echo "\e[1m\e[33mDon't forget to override parameters!"

deploy: ## to run firebase deploy
	@firebase deploy

dev: ## to start the local server
	@firebase serve

#######################################
#             TELEGRAM                #
#######################################
cleanup: ## to cleanup pending updates
	@curl -s https://api.telegram.org/bot$(BOT_TOKEN)/deleteWebhook | jq
	@updateID=$(shell curl -s https://api.telegram.org/bot1129141864:AAGz5ZTR1IphVyNwUVdWCSBmYbOoVveQn9s/getUpdates | jq '.result[-1].update_id') ; \
	if [ "$$updateID" != null ]; then \
		offset=`expr $$updateID + 1` ; \
		curl -s https://api.telegram.org/bot$(BOT_TOKEN)/getUpdates?offset=$$offset | jq; \
	fi;

updates: ## to poll updates
	@curl -s https://api.telegram.org/bot$(BOT_TOKEN)/getUpdates | jq

webhook: ## to update the webhook (make webhook URL=https://xxx.yy or empty to delete)
	@curl -F "url=$(URL)" https://api.telegram.org/bot$(BOT_TOKEN)/setWebhook

#######################################
#               MISC                  #
#######################################
help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
