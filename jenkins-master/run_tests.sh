#!/bin/sh -xe

# Install Jenkinsfile runner
git clone -b 1.0-beta-7 https://github.com/jenkinsci/jenkinsfile-runner && \
    cd jenkinsfile-runner && \
    mvn package --batch-mode -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn

mkdir /app && unzip /usr/share/jenkins/jenkins.war -d /app/jenkins

mv -r /jenkinsfile-runner/app/target/appassembler/* /app/

cat << EOF > /app/Jenkinsfile
node("master") {
    stage('Hello World') {
        sh 'echo Hello from Jenkins'
    }
}
EOF

/app/bin/jenkinsfile-runner \
        --jenkins-war /app/jenkins \
        --plugins /usr/share/jenkins/ref/plugins \
        --file /app