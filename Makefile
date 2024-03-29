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

all: cpp go java javascript php python rust 
> echo "All Docker images built"
.PHONY: all

cpp: cpp/.built
> echo "C++ Docker Image built successfully"
.PHONY: cpp

cpp-start: cpp
> docker-compose -f ./cpp/docker-compose.yml up -d
.PHONY: cpp-start

cpp-stop: cpp
> docker-compose -f ./cpp/docker-compose.yml stop
.PHONY: cpp-stop

go: go/.built
> echo "Go Docker Image built successfully"
.PHONY: go

go-start: go
> docker-compose -f ./go/docker-compose.yml up -d
.PHONY: go-start

go-stop: go
> docker-compose -f ./go/docker-compose.yml stop
.PHONY: go-stop

java: java/.built
> echo "Java Docker Image built successfully"
.PHONY: java

java-start: java
> docker-compose -f ./java/docker-compose.yml up -d
.PHONY: java-start

java-stop: java
> docker-compose -f ./java/docker-compose.yml stop
.PHONY: java-stop

javascript: javascript/.built
> echo "Javascript Docker Image built successfully"
.PHONY: javascript

javascript-start: javascript
> docker-compose -f ./javascript/docker-compose.yml up -d
.PHONY: javascript-start

javascript-stop: javascript
> docker-compose -f ./javascript/docker-compose.yml stop
.PHONY: javascript-stop

php: php/.built
> echo "PHP Docker Image built successfully"
.PHONY: php

php-start: php
> docker-compose -f ./php/docker-compose.yml up -d
.PHONY: php-start

php-stop: php
> docker-compose -f ./php/docker-compose.yml stop
.PHONY: php-stop

python: python/.built
> echo "Python Docker Image built successfully"
.PHONY: python

python-start: python
> docker-compose -f ./python/docker-compose.yml up -d
.PHONY: python-start

python-stop: python
> docker-compose -f ./python/docker-compose.yml stop
.PHONY: python-stop

rust: rust/.built
> echo "Rust Docker Image built successfully"
.PHONY: cpp

rust-start: rust
> docker-compose -f ./rust/docker-compose.yml up -d
.PHONY: rust-start

rust-stop: rust
> docker-compose -f ./rust/docker-compose.yml stop
.PHONY: rust-stop

clean: 
> find . -name "docker-compose.yml" -type f -exec docker-compose -f {} stop \;
> find . -name ".built" -type f -exec rm {} \;
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

javascript/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag javascript-ssh-env:latest -f $(@D)/Dockerfile $(@D)
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

rust/.built: 
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag rust-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore
