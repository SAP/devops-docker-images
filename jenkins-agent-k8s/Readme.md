# Jenkins agent k8s

This is a docker version of Jenkins JNLP agent  which is an extension to [jenkinsci/jnlp-slave](https://hub.docker.com/r/jenkins/jnlp-slave/).

The `ppiper/jenkins-master` runs with a user id `1000`.
Hence, a user `piper` with uid `1000` has been added to the JNLP agent as well avoid the possible issue with the access rights of the files that needs to be accessed by both master and the agent. 

This image is intended to be used in Jenkins pipelines.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/jenkins-agent-k8s
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile an run

```
docker build -t ppiper/jenkins-agent-k8s .
```

## Usage

Recommended usage of this image is via [`dockerExecuteOnKubernetes`](https://sap.github.io/jenkins-library/steps/dockerExecuteOnKubernetes/) pipeline step.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.
