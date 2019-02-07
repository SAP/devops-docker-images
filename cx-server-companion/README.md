# cx-server-companion

Dockerfile for an image with the utility scripts that helps with the lifecycle managemment of the [cx-server](https://github.com/SAP/devops-docker-images/blob/master/README.md#setting-up-jenkins-server).
This image is to be used as described in the [operations guide](https://github.com/SAP/devops-docker-images/blob/master/docs/operations/cx-server-operations-guide.md). 

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/cx-server-companion
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile an run

```
docker build -t ppiper/cx-server-companion .
```

## Usage

This image is to be used by the cx-server script as a [sidecar](https://docs.microsoft.com/en-us/azure/architecture/patterns/sidecar) container. In order to use this image to it's complete potential, generate the cx-server script using the below command.

```sh
docker run -it --rm -u $(id -u):$(id -g) -v "${PWD}":/cx-server/mount/ ppiper/cx-server-companion:latest init-cx-server
```

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.