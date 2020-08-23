#!/usr/bin/env make
#
# NOTE: Make target cannot be the name of a runtime argument, otherwise Makefile
# will go into an infinite loop.

.PHONY: version check setup run start

export APP_VERSION ?= $(shell git rev-parse --short HEAD)
export GIT_REPO_ROOT ?= $(shell git rev-parse --show-toplevel)

export DOCKER_IMAGE_NAME ?= softwareabstractions

export USERID ?= $(shell id -u $(whoami))
export GROUPID ?= $(shell id -g $(whoami))

version:
	@echo '{"Version": "$(APP_VERSION)"}'

# Start the development server.
#
# NOTE: Make sure to have your SSH credentials mounted in ~/.ssh.
check:
	@echo "Checking system dependencies..."
	# GNU Make 4.2.1
	# Built for x86_64-pc-linux-gnu
	# Copyright (C) 1988-2016 Free Software Foundation, Inc.
	# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
	# This is free software: you are free to change and redistribute it.
	# There is NO WARRANTY, to the extent permitted by law.
	@echo $$(make --version)
	# Docker version 19.03.8, build afacb8b7f0
	@echo $$(docker --version)
	# git version 2.27.0
	@echo $$(git --version)

docker-build:
	docker build \
		--file ./Dockerfile \
		--tag $(DOCKER_IMAGE_NAME):$(APP_VERSION) \
		.

# From: https://stackoverflow.com/a/14061796
# If the first argument is "run"...
ifeq (docker-run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

export JAVA_6=jdk1.6.0_45
export ALLOY_JAR=alloy4.2_2015-02-22.jar
export XSOCK=/tmp/.X11-unix

# Lifts command into `docker run` context.
#
# See this blog post for Dockerizing a React.js application:
# https://mherman.org/blog/dockerizing-a-react-app/#docker
docker-run: docker-build
	docker run \
		--rm \
		-it \
		-v $(shell pwd):/app \
		-v $(shell pwd)/$(JAVA_6):/opt/$(JAVA_6) \
		-v $(shell pwd)/$(ALLOY_JAR):/opt/$(ALLOY_JAR) \
		-v $(XSOCK):$(XSOCK) \
		-e DISPLAY=$(DISPLAY) \
		--net=host \
		$(DOCKER_IMAGE_NAME):$(APP_VERSION) \
		bash -c "$(RUN_ARGS)"

docker-bash:
	$(MAKE) docker-run bash

docker-alloy:
	$(MAKE) docker-run 'java -jar /opt/$(ALLOY_JAR)'
