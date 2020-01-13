# Inspired by https://tech.davis-hansson.com/p/make/

# Use bash
SHELL := bash
# Set bash strict mode and enable warnings
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
# Making steps silent - don't print all the commands to output
.SILENT:

# Disable usage of tabs
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

all: cpp go java php python
> echo "All Docker images built"
.PHONY: all

cpp: cpp/.built
> echo "C++ Docker Image built successfully"
.PHONY: cpp

cpp-start: cpp
> docker-compose -f ./cpp/docker-compose.yml up -d
.PHONY: go-start

cpp-stop: cpp
> docker-compose -f ./cpp/docker-compose.yml down
.PHONY: go-stop

go: go/.built
> echo "Go Docker Image built successfully"
.PHONY: go

go-start: go
> docker-compose -f ./go/docker-compose.yml up -d
.PHONY: go-start

go-stop: go
> docker-compose -f ./go/docker-compose.yml down
.PHONY: go-stop

java: java/.built
> echo "Java Docker Image built successfully"
.PHONY: java

php: php/.built
> echo "PHP Docker Image built successfully"
.PHONY: php

python: python/.built
> echo "Python Docker Image built successfully"
.PHONY: python

clean: 
.PHONY: clean

cpp/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag cpp-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore

go/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag go-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore

java/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag java-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore

php/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag php-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore

python/.built: 
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag python-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore
