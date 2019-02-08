#!/bin/bash

function log_error()
{
  echo -e "\033[1;31m[Error]\033[0m $1" >&2
}

if [ $# -lt 2 ]; then
  echo "Please provide the following parameters: $0 USER HOST [DOCKER_IMAGE]"
  exit 1
fi

cd ~

SCP_COMMAND="scp -B -o StrictHostKeyChecking=no"
SSH_COMMAND="ssh -x"

SSH_USER=$1
SSH_HOST=$2
REMOTE_DIR=ppiper_jenkins_agent

if [ -n "$3" ]; then
  DOCKER_IMAGE=$3
else
  DOCKER_IMAGE='ppiper/jenkins-agent:latest'
fi

echo "Download slave.jar"
wget http://localhost:8080/jnlpJars/slave.jar

echo "Create directory on agent: $REMOTE_DIR"
$SSH_COMMAND $SSH_USER@$SSH_HOST "mkdir -p $REMOTE_DIR" </dev/null

echo "Copy salve.jar to remote host"
$SCP_COMMAND slave.jar $SSH_USER@$SSH_HOST:$REMOTE_DIR/slave.jar

rm slave.jar

echo "Get Docker Group ID"

DOCKER_GID=$($SSH_COMMAND $SSH_USER@$SSH_HOST "grep ^docker /etc/group|cut -d: -f3" </dev/null)

if [ -z "${DOCKER_GID}" ]; then
        log_error "Failed to determine docker group id."
        exit 1
fi
echo "Using Docker GID: $DOCKER_GID"

echo "Update Docker Image"
$SSH_COMMAND $SSH_USER@$SSH_HOST "docker pull $DOCKER_IMAGE" </dev/null >/dev/null

if [ -n "$http_proxy" ]; then
  PROXY_ENV=" -e http_proxy=$http_proxy"
fi

if [ -n "$https_proxy" ]; then
  PROXY_ENV="$PROXY_ENV -e https_proxy=$https_proxy"
fi

if [ -n "$no_proxy" ]; then
  PROXY_ENV="$PROXY_ENV -e no_proxy=$no_proxy"
fi

$SSH_COMMAND $SSH_USER@$SSH_HOST "mkdir -p $REMOTE_DIR/cx-server" </dev/null
$SCP_COMMAND /var/cx-server/cx-server $SSH_USER@$SSH_HOST:"$REMOTE_DIR"/cx-server/cx-server
$SCP_COMMAND /var/cx-server/server.cfg $SSH_USER@$SSH_HOST:"$REMOTE_DIR"/cx-server/server.cfg

$SSH_COMMAND $SSH_USER@$SSH_HOST "docker pull ppiper/cx-server-companion"</dev/null >/dev/null
$SSH_COMMAND $SSH_USER@$SSH_HOST "docker run --rm --workdir /cx-server/mount --mount source=\$(pwd)/$REMOTE_DIR/cx-server,target=/cx-server/mount,type=bind --volume /var/run/docker.sock:/var/run/docker.sock $PROXY_ENV --env host_os=unix --env cx_server_path=\$(pwd)/$REMOTE_DIR/cx-server ppiper/cx-server-companion /cx-server/cx-server-companion.sh start_cache"</dev/null

echo "Start agent"
$SSH_COMMAND $SSH_USER@$SSH_HOST docker run -i --rm --log-driver none -u 1000:$DOCKER_GID -v \`pwd\`/$REMOTE_DIR:/$REMOTE_DIR -v /var/run/docker.sock:/var/run/docker.sock $PROXY_ENV $DOCKER_IMAGE java -jar /$REMOTE_DIR/slave.jar
