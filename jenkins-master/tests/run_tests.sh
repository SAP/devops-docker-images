#!/bin/sh -xe

cd /var/jenkins_home

curl -O https://repo.jenkins-ci.org/releases/io/jenkins/jenkinsfile-runner/jenkinsfile-runner/1.0-beta-7/jenkinsfile-runner-1.0-beta-7-app.zip && \
unzip -q jenkinsfile-runner-1.0-beta-7-app.zip && \
mkdir app && unzip -q /usr/share/jenkins/jenkins.war -d app/jenkins

bin/jenkinsfile-runner \
        --jenkins-war app/jenkins \
        --plugins /usr/share/jenkins/ref/plugins \
        --file /autotest \
        --no-sandbox
