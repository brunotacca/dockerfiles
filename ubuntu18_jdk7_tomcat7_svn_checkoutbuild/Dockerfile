FROM tacca/ubuntu18_jdk7_tomcat7_svn

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

# Environment variables
ENV ANT_HOME=/usr/local/ant
ENV PATH=${ANT_HOME}/bin:${PATH};
ENV LANG=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y rsync vim locales wget; \
    \
    #
    # Ant old version (Supports JDK7)
    wget  http://ftp.unicamp.br/pub/apache//ant/binaries/apache-ant-1.9.14-bin.tar.gz; \
    tar -xf apache-ant-1.9.14-bin.tar.gz  -C /usr/local; \
    ln -s /usr/local/apache-ant-1.9.14/ /usr/local/ant; \
    echo "export ANT_HOME=/usr/local/ant" >> /etc/profile; \
    export ANT_HOME=/usr/local/ant; \
    rm apache-ant-1.9.14-bin.tar.gz; \
    #
    # Configure these Locale vars for your need.
    locale-gen en_US en_US.UTF-8 pt_BR.UTF-8; \
    echo "Brazil/East" > /etc/timezone; \
    echo "export LANG=pt_BR.UTF-8" >> /etc/profile; \
    echo "export LC_ALL=pt_BR.UTF-8" >> /etc/profile; \
    update-locale LANG=pt_BR.UTF-8; \
    export TERM=xterm-256color; \
    export LANG=pt_BR.UTF-8; \
    export LC_ALL=pt_BR.UTF-8; \
    source /etc/profile; \
    #
    # mark to hold the later usage packages.
	apt-mark hold rsync vim locales; \
    apt-get autoclean && apt-get clean --dry-run; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
    \
    echo "hi";

# Reload profile
SHELL ["/bin/bash", "-c", "source /etc/profile"]
