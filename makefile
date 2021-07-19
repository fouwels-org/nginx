# SPDX-FileCopyrightText: 2021 Belcan Advanced Solution
#
# SPDX-License-Identifier: MIT

COMPOSE=compose-cli compose
BUILDFILE=build.yml
DOCKER=docker

# Docker
build: 
	$(COMPOSE) -f $(BUILDFILE) build
push:
	$(COMPOSE) -f $(BUILDFILE) push
up:
	$(COMPOSE) -f $(BUILDFILE) up
up-d:
	$(COMPOSE) -f $(BUILDFILE) up -d
down:
	$(COMPOSE) -f $(BUILDFILE) down -d
