[![REUSE status](https://api.reuse.software/badge/github.com/SAP/devops-docker-images)](https://api.reuse.software/info/github.com/SAP/devops-docker-images)

## Description

This is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines
for SAP development projects. The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/). Docker containers simplify your CD tool setup, encapsulating
tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md). Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](cicd-best-practices).

**Note:** This repository has been split up.
Please refer to the following repositories for current Dockerfiles and documentation:

* [Cx Server](https://github.com/SAP/devops-docker-cx-server)
    * Jenkins master
    * Jenkins agents
    * Cx Server companion
* [CF cli](https://github.com/SAP/devops-docker-cf-cli)
* [Neo cli](https://github.com/SAP/devops-docker-neo-cli)
* [Cloud MTA Builder](https://sap.github.io/cloud-mta-build-tool)
* [Node browsers](https://github.com/SAP/devops-docker-node-browsers)

### Docker Images

The following images are published on [hub.docker.com](https://hub.docker.com/search?q=ppiper&type=image):

| Name | Description | Docker Image |
|------|-------------|------|
| Jenkins | Use a preconfigured Jenkins to run project "Piper" pipelines. | [ppiper/jenkins-master](https://hub.docker.com/r/ppiper/jenkins-master) |
| Cloud MTA Build Tool | Build multitarget applications with the [Cloud MTA Build Tool](https://sap.github.io/cloud-mta-build-tool/). | [devxci/mbtci](https://hub.docker.com/r/devxci/mbtci) |
| CM Client | Interact with SAP Solution Manager or CTS using the command line. | [ppiper/cm-client](https://hub.docker.com/r/ppiper/cm-client) |
| CloudFoundry CLI | Use command line tools for Cloud Foundry with plugins for blue-green deployment and MTA. | [ppiper/cf-cli](https://hub.docker.com/r/ppiper/cf-cli) |
| Neo CLI | Use SAP Cloud Platform tools for Neo. | [neo-cli/](https://hub.docker.com/r/ppiper/neo-cli/) |
| Jenkinsfile Runner| Run a `Jenkinsfile` without a long-running, stateful Jenkins master. The [Jenkinsfile Runner](https://github.com/jenkinsci/jenkinsfile-runner) is based on `ppiper/jenkins-master`. | [ppiper/jenkinsfile-runner](https://hub.docker.com/r/ppiper/jenkinsfile-runner) |
| Life Cycle Container| Improve life-cycle management of the cx-server by using a sidecar image.|[ppiper/cx-server-companion](https://hub.docker.com/r/ppiper/cx-server-companion) |
| Container Structure Test| Run [container structure tests](https://github.com/GoogleContainerTools/container-structure-test) with a shell for `ppiper/jenkins-master`.|[ppiper/container-structure-test](https://hub.docker.com/r/ppiper/container-structure-test)|
| Node Browsers | Use web browsers for end-to-end tests of web applications in Jenkins pipelines. | [node-browsers/](https://hub.docker.com/r/ppiper/node-browsers/) |
| SAP HANA XS Advanced CLI | Use command line tools to deploy to SAP HANA XS Advanced. | [Dockerfile](https://github.com/SAP/devops-docker-xsa-cli/) |

## How to obtain support

Feel free to open new issues for feature requests, bugs or general feedback on
the [GitHub issues page of this project][devops-docker-images-issues].

## Contributing

Read and understand our [contribution guidelines][contribution]
before opening a pull request.

[devops-docker-images-issues]: https://github.com/SAP/devops-docker-images/issues
[contribution]: https://github.com/SAP/devops-docker-images/blob/master/CONTRIBUTING.md
[cicd-best-practices]: https://help.sap.com/docs/CICD_OVERVIEW/3324745951b44b578bd65221d2ff8f9a/1ae37c7c7ad343589e2bd2fd424c9105.html?language=en-US