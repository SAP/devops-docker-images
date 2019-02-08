FROM maven:3.5-jdk-8-alpine

RUN  mvn com.sap.cloud:neo-javaee6-wp-maven-plugin:2.153.8.1:install-sdk -DsdkInstallPath=sdk -Dincludes=tools/**,license/**,sdk.version && \
     chmod -R 777 sdk && \
     ln -s /sdk/tools/neo.sh /usr/bin/neo.sh && \
     rm -rf /var/lib/apt/lists/*
