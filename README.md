## Description

This is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines 
for SAP development projects. The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/). Docker containers simplify your CD tool setup, encapsulating 
tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md). Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

**Note:** This repository has been split up.
Please refer to the following repositories for current Dockerfiles and documentation:

* [Cx Server](https://github.com/SAP/devops-docker-cx-server)
    * Jenkins master
    * Jenkins agents
    * Cx Server companion
* [CF cli](https://github.com/SAP/devops-docker-cf-cli)
* [Neo cli](https://github.com/SAP/devops-docker-neo-cli)
* [MTA Builder](https://github.com/SAP/devops-docker-mta-archive-builder)
* [Node browsers](https://github.com/SAP/devops-docker-node-browsers)

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
