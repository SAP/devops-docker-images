FROM openjdk:8-jre-slim

ARG MTA_HOME='/opt/sap/mta'
ARG MTA_VERSION=1.1.7

ENV MTA_JAR_LOCATION="${MTA_HOME}/lib/mta.jar"

ADD scripts/mtaBuild.sh ${MTA_HOME}/bin/mtaBuild.sh

RUN apt-get update && apt-get install -y \
      curl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p `dirname ${MTA_JAR_LOCATION}` && \
    curl --fail \
         --silent \
         --cookie "eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt;" \
         --output ${MTA_JAR_LOCATION} \
      https://tools.hana.ondemand.com/additional/mta_archive_builder-${MTA_VERSION}.jar && \
    curl --fail \
         --silent \
         --output `dirname ${MTA_HOME}`/mta-license.txt \
       https://tools.hana.ondemand.com/developer-license-3_1.txt && \
    ln -s ${MTA_HOME}/bin/mtaBuild.sh /usr/local/bin/mtaBuild && \
    INSTALLED_VERSION=`mtaBuild --version` && \
    echo "[INFO] mta version: \"${INSTALLED_VERSION}\"." && \
    apt-get remove --purge --autoremove -y \
      curl
    # Check below should be active, but we get version 1.1.8 installed
    # when demanding version 1.1.7. When activating the check below, don't forget to add
    # ' && \' to the line above
    # [ "${MTA_VERSION}" = "${INSTALLED_VERSION}" ] || { echo "[ERROR] Installed version '${INSTALLED_VERSION}' does not match expected version '${MTA_VERSION}'."; exit 1; }

