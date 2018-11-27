# Description

This is a collection of Dockerfiles for images that can be used to implement Continuous Delivery pipelines 
for SAP development projects with project ["Piper"](https://github.com/SAP/jenkins-library) on Jenkins. Docker 
containers simplify your CD tool setup setup, because they encapsulate tools and environments that are 
required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://sap.github.io/jenkins-library/). Introductory material and a lot of 

This repository will contain two type of Dockerfiles. The folder `jenkins` contains a Dockerfile for a Jenkins server, which is preconfigured to run project "Piper" pipelines. The other folders contain Dockerfiles for Docker images which are used in the pipeline to run steps, such as MTA builds or deployments to the SAP Cloud Platform. These images can also be used flexibly in your custom stack without project "Piper" or Jenkins.

For detailed usage information please check the readme in the corresponding folder.

Repository Content in preparation:
* [Jenkins](jenkins/): preconfigured Jenkins to run project "Piper" pipelines.
* [MTA archive builder](mta-archive-builder/): build SAP Multitarget Applications with the [MTA archive builder](https://help.sap.com/viewer/58746c584026430a890170ac4d87d03b/Cloud/en-US/ba7dd5a47b7a4858a652d15f9673c28d.html) (ready to build nodejs and Java applications)
* [CM Client](cm-client/): interact with SAP Solution Manager or CTS

# Requirements

A [Docker](https://www.docker.com/) environment is needed to build and run Docker images. You should be familiar with basic docker commands to build and run these images.

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
