FROM openjdk:8-jre-slim

ARG MTA_USER_HOME=/home/mta
ARG MTA_HOME='/opt/sap/mta'
ARG MTA_VERSION=1.1.7

ARG NODE_VERSION=v10.13.0

ENV MTA_JAR_LOCATION="${MTA_HOME}/lib/mta.jar"

ADD scripts/mtaBuild.sh ${MTA_HOME}/bin/mtaBuild.sh

RUN apt-get update && apt-get install -y \
      curl && \
    rm -rf /var/lib/apt/lists/* && \
    #
    # Install mta
    #
    mkdir -p `dirname ${MTA_JAR_LOCATION}` && \
    curl --fail \
         --silent \
         --cookie "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt;" \
         --output ${MTA_JAR_LOCATION} \
      https://tools.hana.ondemand.com/additional/mta_archive_builder-${MTA_VERSION}.jar && \
    curl --fail \
         --silent \
         --output ${MTA_HOME}/LICENSE.txt \
       https://tools.hana.ondemand.com/developer-license-3_1.txt && \
    ln -s ${MTA_HOME}/bin/mtaBuild.sh /usr/local/bin/mtaBuild && \
    INSTALLED_MTA_VERSION=`mtaBuild --version` && \
    echo "[INFO] mta version: \"${INSTALLED_MTA_VERSION}\"." && \
    #
    # Install node
    #
    NODE_HOME=/opt/nodejs; mkdir -p ${NODE_HOME} && \
    curl --fail --silent --output - http://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz \
     |tar -xzv -f - -C ${NODE_HOME} && \
    ln -s ${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node && \
    ln -s ${NODE_HOME}/node-${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm && \
    INSTALLED_NODE_VERSION=`node --version` && \
    echo "[INFO] node version: \"${INSTALLED_NODE_VERSION}\"." && \
    apt-get remove --purge --autoremove -y \
      curl && \
    useradd --home-dir ${MTA_USER_HOME} \
            --create-home \
            --shell /bin/bash \
            --user-group \
            --uid 1000 \
            --comment 'SAP-MTA tooling' \
            --password `echo weUseMta |openssl passwd -1 -stdin` mta && \
    # Check below should be active, but we get version 1.1.8 installed
    # when demanding version 1.1.7. When activating the check below, don't forget to add
    # ' && \' to the line above
    # [ "${MTA_VERSION}" = "${INSTALLED_MTA_VERSION}" ] || { echo "[ERROR] Installed mta version '${INSTALLED_MTA_VERSION}' does not match expected mta version '${MTA_VERSION}'."; exit 1; }
   [ "${NODE_VERSION}" = "${INSTALLED_NODE_VERSION}" ] || { echo "[ERROR] Installed node version '${INSTALLED_NODE_VERSION}' does not match expected node version '${NODE_VERSION}'."; exit 1; }
WORKDIR /home/mta

USER mta
