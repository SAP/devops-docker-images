### Description

This is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines 
for SAP development projects. The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/). Docker containers simplify your CD tool setup, encapsulating 
tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md). Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

This repository contains Dockerfiles that are designed to run project "Piper" pipelines. Nevertheless, they can also be used flexibly in any custom environment and automation process.

For detailed usage information please check the README.md in the corresponding folder.

### Dockerfiles

The following files are still being prepared, and are not yet released:

| Name | Description | Link |
|------|-------------|------|
| Jenkins | Preconfigured Jenkins to run project "Piper" pipelines. | [jenkins-master/](jenkins-master/) |
| MTA Archive Builder | Build SAP Multitarget Applications with the [MTA archive builder](https://help.sap.com/viewer/58746c584026430a890170ac4d87d03b/Cloud/en-US/ba7dd5a47b7a4858a652d15f9673c28d.html). | [mta-archive-builder/](mta-archive-builder/) |
| CM Client | Interact with SAP Solution Manager or CTS using the command line. | [cm-client/](cm-client/) |


### General Requirements

A [Docker](https://www.docker.com/) environment is needed to build and run Docker images. You should be familiar with basic Docker commands to build and run these images. In case you need to fetch the Dockerfiles and this project's sources to build them locally, a [Git client](https://git-scm.com/) is required.

Each individual Dockerfile may have additional requirements. Those requirements are documented with each Dockerfile.

## Download and Installation

To download and install Docker please follow the instructions at the [Docker website](https://www.docker.com/get-started) according your operating system.

You can consume these images in three different flavors:

1. Build locally and run

    Clone this repository, change directories to the desired Dockerfile and build it:
    
    ````
    git clone https://github.com/SAP/devops-docker-images
    cd devops-docker-images/<specific-image>
    docker build .
    docker run ...
    ````

    Specific instructions how to run the containers are stored within the same directory.

2. Pull from hub.docker.com

    We build the Dockerfiles for your convenience and store them on https://hub.docker.com/.
    
    ````
    docker pull <image-name>:<version>
    docker run ...
    ````

3. Via project "Piper"

    In case you are using [project "Piper"](https://sap.github.io/jenkins-library/) you can configure certain steps 
    to use docker images instead of the local Jenkins environment. These steps will automatically pull and run these 
    images.
 
### Setting up Jenkins Server
The `cx-server` is a toolkit that is developed to manage the lifecycle of the Jenkins server.
In order to use the toolkit, you need a file named `cx-server` and a configuration file `server.cfg`. 
You can generate these files using the docker command

```sh
docker run -it --rm -u `id -u`:`id -g` -v ${PWD}:/cx-server/mount/ ppiper/cxserver-companion:latest init
``` 

Once the files are generated in the current directory, you can launch the below command to start the Jenkins server.

```sh
./cx-server start
```

If you would like to customize the Jenkins, [the operations guide](docs/operations/cx-server-lifecycle.md) will provide more information on this along with the lifecycle management of the Jenkins. 

### How to obtain support

Feel free to open new issues for feature requests, bugs or general feedback on
the [GitHub issues page of this project][devops-docker-images-issues].

### Contributing

Read and understand our [contribution guidelines][contribution]
before opening a pull request.

### License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file][license].

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[devops-docker-images-issues]: https://github.com/SAP/devops-docker-images/issues
[license]: ./LICENSE
[contribution]: ./CONTRIBUTING.md
