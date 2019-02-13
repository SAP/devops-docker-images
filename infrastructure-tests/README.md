# Infrastructure testing

This directory contains testing code for the infrastructure that is defined in the Dockerfiles.

## What it does

* Build the images from source
* Boot a Jenkins master using the life-cycle management script, with the built images
* Create and trigger a Jenkins job, wait for it to be green

## Running as a Service

See `.travis.yml` file for configuration.

Configure the following variables (secrets)

* `CX_INFRA_IT_CF_USERNAME` (user name for deployment to SAP Cloud Platform)
* `CX_INFRA_IT_CF_PASSWORD` (password for deployment to SAP Cloud Platform)

## Running locally

Docker is required, and at least 4 GB of memory assigned to Docker.

```bash
export CX_INFRA_IT_CF_USERNAME="myusername"
export CX_INFRA_IT_CF_PASSWORD="mypassword"
./runTests.sh
```
