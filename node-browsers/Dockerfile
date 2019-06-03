FROM node:stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends chromium firefox-esr xvfb libxi6 libgconf-2-4 default-jre && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN ln -s /usr/bin/chromium /usr/bin/google-chrome

RUN npm config set @sap:registry https://npm.sap.com --global

USER node
