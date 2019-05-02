# Release Documentation

A release of [devops-docker-images](https://github.com/SAP/devops-docker-images) is defined by git tags and cohesive tags on [Docker Hub](https://hub.docker.com/u/ppiper).
Release versions follow the convention `v{number}` with optional dot versions (valid examples are `v3` and `v17.2`).

Additional namespaced git tags for individual images (like `cmclient-1.0.0.0`) may exist and are not considered a release of the overall project.
Namespaced tags may also contain postfix to document which tool version is packaged, like `jenkinsfile-runner-v3-1.0-beta-7`.

[Existing releases](https://github.com/SAP/devops-docker-images/releases)

## Testing

## How to perform a release

* https://github.com/SAP/devops-docker-images/releases
* Select an appropriate tag name like `v17` (by default increase the last release to the next major version )
* Fill out release notes informing the user about actions they need to take when using this release or new features
