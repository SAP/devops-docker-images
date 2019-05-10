## Description

This is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines 
for SAP development projects. The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/). Docker containers simplify your CD tool setup, encapsulating 
tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md). Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

This repository contains Dockerfiles that are designed to run project "Piper" pipelines. Nevertheless, they can also be used flexibly in any custom environment and automation process.

For detailed usage information please check the README.md in the corresponding folder.

### Docker Images

The following images are published on [hub.docker.com](https://hub.docker.com/search?q=ppiper&type=image):

| Name | Description | Docker Image |
|------|-------------|------|
| Jenkins | Preconfigured Jenkins to run project "Piper" pipelines. | [ppiper/jenkins-master](https://hub.docker.com/r/ppiper/jenkins-master) |
| MTA Archive Builder | Build SAP Multitarget Applications with the [MTA archive builder](https://help.sap.com/viewer/58746c584026430a890170ac4d87d03b/Cloud/en-US/ba7dd5a47b7a4858a652d15f9673c28d.html). | [ppiper/mta-archive-builder](https://hub.docker.com/r/ppiper/mta-archive-builder) |
| CM Client | Interact with SAP Solution Manager or CTS using the command line. | [ppiper/cm-client](https://hub.docker.com/r/ppiper/cm-client) |
| CloudFoundry CLI | command line tools for CloudFoundry, with plugins for blue-green deploy and MTA. | [ppiper/cf-cli](https://hub.docker.com/r/ppiper/cf-cli) |
| Neo CLI | SAP Cloud Platform Tools for Neo. | [neo-cli/](neo-cli/) |
| Jenkinsfile Runner| [Jenkinsfile Runner](https://github.com/jenkinsci/jenkinsfile-runner) based on `ppiper/jenkins-master`, allows running a `Jenkinsfile` without a long-running, stateful Jenkins master. | [ppiper/jenkinsfile-runner](https://hub.docker.com/r/ppiper/jenkinsfile-runner) |
| Life Cycle Container| Sidecar image for life-cycle management of the cx-server|[ppiper/cx-server-companion](https://hub.docker.com/r/ppiper/cx-server-companion)|
| Container Structure Test|[Container Structure Test](https://github.com/GoogleContainerTools/container-structure-test) with shell to work with `ppiper/jenkins-master`|[ppiper/container-structure-test](https://hub.docker.com/r/ppiper/container-structure-test)|
| Node Browsers | Web browsers to be used for end to end tests of web applications in Jenkins pipelines | [node-browsers/](node-browsers/) |

#### Versioning

All images have a Docker tag `latest`.
Individual images may provide additional tags corresponding to releases.

Existing releases are listed on the [GitHub releases page](https://github.com/SAP/devops-docker-images/releases).
Official releases follow the pattern `v{VersionNumber}`.
Additional namespaced tags for certain images do exist and are not a release of the project.

Developer documentation for releases is available in the [release documentation document](docs/development/how-to-release.md).

Information on updating the Jenkins master including the bundled plugins is available in [the respective section of the operations guide](https://github.com/SAP/devops-docker-images/blob/master/docs/operations/cx-server-operations-guide.md#update-image).

### Docker Files

The following Dockerfiles will not be published as images. You have to build them on your own.

| Name | Description | Link |
|------|-------------|------|
| Node-rfc | Interact with CTS+ having NW ABAP < 7.50 | [/node-rfc](https://github.com/SAP/devops-docker-images/tree/master/node-rfc)|

## General Requirements

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
docker run -it --rm -u $(id -u):$(id -g) -v "${PWD}":/cx-server/mount/ ppiper/cx-server-companion:latest init-cx-server
``` 

Once the files are generated in the current directory, you can launch the below command to start the Jenkins server.

```sh
./cx-server start
```

If you would like to customize the Jenkins, [the operations guide](https://github.com/SAP/devops-docker-images/blob/master/docs/operations/cx-server-operations-guide.md) will provide more information on this along with the lifecycle management of the Jenkins. 

## How to obtain support

Feel free to open new issues for feature requests, bugs or general feedback on
the [GitHub issues page of this project][devops-docker-images-issues].

## Contributing

Read and understand our [contribution guidelines][contribution]
before opening a pull request.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file][license].

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[devops-docker-images-issues]: https://github.com/SAP/devops-docker-images/issues
[license]: https://github.com/SAP/devops-docker-images/blob/master/LICENSE
[contribution]: https://github.com/SAP/devops-docker-images/blob/master/CONTRIBUTING.md
