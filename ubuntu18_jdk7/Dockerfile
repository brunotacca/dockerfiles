FROM ubuntu:18.04

LABEL maintainer="Bruno V. Tacca"

RUN apt-get update && apt-get install -y curl && apt-get clean \
    # You can download the tar.gz from an external link (Check if it's available)
    && curl -v -O -L -k https://softwarepublico.gov.br/social/citsmart/versoes-estaveis/jdk-7u80-linux-x64.tar.gz \
    && mkdir -p /usr/local/java \
    && mv jdk-7u80-linux-x64.tar.gz /usr/local/java/ \
    && cd /usr/local/java \
    && tar xvzf jdk-7u80-linux-x64.tar.gz \
    && rm /usr/local/java/jdk-7u80-linux-x64.tar.gz

# Environment variables
ENV JAVA_HOME=/usr/local/java/jdk1.7.0_80
ENV JRE_HOME=/usr/local/java/jdk1.7.0_80
ENV PATH=$PATH:$JRE_HOME/bin:$JAVA_HOME/bin

# Alternatives
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_80/bin/java" 1 \
    && update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.7.0_80/bin/javac" 1 \
    && update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.7.0_80/bin/javaws" 1 \
    && update-alternatives --set java /usr/local/java/jdk1.7.0_80/bin/java \
    && update-alternatives --set javac /usr/local/java/jdk1.7.0_80/bin/javac \
    && update-alternatives --set javaws /usr/local/java/jdk1.7.0_80/bin/javaws