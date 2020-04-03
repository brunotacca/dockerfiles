#FROM tacca/ubuntu18_jdk7
#LABEL maintainer="Bruno V. Tacca"

FROM ubuntu:18.04

LABEL maintainer="Bruno V. Tacca"

# Environment variables
ENV JAVA_HOME=/usr/local/java/jdk1.7.0_80
ENV JRE_HOME=/usr/local/java/jdk1.7.0_80
ENV PATH=$PATH:$JRE_HOME/bin:$JAVA_HOME/bin
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.103
# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl dpkg-dev gcc libapr1-dev libssl-dev make; \
    apt-get autoclean && apt-get clean --dry-run; \
    curl -v -O -L -k https://softwarepublico.gov.br/social/citsmart/versoes-estaveis/jdk-7u80-linux-x64.tar.gz; \
    curl -v -O -L -k http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz; \
    mkdir -p /usr/local/java; \
    mv jdk-7u80-linux-x64.tar.gz /usr/local/java/; \
    cd /usr/local/java; \
    tar xvzf jdk-7u80-linux-x64.tar.gz; \
    rm /usr/local/java/jdk-7u80-linux-x64.tar.gz; \
    cd /; \
    mkdir -p $CATALINA_HOME; \
    mv apache-tomcat-$TOMCAT_VERSION.tar.gz $CATALINA_HOME/tomcat.tar.gz; \
    cd $CATALINA_HOME; \
    tar -xf tomcat.tar.gz --strip-components=1; \
    rm bin/*.bat; \
    rm tomcat.tar.gz*; \
# https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Default_web_applications
    mv webapps webapps.dist; \
    mkdir webapps; \
# we don't delete them completely because they're frankly a pain to get back for users who do want them, and they're generally tiny (~7MB)
    nativeBuildDir="$(mktemp -d)"; \
    tar -xf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
    ( \
        export CATALINA_HOME="$PWD"; \
        cd "$nativeBuildDir/native"; \
        gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
        aprConfig="$(command -v apr-1-config)"; \
        ./configure \
            --build="$gnuArch" \
            --libdir="$TOMCAT_NATIVE_LIBDIR" \
            --prefix="$CATALINA_HOME" \
            --with-apr="$aprConfig" \
            --with-java-home="$JAVA_HOME" \
            --with-ssl=yes; \
        make -j "$(nproc)"; \
        make install; \
    ); \
    rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	find "$TOMCAT_NATIVE_LIBDIR" -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	#apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	#rm -rf /var/lib/apt/lists/*; \
	\
# sh removes env vars it doesn't support (ones with periods)
# https://github.com/docker-library/tomcat/issues/77
	find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +; \
	\
# fix permissions (especially for running as non-root)
# https://github.com/docker-library/tomcat/issues/35
	chmod -R +rX .; \
	chmod 777 logs temp work

# verify Tomcat Native is working properly
RUN set -e \
	&& nativeLines="$(catalina.sh configtest 2>&1)" \
	&& nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" \
	&& nativeLines="$(echo "$nativeLines" | sort -u)" \
	&& if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
		echo >&2 "$nativeLines"; \
		exit 1; \
	fi

EXPOSE 8080
CMD ["catalina.sh", "run"]    
