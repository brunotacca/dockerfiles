FROM tacca/ubuntu18_jdk7_tomcat7_svn

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y rsync ant vim; \
    apt-get autoclean && apt-get clean --dry-run; \
    # mark to hold the rsync package.
	apt-mark hold rsync ant vim; \
    # Configure these Locale vars for your need.
    export TERM=xterm-256color; \
    export LANG=pt_BR.utf8; \
    export LC_PAPER=pt_BR.UTF-8; \
    export LC_ADDRESS=pt_BR.UTF-8; \
    export LC_MONETARY=pt_BR.UTF-8; \
    export LC_NUMERIC=pt_BR.UTF-8; \
    export LC_TELEPHONE=pt_BR.UTF-8; \
    export LC_IDENTIFICATION=pt_BR.UTF-8; \
    export LC_MEASUREMENT=pt_BR.UTF-8; \
    export LC_CTYPE=pt_BR.UTF-8; \
    export LC_TIME=pt_BR.UTF-8; \
    export LC_NAME=pt_BR.UTF-8; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; 
