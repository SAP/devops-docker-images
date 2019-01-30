FROM node:slim

USER root

ARG NWRFC_FILE

ENV DEBIAN_FRONTEND=noninteractive

ENV SAPDIR=/opt/sap
ENV SAPBIN=${SAPDIR}/bin
ENV SAPDATADIR=/var/sap/data
ENV PATH=${SAPBIN}:$PATH

ADD $NWRFC_FILE /tmp/$NWRFC_FILE

COPY nwrfcsdk.conf /etc/ld.so.conf.d/nwrfcsdk.conf
COPY run_rfc_task.js ${SAPBIN}/run_rfc_task.js
COPY package.json ${SAPBIN}/package.json
COPY cts ${SAPBIN}/cts

WORKDIR ${SAPBIN}

RUN apt-get update && \
    apt-get install -y apt-utils bzip2 unzip && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    mkdir -p ${SAPDATADIR} && \
    chown 1000:1000 ${SAPDATADIR} &&\
    chmod a+x ${SAPBIN}/cts && \
    cd ${SAPDIR} && \
    unzip /tmp/$NWRFC_FILE && \
    rm -f /tmp/$NWRFC_FILE && \
    ldconfig -v && \
    cd ${SAPBIN} && \
    npm install grunt grunt-contrib-jshint grunt-cli node-rfc@next --save

VOLUME $SAPDATADIR

	
	
	
