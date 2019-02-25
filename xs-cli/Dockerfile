FROM buildpack-deps:stretch-curl

ARG XSZIP
ENV VERSION 0.1
ENV XSCLI=/opt/sap/xs-cli
ENV PATH=$PATH:${XSCLI}/bin

ADD ${XSZIP} /tmp/${XSZIP}

# ps needs to be available to be able to be used in docker.inside, see https://issues.jenkins-ci.org/browse/JENKINS-40101
RUN apt-get update && \
    apt-get install -y --no-install-recommends procps unzip && \
    rm -rf /var/lib/apt/lists/*

# add group & user
RUN addgroup -gid 1000 piper && \
    useradd piper --uid 1000 --gid 1000 --shell /bin/bash --create-home && \
    mkdir -p ${XSCLI} && \
    cd ${XSCLI} && \
    unzip /tmp/${XSZIP} && \
    rm -rf /tmp/${XSZIP} && \
    chown -R piper:piper ${XSCLI}
    
USER piper
WORKDIR /home/piper

