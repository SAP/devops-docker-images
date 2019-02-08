# Node Browsers

Dockerfile for an image with node and web browsers.
This image is intended to be used for end to end tests of web applications in Jenkins pipelines.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/node-browsers
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile and run

```
docker build -t ppiper/node-browsers .
```

## Usage

See this [blog post](https://blogs.sap.com/2017/12/11/sap-s4hana-cloud-sdk-end-to-end-tests-against-secured-applications/) for usage of this image in a Jenkins pipeline based on `ppiper/jenkins-master`.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.
