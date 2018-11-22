# Description

A collection of Dockerfiles for images that can be used to implement Continuous Delivery pipelines 
for SAP development projects with project ["Piper"](https://github.com/SAP/jenkins-library) on Jenkins or any other CD tool. Docker containers simplify the Jenkins setup, because they encapsulate tools and environments that are required to execute pipeline steps.

# Requirements

A container environment e.g. Docker is needed to build and run Docker images.

# Download and Installation

To download and install docker please follow the instructions at the [Docker website](https://www.docker.com/get-started) according your operating system.

To build these Dockerfiles:
````
git clone https://github.com/SAP/devops-docker-images
cd devops-docker-images/<specific-image>
docker build .
````
Specific instructions how to run the containers are stored within the same directory.

# How to obtain support

Feel free to open new issues for feature requests, bugs or general feedback on
the [GitHub issues page of this project][devops-images-issues].

# Contributing

Read and understand our [contribution guidelines][contribution]
before opening a pull request.

# [License][license]

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file][license].

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[devops-images-issues]: https://github.com/SAP/devops-docker-images/issues
[license]: ./LICENSE
[contribution]: ./CONTRIBUTING.md
