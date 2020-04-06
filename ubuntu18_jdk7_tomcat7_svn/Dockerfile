FROM tacca/ubuntu18_jdk7_tomcat7

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    #apt-get install -y --no-install-recommends curl subversion; \
    apt-get install -y subversion; \
    apt-get autoclean && apt-get clean --dry-run; \
    # mark to hold the subversion package.
	apt-mark hold subversion; \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; 
