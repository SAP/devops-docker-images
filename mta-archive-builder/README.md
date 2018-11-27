# How to use this docker iamge

`docker run --rm -v `pwd`:/project -it <tag> mtaBuild <mta_args>`, e.g.

`docker run --rm -v `pwd`:/project -it mta:latest mtaBuild --version`

The folder containing the project needs to be mounted into the image at `/project`.

# About this image

## This image provides:

- SAP Multi Target Archive Builder (MTA)
- Node
- SAP registry (@sap:registry https://npm.sap.com) contained in global node configuration.

## How the image is tested

A test project with a valid setup

  - `package.json` declaring dependency to `grunt-sapui5-bestpractice-build` for building a fiori application
  - Gruntfile defining some standard tasks
  - `mta.yaml`

is provided alongside with the docker script.

`run.sh` builds the docker image and runs it based on the test project.
