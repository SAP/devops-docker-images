FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY init_s4sdk_library.groovy /usr/share/jenkins/ref/init.groovy.d/init_s4sdk_library.groovy.override
COPY init_executors.groovy /usr/share/jenkins/ref/init.groovy.d/init_executors.groovy.override

# install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(tr '\n' ' ' < /usr/share/jenkins/ref/plugins.txt)

RUN chown -R jenkins /usr/share/jenkins/ref

USER jenkins

#For 2.x-derived images, to indicate that this Jenkins installation is fully configured.
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

VOLUME /var/jenkins_ssl
ENV JENKINS_OPTS --httpPort=8080 --httpsPort=-1
ENV JAVA_OPTS $JAVA_OPTS -Djenkins.install.runSetupWizard=false -Dhudson.model.DirectoryBrowserSupport.CSP=

EXPOSE 8080
