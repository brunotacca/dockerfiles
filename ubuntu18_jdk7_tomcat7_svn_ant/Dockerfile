FROM tacca/ubuntu18_jdk7_tomcat7_svn

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y wget; \
    apt-get autoclean && apt-get clean --dry-run; \
    # Ant 1.9.15 - JDK7 Compatible.
    wget https://downloads.apache.org//ant/binaries/apache-ant-1.9.15-bin.tar.gz; \
    tar -xf apache-ant-1.9.15-bin.tar.gz  -C /usr/local; \
    ln -s /usr/local/apache-ant-1.9.15/ /usr/local/ant; \
    rm apache-ant-1.9.15-bin.tar.gz; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; 

ENV ANT_HOME=/usr/local/ant
ENV PATH=${ANT_HOME}/bin:${PATH};
