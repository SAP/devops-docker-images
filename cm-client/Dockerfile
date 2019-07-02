FROM openjdk:8-jre-slim

ARG version=2.0.1

ENV CMCLIENT_HOME /opt/sap/cmclient

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=SC2015
RUN PROTOCOL='http' && \
    REPO_URL='repo1.maven.org/maven2' && \
    G='com.sap.devops.cmclient' && \
    A='dist.cli' && \
    V=${version} && \
    P='tar.gz' && \
    apt-get update && apt-get install -y --no-install-recommends \
      curl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p "${CMCLIENT_HOME}" && \
    curl --silent --show-error  "${PROTOCOL}://${REPO_URL}/${G//"."/"/"}/${A}/${V}/${A}-${V}.${P}" \
    |tar -C "${CMCLIENT_HOME}" -xvzf - && \
    curl --silent --show-error --output ${CMCLIENT_HOME}/LICENSE https://raw.githubusercontent.com/SAP/devops-cm-client/master/LICENSE && \
    chown -R root:root "${CMCLIENT_HOME}" && \
    ln -s "${CMCLIENT_HOME}/bin/cmclient" "/usr/local/bin/cmclient" && \
    apt-get remove --purge --autoremove -y \
      curl && \
    INSTALLED_VERSION=$(cmclient --version |sed -e 's/ :.*//g') && \
    echo "[INFO] cm client version: ${INSTALLED_VERSION}" && \
    [ "${version}" = "${INSTALLED_VERSION}" ] || { echo "[ERROR] Installed version of cm client ('${INSTALLED_VERSION}') does not match expected version ('${version}')." && exit 1; }
