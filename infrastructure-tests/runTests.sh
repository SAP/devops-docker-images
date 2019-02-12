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

# Start a local registry, to which we push the images built in this test, and from which they will be consumed in the test
docker run -d -p 5000:5000 --restart always --name registry registry:2 || true
find ../cx-server-companion -type f -exec sed -i "" -e 's/ppiper/localhost:5000\/ppiper/g' {} \;

# Configure our testing Jenkins instance via Configuration as Code (Create build job, register shared libraries, configure executors)
mkdir -p ../cx-server-companion/life-cycle-scripts/jenkins-configuration
cp testing-jenkins.yml ../cx-server-companion/life-cycle-scripts/jenkins-configuration

docker build -t localhost:5000/ppiper/jenkins-master:latest ../jenkins-master
docker build -t localhost:5000/ppiper/cx-server-companion:latest ../cx-server-companion
docker build -t localhost:5000/ppiper/cf-cli ../cf-cli

docker tag localhost:5000/ppiper/jenkins-master:latest ppiper/jenkins-master:latest
docker tag localhost:5000/ppiper/cx-server-companion:latest ppiper/cx-server-companion:latest
docker tag localhost:5000/ppiper/cf-cli ppiper/cf-cli:latest

docker push localhost:5000/ppiper/jenkins-master:latest
docker push localhost:5000/ppiper/cx-server-companion:latest
docker push localhost:5000/ppiper/cf-cli:latest

# Boot our unit-under-test Jenkins master instance using the `cx-server` script
cd ../cx-server-companion/life-cycle-scripts
export PPIPER_INFRA_IT_CF_PASSWORD
export PPIPER_INFRA_IT_CF_USERNAME
echo "PPIPER_INFRA_IT_CF_PASSWORD\nPPIPER_INFRA_IT_CF_USERNAME" > custom-environment.list
chmod +x cx-server
./cx-server start

cd ../../infrastructure-tests

# Use Jenkinsfile runner to orchastrate the example project build.
# See `Jenkinsfile` in this directory for details on what is happening.
docker run -v //var/run/docker.sock:/var/run/docker.sock -v $(pwd):/workspace \
 -e CASC_JENKINS_CONFIG=/workspace/jenkins.yml -e HOST=$(hostname) -e PPIPER_INFRA_IT_TEST_PROJECT \
 ppiper/jenkinsfile-runner
