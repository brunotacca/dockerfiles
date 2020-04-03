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

# custom commands
# RUN alias tt='tail -f $CATALINA_HOME/logs/catalina.out'

EXPOSE 8080
CMD ["catalina.sh", "run"]    
#RUN apt-get clean
#RUN apt-get update && apt-get install -y dpkg-dev gcc libapr1-dev libssl-dev make && mkdir -p $CATALINA_HOME

#WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
#ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
#ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "update.sh" (https://github.com/docker-library/tomcat/blob/master/update.sh)
#ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

#ENV TOMCAT_MAJOR 7
#ENV TOMCAT_VERSION 7.0.103
#ENV TOMCAT_SHA512 3a02bf074fd5a00e751b1229cffdf7c7d9ee52ab825ddecb1e5b766d40999f08be5d3758704333a922c593b139bce51feb8b33924731aacf3acebba8beb5cce8
#ENV TOMCAT_MD5 8dd9df51900023107e0c24f4ed105b01

#RUN wget http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

# Download tomcat
#RUN curl -v -O -L -k http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
#RUN wget http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
#RUN curl -v -O -L -k http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-7/v7.0.103/bin/apache-tomcat-7.0.103.tar.gz
#SHELL ["/bin/bash", "-c", "mv apache-tomcat-$TOMCAT_VERSION.tar.gz tomcat.tar.gz"]
#SHELL ["/bin/bash", "-c", "curl -v -O -L -k http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && mv apache-tomcat-$TOMCAT_VERSION.tar.gz tomcat.tar.gz && tar -xf tomcat.tar.gz --strip-components=1"] 
#RUN ["/bin/bash", "-c", "curl -v -O -L -k http://mirror.nbtelecom.com.br/apache/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"] 
#RUN ["/bin/bash", "-c", "mv apache-tomcat-$TOMCAT_VERSION.tar.gz tomcat.tar.gz; tar -xf tomcat.tar.gz --strip-components=1; rm bin/*.bat; rm tomcat.tar.gz*; mv webapps webapps.dist; mkdir webapps; nativeBuildDir=$(mktemp -d); tar -xf bin/tomcat-native.tar.gz -C $nativeBuildDir --strip-components=1; "] 
#RUN apt-get install -y --no-install-recommends dpkg-dev gcc libapr1-dev libssl-dev make

#RUN echo "$TOMCAT_SHA512  tomcat.tar.gz" | sha512sum --strict --check \
    #&& echo "$TOMCAT_MD5  tomcat.tar.gz" | md5sum --strict --check \
    #&& mv apache-tomcat-$TOMCAT_VERSION.tar.gz tomcat.tar.gz \
    #&& tar -xf tomcat.tar.gz --strip-components=1 \
    #&& rm bin/*.bat \
	#&& rm tomcat.tar.gz*
#SHELL ["/bin/bash", "-c", "tar -xf tomcat.tar.gz --strip-components=1"]

#RUN apt-get upgrade -y
#RUN wget http://apache.mirror.rafal.ca/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz
#RUN echo "3c46fc0f608c1280dcd65100a983f285  /apache-tomcat-7.0.55.tar.gz" | md5sum -c
#RUN cd /opt && tar xvf ~/apache-tomcat-7.0.55.tar.gz
#RUN mv /opt/apache-tomcat-7.0.55 /opt/tomcat
#RUN rm ~/apache-tomcat-7.0.55.tar.gz


#CMD [ "cd ${CATALINA_HOME","run" ]
#SHELL ["/bin/bash", "-c", "cd $CATALINA_HOME && ls -l"]

# Alternatives
#RUN update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_80/bin/java" 1 \
    #&& update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.7.0_80/bin/javac" 1 \
    #&& update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.7.0_80/bin/javaws" 1 \
    #&& update-alternatives --set java /usr/local/java/jdk1.7.0_80/bin/java \
    #&& update-alternatives --set javac /usr/local/java/jdk1.7.0_80/bin/javac \
    #&& update-alternatives --set javaws /usr/local/java/jdk1.7.0_80/bin/javaws

# Reload profile
#SHELL ["/bin/bash", "-c", "source /etc/profile"]

#EXPOSE 8080
