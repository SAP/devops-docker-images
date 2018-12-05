FROM node:slim

USER root

ARG SAPCAR_FILE
ARG NWRFC_FILE

ENV WORKSPACE=/opt/sap/workspace
ENV TARGETDIR=$WORKSPACE/target
ENV PATH=$PATH:$WORKSPACE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    mkdir -p /run/uuidd && \
	apt-get install -y apt-utils uuid-runtime bzip2 && \
	rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ADD $SAPCAR_FILE /usr/local/bin/SAPCAR
ADD $NWRFC_FILE /tmp/$NWRFC_FILE

RUN mkdir -p $TARGETDIR

# unpack rfc library
RUN chmod a+x /usr/local/bin/SAPCAR
WORKDIR /opt/sap
RUN /usr/local/bin/SAPCAR -xvf /tmp/$NWRFC_FILE && \
	rm -f /tmp/$NWRFC_FILE
	
# configure rfc library
RUN mkdir -p /etc/ld.so.conf.d/

COPY nwrfcsdk.conf /etc/ld.so.conf.d/nwrfcsdk.conf

RUN ldconfig -v
    
WORKDIR $WORKSPACE
COPY Gruntfile_ABAP.js $WORKSPACE/Gruntfile_ABAP.js
COPY package.json $WORKSPACE/package.json
COPY cts $WORKSPACE/cts


RUN    chmod a+x cts && \
       npm config set loglevel=error && \
	   npm install grunt --save-dev && \
	   npm install grunt-contrib-jshint --save-dev && \
	   npm install grunt-cli --save-dev && \
       npm install node-rfc@next --save-dev && \
	   npm install && \
	   cat package.json
	   
VOLUME $TARGETDIR

	
	
	
