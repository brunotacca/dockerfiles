FROM ubuntu:18.04

LABEL maintainer="Bruno V. Tacca"

# You can download the tar.gz from an external link
RUN apt-get update && apt-get install -y curl && apt-get clean
RUN curl -v -O -L -k https://softwarepublico.gov.br/social/citsmart/versoes-estaveis/jdk-7u80-linux-x64.tar.gz

# Or you can copy it from your local machine
#COPY ./jdk-7u80-linux-x64.tar.gz /

# Making dirs and Extracting tar.gz
RUN mkdir -p /usr/local/java \
    && mv jdk-7u80-linux-x64.tar.gz /usr/local/java/ \
    && cd /usr/local/java \
    && tar xvzf jdk-7u80-linux-x64.tar.gz

# Environment variables
RUN echo "" >> /etc/profile \
    && echo "JAVA_HOME=/usr/local/java/jdk1.7.0_80" >> /etc/profile \
    && echo "JRE_HOME=/usr/local/java/jdk1.7.0_8" >> /etc/profile \
    && echo "PATH=$PATH:$JRE_HOME/bin:$JAVA_HOME/bin" >> /etc/profile \
    && echo "" >> /etc/profile \
    && echo "export JAVA_HOME" >> /etc/profile \
    && echo "export JRE_HOME" >> /etc/profile \
    && echo "export PATH" >> /etc/profile

# Alternatives
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_80/bin/java" 1 \
    && update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.7.0_80/bin/javac" 1 \
    && update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.7.0_80/bin/javaws" 1 \
    && update-alternatives --set java /usr/local/java/jdk1.7.0_80/bin/java \
    && update-alternatives --set javac /usr/local/java/jdk1.7.0_80/bin/javac \
    && update-alternatives --set javaws /usr/local/java/jdk1.7.0_80/bin/javaws

# Reload profile
SHELL ["/bin/bash", "-c", "source /etc/profile"]
