FROM tacca/ubuntu18_jdk7_tomcat7_svn_ant

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

# Environment locale variables
ENV LANG=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8
ENV TZ=Brazil/East
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y rsync vim locales wget tzdata; \
    apt-get autoclean && apt-get clean --dry-run; \
# Configure these Locale vars for your need.
    locale-gen en_US en_US.UTF-8 pt_BR.UTF-8; \
    echo "Brazil/East" > /etc/timezone; \
    update-locale LANG=pt_BR.UTF-8; \
    ln -fs /usr/share/zoneinfo/Brazil/East /etc/localtime; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
# Postgresql JDBC - JDK7
    wget https://jdbc.postgresql.org/download/postgresql-42.2.12.jre7.jar; \
    mv postgresql-42.2.12.jre7.jar $CATALINA_HOME/lib; \
# HikariCP JDK7
    wget https://repo1.maven.org/maven2/com/zaxxer/HikariCP-java7/2.4.13/HikariCP-java7-2.4.13.jar; \
    mv HikariCP-java7-2.4.13.jar $CATALINA_HOME/lib; \
# SLF4J (Hikari dependency)
    wget https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar; \
    mv slf4j-api-1.7.30.jar $CATALINA_HOME/lib; \
# mark to hold the later usage packages.
    apt-mark hold rsync vim locales tzdata; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*;

CMD ["tail", "-f", "/dev/null"]
