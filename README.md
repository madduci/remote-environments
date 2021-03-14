# remote-environments

Collection of Docker-based development environments accessible via SSH, using public-key authentication.

Inspired by Microsoft's [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) Visual Studio Code extension, it allows you to develop in a Docker container with your preferred language.

## Requirements

* Docker CE/EE 18.06+
* docker-compose 1.24+
* A ssh client (e.g. `openssh` on Linux)
* A ssh key (e.g. `ssh-keygen` on Linux)
* Visual Studio Code with Remote SSH extension (optional)

## How to build images

There's a `Makefile` available in the repository, you can execute one of the following commands:

```shell
make cpp
make go
make java
make javascript
make php
make python
make rust
```

The above commands will build the desired environment(s).

By typing `make`, all the environments will be built automatically.

To force a rebuild, append the flag `-B` to the make command

## How to run containers

You need to configure the `docker-compose.yml` file for the desired environment, by setting the path to your local public key (on Linux, stored in `~/.ssh/`) that will be used with SSH.

After that, you can start the environments with the following commands:

```shell
make cpp-start
make go-start
make java-start
make javascript-start
make php-start
make python-start
make rust-start
```

The environments will be available at ports starting from 22221, listening on the `localhost` address.

The default user is `builder`, so if you want to connect to the docker environment, just type (e.g. the C++ environment):

`ssh builder@localhost -p22221`

### Port Mapping

The environments expose the following ports:

| Environment  | Docker Host  | Docker Container  | 
|--------------|--------------|-------------------|
| C++          | 22221        | 22  |
| Go           | 22222        | 22  |
| Java         | 22223        | 22  |
| PHP          | 22224        | 22  |
| Python       | 22225        | 22  |
| Rust         | 22226        | 22  |
| Javascript   | 22227        | 22  |

## How to stop containers

You can stop the containers by typing:

```shell
make cpp-stop
make go-stop
make java-stop
make javascript-stop
make php-stop
make python-stop
make rust-stop
```

And the environment will be stopped, without losing its content.
To perform a cleanup, call directly the `docker-compose.yml` file you are interested in or issue the command `make clean` and all the running containers will be stopped.

## Gotchas

* VSCodium, the stripped version of Visual Studio Code **does not work** since it requires closed source components only available in Code
  
* Every time you rebuild an image and start a desired environment, you have to cleanup your list of authorized keys in your SSH client (in Linux, usually the file ~/.ssh/known_hosts)

* If you want to save your work outside the container, you have three options:
  - use the `git` command to save your work to a remote repository (e.g. GitHub, GitLab, BitBucket)
  - use the `docker cp` command to copy files and/or folders on your host
  - modify the `docker-compose.yml` file(s) and mount a custom path as volume in the container. Be sure you have the required permissions to read/write files in the mounted volume.