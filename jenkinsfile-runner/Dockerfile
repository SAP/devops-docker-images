FROM ppiper/jenkins-master

USER root
RUN curl -O https://repo.jenkins-ci.org/releases/io/jenkins/jenkinsfile-runner/jenkinsfile-runner/1.0-beta-7/jenkinsfile-runner-1.0-beta-7-app.zip && \
    unzip jenkinsfile-runner-1.0-beta-7-app.zip && \
    rm jenkinsfile-runner-1.0-beta-7-app.zip

RUN mkdir /app && unzip /usr/share/jenkins/jenkins.war -d /app/jenkins && \
    mkdir -p /var/cx-server/jenkins-configuration

ENTRYPOINT ["bin/jenkinsfile-runner", \
            "--jenkins-war", "/app/jenkins", \
            "--plugins", "/usr/share/jenkins/ref/plugins", \
            "--file", "/workspace"]
