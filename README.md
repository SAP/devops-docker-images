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
