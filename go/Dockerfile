FROM golang:1.13-buster

LABEL maintainer = "Michele Adduci <adduci.michele@gmail.com>" \
      license = "MIT" \
      description = "Development Enviroment for Go accessible with SSH"

# Define non-root user
ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV USERNAME=${USERNAME}

RUN DEBIAN_FRONTEND=noninteractive \
    && echo "### Configure apt, install openssh-server, dialog and tools" \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        openssh-server \
        dialog 2>&1 \
    && echo "### Installing git, process tools and lsb-release" \
    && apt-get -y install git iproute2 procps lsb-release \
    && echo "### Installing gocode-gomod" \
    && go get -x -d github.com/stamblerre/gocode 2>&1 \
    && go build -o gocode-gomod github.com/stamblerre/gocode \
    && mv gocode-gomod $GOPATH/bin/ \
    && echo "### Setting go binary path" \
    && update-alternatives --install /usr/bin/go go /usr/local/go/bin/go 1 \
    && echo "### Installing Go tools" \
    && go get -u -v \
        github.com/mdempsky/gocode \
        github.com/uudashr/gopkgs/cmd/gopkgs \
        github.com/ramya-rao-a/go-outline \
        github.com/acroca/go-symbols \
        github.com/godoctor/godoctor \
        golang.org/x/tools/cmd/guru \
        golang.org/x/tools/cmd/gorename \
        github.com/rogpeppe/godef \
        github.com/zmb3/gogetdoc \
        github.com/haya14busa/goplay/cmd/goplay \
        github.com/sqs/goreturns \
        github.com/josharian/impl \
        github.com/davidrjenni/reftools/cmd/fillstruct \
        github.com/fatih/gomodifytags \
        github.com/cweill/gotests/... \
        golang.org/x/tools/cmd/goimports \
        golang.org/x/lint/golint \
        golang.org/x/tools/gopls \
        github.com/alecthomas/gometalinter \
        honnef.co/go/tools/... \
        github.com/golangci/golangci-lint/cmd/golangci-lint \
        github.com/mgechev/revive \
        github.com/derekparker/delve/cmd/dlv 2>&1 \
    && echo "### Creating non-root user ${USERNAME}" \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "### Adding ${USERNAME} to sudoers" \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && echo "### Cleaning up" \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /go/src \
    && echo "### Configuring sshd daemon" \
    && sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
    && mkdir -p /var/run/sshd
    
EXPOSE 22

# Add setup-sshd script
COPY --chown=${USERNAME}:root setup-sshd /usr/local/bin/setup-sshd

WORKDIR /home/$USERNAME

ENTRYPOINT ["setup-sshd"]