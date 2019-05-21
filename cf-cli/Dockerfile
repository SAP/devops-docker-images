FROM buildpack-deps:stretch-curl

ENV VERSION 0.1

ARG MTA_PLUGIN_URL=https://github.com/cloudfoundry-incubator/multiapps-cli-plugin/releases/download/v2.1.0/mta_plugin_linux_amd64

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ps needs to be available to be able to be used in docker.inside, see https://issues.jenkins-ci.org/browse/JENKINS-40101
RUN apt-get update && \
    apt-get install -y --no-install-recommends procps && \
    rm -rf /var/lib/apt/lists/*

# add group & user
RUN addgroup -gid 1000 piper && \
    useradd piper --uid 1000 --gid 1000 --shell /bin/bash --create-home && \
    curl --location --silent "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

USER piper
WORKDIR /home/piper

# hadolint ignore=DL4001
RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org \
    && cf install-plugin blue-green-deploy -f -r CF-Community \
    && wget --quiet "${MTA_PLUGIN_URL}" \
       --directory-prefix /home/piper/downloads \
    && chmod +x /home/piper/downloads/mta_plugin_linux_amd64 \
    && cf install-plugin /home/piper/downloads/mta_plugin_linux_amd64 -f \
    && rm -rf /home/piper/downloads \
    && cf plugins
