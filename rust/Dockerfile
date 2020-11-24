FROM rust:1.48-buster

LABEL maintainer = "Michele Adduci <adduci.michele@gmail.com>" \
    license = "MIT" \
    description = "Development Enviroment for Rust accessible with SSH"

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
    && apt-get -y install git iproute2 procps lsb-release  curl \
    && echo "### Installing lldb" \
    && apt-get install -y lldb python3-minimal libpython3.7 \
    && echo "### Installing Rust components" \
    && rustup update \
    && rustup component add rls rust-analysis rust-src rustfmt clippy \
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
    && rm -rf /var/lib/apt/lists/* \
    && echo "### Configuring sshd daemon" \
    && sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' \
    && mkdir /var/run/sshd

EXPOSE 22

# Add setup-sshd script
COPY --chown=${USERNAME}:root setup-sshd /usr/local/bin/setup-sshd

WORKDIR /home/$USERNAME

ENTRYPOINT ["setup-sshd"]
