FROM  openjdk:13-jdk-slim-buster

LABEL maintainer = "Michele Adduci <adduci.michele@gmail.com>" \
      license = "MIT" \
      description = "Development Enviroment for Java accessible with SSH"

# Define non-root user
ARG USERNAME=builder
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV USERNAME=${USERNAME}

# Define Maven information
ARG MAVEN_VERSION=3.6.3
ARG MAVEN_SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ENV MAVEN_HOME=/usr/local/share/maven

RUN DEBIAN_FRONTEND=noninteractive \
    && echo "### Configure apt, install openssh-server, dialog and tools" \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        apt-utils \
        openssh-server \
        dialog 2>&1 \
    && echo "### Installing git, process tools and lsb-release" \
    && apt-get -y install git iproute2 procps lsb-release curl apt-transport-https gnupg2 \
    && echo "### Installing Maven" \
    && mkdir -p ${MAVEN_HOME} ${MAVEN_HOME}/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "${MAVEN_SHA} /tmp/apache-maven.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/apache-maven.tar.gz -C ${MAVEN_HOME} --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s ${MAVEN_HOME}/bin/mvn /usr/local/bin/mvn \
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
    && mkdir /var/run/sshd

EXPOSE 22

# Add setup-sshd script
COPY --chown=${USERNAME}:root setup-sshd /usr/local/bin/setup-sshd

WORKDIR /home/$USERNAME

ENTRYPOINT ["setup-sshd"]