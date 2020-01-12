# Use Bash as Shell
SHELL := /bin/bash
# Use single shell instance
.ONESHELL:
# Use '>' as indentation character
.RECIPEPREFIX = >
# Suppress output of commands
.SILENT:

all: cpp go java php python
> echo "All Docker images built"
.PHONY: all

cpp: cpp/.built
> echo "C++ Docker Image built successfully"
.PHONY: cpp

go: go/.built
> echo "Go Docker Image built successfully"
.PHONY: go

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

go/.built:
> cp setup-sshd $(@D)/
> cp .dockerignore $(@D)/
> docker build --no-cache --tag go-ssh-env:latest -f $(@D)/Dockerfile $(@D)
> echo $$(date --iso-8601) > $(@D)/.built
> rm $(@D)/setup-sshd
> rm $(@D)/.dockerignore

java/.built:
php/.built:
python/.built: 