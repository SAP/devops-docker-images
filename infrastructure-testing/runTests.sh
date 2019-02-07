#!/bin/sh -e

# Sanity check
if [ -z "$PPIPER_INFRA_IT_CF_USERNAME" ]; then
    echo "Failure: Variable PPIPER_INFRA_IT_CF_USERNAME is unset"
    exit 1
fi

if [ -z "$PPIPER_INFRA_IT_CF_PASSWORD" ]; then
    echo "Failure: Variable PPIPER_INFRA_IT_CF_PASSWORD is unset"
    exit 1
fi

set -x

docker run -d -p 5000:5000 --restart always --name registry registry:2 || true

# Prepare environment
find ../cx-server-companion -type f -exec sed -i "" -e 's/ppiper/localhost:5000\/ppiper/g' {} \;
mkdir -p ../jenkins-master/cx-server/jenkins-configuration
cp testing-jenkins.yml ../cx-server-companion/life-cycle-scripts/jenkins-configuration

docker build -t localhost:5000/ppiper/container-structure-test:latest ../container-structure-test
docker build -t localhost:5000/ppiper/jenkins-master:latest ../jenkins-master
#fixme point to cx-server version of the source PR?
docker build --build-arg cx_server_base_uri=https://raw.githubusercontent.com/fwilhe/devops-docker-images/master/jenkins-master/cx-server/cx-server -t localhost:5000/ppiper/cxserver-companion:latest ../cx-server-companion
docker build -t localhost:5000/ppiper/cf-cli ../cf-cli

docker tag localhost:5000/ppiper/jenkins-master:latest ppiper/jenkins-master:latest
docker tag localhost:5000/ppiper/cxserver-companion:latest ppiper/cxserver-companion:latest
docker tag localhost:5000/ppiper/cf-cli ppiper/cf-cli:latest

docker push localhost:5000/ppiper/jenkins-master:latest
docker push localhost:5000/ppiper/cxserver-companion:latest
docker push localhost:5000/ppiper/cf-cli:latest

cd ../jenkins-master/cx-server
export PPIPER_INFRA_IT_CF_PASSWORD
./cx-server start

cd ../../infrastructure-testing

docker run -v //var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workspace \
 -e CASC_JENKINS_CONFIG=/workspace/jenkins.yml -e HOST=$(hostname) -e PPIPER_INFRA_IT_TEST_PROJECT \
 ppiper/jenkinsfile-runner
