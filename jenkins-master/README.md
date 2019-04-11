# Jenkins master

Jenkins master image for use with project ["Piper"](https://github.com/SAP/jenkins-library).

This image is intended to be used with the Cx Server life-cycle management.
Please refer to the [Operations Guide for Cx Server](https://github.com/SAP/devops-docker-images/blob/master/docs/operations/cx-server-operations-guide.md) for detailed usage.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/jenkins-master
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile and run

```
docker build -t ppiper/jenkins-master .
```

## Test

This image has a very simple test case to check if Jenkins is able to boot with the given plugin configuration.
The tests are run by DockerHub's "Autotest" feature.

To run them locally, you need [Docker Compose](https://docs.docker.com/compose/).

Run the following commands

```shell
docker build -t ppiper/jenkins-master:latest .
docker tag ppiper/jenkins-master:latest jenkins-master_sut:latest
docker-compose --file docker-compose.test.yml run sut
```

If the test passes, the exit code of the command should be `0` and you should see some log output ending in 

```
[Pipeline] End of Pipeline
Finished: SUCCESS
```

If the command exits with code `1`, the test failed.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.
