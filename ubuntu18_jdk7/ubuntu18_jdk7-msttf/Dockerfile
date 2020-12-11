FROM tacca/ubuntu18_jdk7

LABEL maintainer="Bruno Tacca <github.com/brunotacca>"

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends debconf-utils; \
# MSTTFONTS
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | debconf-set-selections; \
    apt-get install -y --no-install-recommends ttf-mscorefonts-installer; \
    apt-get autoclean && apt-get clean --dry-run; \
# mark to hold the later usage packages.
    apt-mark hold ttf-mscorefonts-installer; \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; 