FROM node:11-alpine

ARG npm_registry=https://registry.npmjs.org/

#Install dependencies for running the cx server script in this container
RUN apk add --no-cache bash docker curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /cx-server

COPY files/* ./
COPY life-cycle-scripts/* ./life-cycle-scripts/

RUN npm config set registry=$npm_registry && \
    npm install && \
    npm config delete registry && \
    # If the repository was cloned on Windows, the script might have \CR\LF line endings. Ensure it has only \LF.
    dos2unix cx-server-companion.sh && \
    dos2unix cx-server && \
    dos2unix server-default.cfg && \
    dos2unix init-cx-server && \
    chmod +x cx-server cx-server-companion.sh && \
    unix2dos cx-server.bat && \
    chmod +x init-cx-server
ENV PATH="/cx-server:${PATH}"
