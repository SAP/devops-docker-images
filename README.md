[![REUSE status](https://api.reuse.software/badge/github.com/SAP/devops-docker-images)](https://api.reuse.software/info/github.com/SAP/devops-docker-images)

## Description

This is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines
for SAP development projects. The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/). Docker containers simplify your CD tool setup, encapsulating
tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md). Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

**Note:** This repository has been split up.
Please refer to the following repositories for current Dockerfiles and documentation:

* [CF cli](https://github.com/SAP/devops-docker-cf-cli)
* [Neo cli](https://github.com/SAP/devops-docker-neo-cli)
* [Cloud MTA Builder](https://sap.github.io/cloud-mta-build-tool)
* [Node browsers](https://github.com/SAP/devops-docker-node-browsers)

### Docker Images

The following images are published on [hub.docker.com](https://hub.docker.com/search?q=ppiper&type=image):

| Name | Description | Docker Image |
|------|-------------|------|
| Cloud MTA Build Tool | Build multitarget applications with the [Cloud MTA Build Tool](https://sap.github.io/cloud-mta-build-tool/). | [devxci/mbtci](https://hub.docker.com/r/devxci/mbtci) |
| CM Client | Interact with SAP Solution Manager or CTS using the command line. | [ppiper/cm-client](https://hub.docker.com/r/ppiper/cm-client) |
| CloudFoundry CLI | Use command line tools for Cloud Foundry with plugins for blue-green deployment and MTA. | [ppiper/cf-cli](https://hub.docker.com/r/ppiper/cf-cli) |
| Neo CLI | Use SAP Cloud Platform tools for Neo. | [neo-cli/](https://hub.docker.com/r/ppiper/neo-cli/) |
| Jenkinsfile Runner| Run a `Jenkinsfile` without a long-running, stateful Jenkins master. The [Jenkinsfile Runner](https://github.com/jenkinsci/jenkinsfile-runner) is based on `ppiper/jenkins-master`. | [ppiper/jenkinsfile-runner](https://hub.docker.com/r/ppiper/jenkinsfile-runner) |
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
