# Infrastructure testing

This directory contains testing code for the infrastructure that is defined in the Dockerfiles.

## What it does

* Build the images from source
* Boot a Jenkins master using the life-cycle management script, with the built images
* Create and trigger a Jenkins job, wait for it to be green

## Running as a Service

See `.travis.yml` file for configuration.

## Running locally

```bash
export PPIPER_INFRA_IT_TEST_PROJECT="https://github.com/someuser/somerepo"
export PPIPER_INFRA_IT_CF_USERNAME="myusername"
export PPIPER_INFRA_IT_CF_PASSWORD="mypassword"
./runTests.sh
```
