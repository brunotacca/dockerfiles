FROM tacca/ubuntu18_jdk7_tomcat7_svn_ant

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

# Environment variables
ENV LANG=pt_BR.UTF-8
ENV LC_ALL=pt_BR.UTF-8

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y rsync vim locales wget; \
    apt-get autoclean && apt-get clean --dry-run; \
# Configure these Locale vars for your need.
    locale-gen en_US en_US.UTF-8 pt_BR.UTF-8; \
    echo "Brazil/East" > /etc/timezone; \
    update-locale LANG=pt_BR.UTF-8; \
# Postgresql JDBC - JDK7
    wget https://jdbc.postgresql.org/download/postgresql-42.2.12.jre7.jar; \
    mv postgresql-42.2.12.jre7.jar $CATALINA_HOME/lib; \
# base configuration for server.xml
    wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/brunotacca/dockerfiles/master/unesp_sisproex_environment/server.xml; \
    mv server.xml $CATALINA_HOME/conf/; \
# svn download and build shell script
    wget  --no-check-certificate --content-disposition https://raw.githubusercontent.com/brunotacca/dockerfiles/master/unesp_sisproex_environment/svn_download_build_java.sh; \
    mv svn_download_build_java.sh /usr/local/bin; \
    chmod +x /usr/local/bin/svn_download_build_java.sh;\ 
# project specific - sisproex 
# path used in build.xml
    ln -s $CATALINA_HOME/ /usr/share/; \
# log folder
    mkdir -p /SISTEMAS/logs; \
    chmod 777 -R /SISTEMAS; \
# mark to hold the later usage packages.
    apt-mark hold rsync vim locales; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*;

CMD ["tail", "-f", "/dev/null"]