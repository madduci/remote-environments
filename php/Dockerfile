FROM php:8.2-apache

LABEL maintainer = "Michele Adduci <adduci@tutanota.com>" \
      license = "MIT" \
      description = "Development Enviroment for PHP accessible with SSH"

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
    && apt-get -y install git iproute2 procps lsb-release curl \
    && echo "### Installing composer" \
    && curl -L https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer \
    && chmod +x  /usr/local/bin/composer \
    && echo "### Installing xdebug" \
    && yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
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
    && mkdir /var/run/sshd \
    && chown -R $USERNAME /var/www/html

EXPOSE 22

# Add setup-sshd script
COPY --chown=${USERNAME}:root setup-sshd /usr/local/bin/setup-sshd

WORKDIR /home/$USERNAME

 CMD [ "setup-sshd" ]