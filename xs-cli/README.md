# XS CLI Docker File
## Description
To bring an XS application to a HANA XS Server you need to deploy the application with the xs command line tool. This Dockerfile can wrap the xs command line client and the resulting image is intended to run with our Jenkins pipeline library [project "Piper"][piper]. 

## Requirements
* General requirements can be found in the [repository readme][general]
* An S-User for [SAP ONE][sapone]
* Download XS command line client ```xs.onpremise.runtime.client_linuxx86_64-<version>.zip``` for Linux on x86_64 from [SAP ONE][sapone]

## How to build it

This image will not be provided on hub.docker.com. You need to [build][dockerbuild] this Dockerfile locally before using it. Here you can find a [tutorial][xsclient] how to get the xs command line client package.

### Build Arguments
| Argument | Description |
| ---------| ------------|
| **XSZIP** | Path to your XS CLI zip file |

The build arguments can be a local path or an URL. Please consider the rules for the build context and the used [ADD][dockerbuildadd] command.

The following example assumes the xs command line client package is accessible via HTTP:
```
docker build -t ppiper/xs-cli --build-arg XSZIP=https://<location>/xs.onpremise.runtime.client_linuxx86_64-<version>.zip --file Dockerfile https://github.com/SAP/devops-docker-images.git#:xs-cli
```

## How to execute it
Assuming you have built the image with using the tag `ppiper/xs-cli` you can run it with:

```
docker run  ppiper/xs-xli xs <command>
```


# License
Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, v. 2 except as noted otherwise in the LICENSE file.

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[piper]: https://sap.github.io/jenkins-library/
[xsclient]: https://developers.sap.com/germany/tutorials/hxe-ua-install-xs-xli-client.html
[sapone]: https://launchpad.support.sap.com/
[general]: https://github.com/SAP/devops-docker-images/blob/master/README.md
[dockerbuild]: https://docs.docker.com/engine/reference/commandline/build/
[dockerbuildadd]: https://docs.docker.com/engine/reference/builder/#add