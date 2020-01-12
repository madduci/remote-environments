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