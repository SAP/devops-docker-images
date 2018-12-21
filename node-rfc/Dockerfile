FROM node:slim

USER root

ARG SAPCAR_FILE
ARG NWRFC_FILE

ENV DEBIAN_FRONTEND=noninteractive

ENV SAPDIR=/opt/sap
ENV SAPBIN=${SAPDIR}/bin
ENV SAPDATADIR=/var/sap/data
ENV PATH=${SAPBIN}:$PATH


ADD $SAPCAR_FILE /usr/local/bin/SAPCAR
ADD $NWRFC_FILE /tmp/$NWRFC_FILE

COPY nwrfcsdk.conf /etc/ld.so.conf.d/nwrfcsdk.conf
COPY run_rfc_task.js ${SAPBIN}/run_rfc_task.js
COPY package.json ${SAPBIN}/package.json
COPY cts ${SAPBIN}/cts

WORKDIR ${SAPBIN}

RUN apt-get update && \
    mkdir -p /run/uuidd && \
    apt-get install -y apt-utils uuid-runtime bzip2 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    mkdir -p ${SAPDATADIR} && \
    chmod a+x /usr/local/bin/SAPCAR && \
    chmod a+x ${SAPBIN}/cts && \
    cd ${SAPDIR} && \
    /usr/local/bin/SAPCAR -xvf /tmp/$NWRFC_FILE && \
    rm -f /tmp/$NWRFC_FILE && \
    ldconfig -v && \
    cd ${SAPBIN} && \
    npm install --verbose --global grunt grunt-contrib-jshint grunt-cli --save

VOLUME $SAPDATADIR

	
	
	
