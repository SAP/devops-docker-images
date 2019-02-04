# CloudFoundry CLI

Dockerfile for an image with the CloudFoundry CLI and plugins for blue-green deployment and MTA.
This image is intended to be used in Jenkins pipelines.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/cf-cli
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile an run

```
docker build -t ppiper/cf-cli .
```

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.
