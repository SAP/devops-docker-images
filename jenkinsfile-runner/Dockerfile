FROM maven:3.5.2 as maven

RUN git clone https://github.com/jenkinsci/jenkinsfile-runner && \
    cd jenkinsfile-runner && \
    mvn package --quiet

FROM ppiper/jenkins-master

USER root
RUN mkdir /app && unzip /usr/share/jenkins/jenkins.war -d /app/jenkins \
    mkdir -p /var/cx-server/jenkins-configuration
COPY --from=maven /jenkinsfile-runner/app/target/appassembler /app

ENTRYPOINT ["/app/bin/jenkinsfile-runner", \
            "--jenkins-war", "/app/jenkins", \
            "--plugins", "/usr/share/jenkins/ref/plugins", \
            "--file", "/workspace"]
