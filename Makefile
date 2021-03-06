.PHONY: help build build-test run-build publish release lint test-unit test-e2e
.DEFAULT_GOAL := help

SERVICE_IMAGE_NAME=urlinsane-ui
PROJECT_ID=cyberse
SERVICE_REGION=us-central1
SERVICE_ID=cybersectech-ui
BUILD_CMD=docker build
REPOSITORY_URI=gcr.io

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

login-gcr: ## docker login to repository account
	docker login https://$(REPOSITORY_URI)

build: ## builds service docker container
	$(BUILD_CMD) --target serve -t $(SERVICE_IMAGE_NAME) .

publish: ## builds docker container in gcr
	gcloud builds submit --tag $(REPOSITORY_URI)/$(PROJECT_ID)/$(SERVICE_IMAGE_NAME)

pull-build: ## pulls docker container from gcr
	docker pull $(REPOSITORY_URI)/$(PROJECT_ID)/$(SERVICE_IMAGE_NAME)

deploy: publish ## deploys the service
	gcloud beta run deploy --region=$(SERVICE_REGION) $(SERVICE_ID) --image $(REPOSITORY_URI)/$(PROJECT_ID)/$(SERVICE_IMAGE_NAME)

run-build: build ## runs docker container locally reachable at http:://localhost:8080
	docker run --name $(SERVICE_IMAGE_NAME) --rm -p 8080:8080 --env .env $(SERVICE_IMAGE_NAME)
