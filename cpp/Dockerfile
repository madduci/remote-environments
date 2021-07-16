FROM debian:buster

LABEL maintainer = "Michele Adduci <adduci.michele@gmail.com>" \
      license = "MIT" \
      description = "Development Enviroment for C++ accessible with SSH"

# Define non-root user
ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV USERNAME=${USERNAME} \
    CONAN_VERSION=1.38.0  \
    CONAN_TAG=1_38_0 \
    CONAN_REVISIONS_ENABLED=1 \
    CONAN_NON_INTERACTIVE=1 \
    CMAKE_VERSION=3.21.0

RUN DEBIAN_FRONTEND=noninteractive \
    && echo "### Configure apt, install openssh-server, dialog and tools" \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        openssh-server \
        dialog 2>&1 \
    && echo "### Installing git, process tools and lsb-release" \
    && apt-get -y install git iproute2 procps lsb-release curl \
    && echo "### Installing C++ essential tools" \
    && apt-get -y install \
        build-essential \
        cppcheck \
        valgrind \
        gdb \
    && echo "### Installing Conan ${CONAN_VERSION}" \
    && curl -o /tmp/conan.deb -L https://github.com/conan-io/conan/releases/download/${CONAN_VERSION}/conan-ubuntu-64_${CONAN_TAG}.deb \
    && dpkg -i /tmp/conan.deb \
    && echo "### Installing CMake ${CMAKE_VERSION}" \
    && curl -o /tmp/cmake.tar.gz -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz \
    && tar -xzf /tmp/cmake.tar.gz -C /opt/ \
    && update-alternatives --install /usr/bin/cmake cmake /opt/cmake-${CMAKE_VERSION}-Linux-x86_64/bin/cmake 1 \
    && update-alternatives --install /usr/bin/ccmake ccmake /opt/cmake-${CMAKE_VERSION}-Linux-x86_64/bin/ccmake 1 \
    && update-alternatives --install /usr/bin/cpack cpack /opt/cmake-${CMAKE_VERSION}-Linux-x86_64/bin/cpack 1 \
    && update-alternatives --install /usr/bin/ctest ctest /opt/cmake-${CMAKE_VERSION}-Linux-x86_64/bin/ctest 1 \
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

USER ${USERNAME}

RUN echo "### Initializing conan profile for ${USERNAME}" \
    && conan profile new default --detect \
    && conan profile update settings.compiler.libcxx=libstdc++11 default

USER root

ENTRYPOINT ["setup-sshd"]
