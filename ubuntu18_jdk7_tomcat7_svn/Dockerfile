FROM tacca/ubuntu18_jdk7_tomcat7

LABEL maintainer="Bruno V. Tacca"




RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl subversion; \
    apt-get autoclean && apt-get clean --dry-run;