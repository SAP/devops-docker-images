FROM ppiper/jenkins-master

USER root
RUN curl -O https://repo.jenkins-ci.org/releases/io/jenkins/jenkinsfile-runner/jenkinsfile-runner/1.0-beta-7/jenkinsfile-runner-1.0-beta-7-app.zip && \
    unzip jenkinsfile-runner-1.0-beta-7-app.zip -d jenkinsfile-runner && \
    rm jenkinsfile-runner-1.0-beta-7-app.zip

RUN mkdir /jenkins-war && unzip /usr/share/jenkins/jenkins.war -d /jenkins-war && \
    mkdir -p /var/cx-server/jenkins-configuration

# "Default" Jenkinsfile for test case
COPY Jenkinsfile /workspace/Jenkinsfile

ENTRYPOINT ["/jenkinsfile-runner/bin/jenkinsfile-runner", \
            "--jenkins-war", "/jenkins-war", \
            "--plugins", "/usr/share/jenkins/ref/plugins", \
            "--file", "/workspace", \
            "--no-sandbox"]
