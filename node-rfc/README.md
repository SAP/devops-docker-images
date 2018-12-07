# RFC CTS+ Docker File
## Description
To bring your SAP Fiori application to your ABAP Front End Server you always need to create a transport request and upload the zip file to it. If you want to automate your delivery pipeline for this scenario, and you have your NW ABAP < 7.50 SP08, you can only do it by using RFC communication. But to get it run you need to do some installation and configuration steps.
A detailed scenario description can be found in our [best practice guid][bestpractice].

This Dockerfile provides an easy and consumable way for the node-rfc wrapper and the SAP NetWeaver RFC Library. The only thing you need to have is a container environment like docker to build and to execute the node-rfc wrapper image. You can use it standalone in your CI/CD environment or you can use it within our Jenkins shared library [project "Piper"][piper].

## Requirements

* General requirements can be found at the [repository readme][general]
* An S-User for [SAP ONE][sapone]
* Please Download SAPCAR for Linux on x86_64 from [SAP ONE][sapone]
* Please Download NWRFC library ```SAP NW RFC SDK 7.20``` for Linux on x86_64 from [SAP ONE][sapone]
* A local docker image repository

## How to build it

You can [build][dockerbuild] your docker image in different ways. 

### Build Arguments
| Argument | Description |
| ---------| ------------|
| **SAPCAR_FILE** |Path to SAPCAR file |
| **NWRFC_FILE** | Path to your NWRFC SAR file |

The build arguments can be a local path or an URL. Please consider the rules for the build context and the used [ADD][dockerbuildadd] command.

Example: Build it with URLs
```
docker build --build-arg SAPCAR_FILE=https://<repoURL>/SAPCAR --build-arg NWRFC_FILE=https://<repoURL>/NWRFC.SAR --file Dockerfile myrepo.git#:node-rfc
```

## How to execute it

### Environment Variables
| Variable | Descritpion |
| -------- | ----------- |
| **ABAP_DEVELOPMENT_USER** | ABAP user to access RFC |
| **ABAP_DEVELOPMENT_PASSWORD** | ABAP user password  |
| **ABAP_DEVELOPMENT_SERVER** | Application server URL |
| **ABAP_DEVELOPMENT_INSTANCE** | ABAP Instance ID |
| **ABAP_DEVELOPMENT_CLIENT** | ABAP Client ID |
| **ABAP_APPLICATION_NAME** | ABAP Application name |
| **ABAP_APPLICATION_DESC** | ABAP Application description |
| **ABAP_PACKAGE** | ABAP package name |
| **ZIP_FILE_URL**     |  URL of the zip file location to upload |
| **GIT_COMMIT** | git commit id |

Run it with:

```
docker run -v <local path>:/var/sap/data --env <Envornment variables> <image> cts createTransportRequest|uploadToABAP|releaseTransport
```
You have to mount the location of the zip file into the container to /var/sap/data. For more details about intermediate files please refer to our [best practices][bestpractice].

[piper]: https://sap.github.io/jenkins-library/
[noderfc]: https://sap.github.io/node-rfc/install.html
[sapone]: https://launchpad.support.sap.com/
[bestpractice]: https://developers.sap.com/tutorials/ci-best-practices-fiori-abap.html
[general]: https://github.com/SAP/devops-docker-images/blob/master/README.md
[dockerbuild]: https://docs.docker.com/engine/reference/commandline/build/
[dockerbuildadd]: https://docs.docker.com/engine/reference/builder/#add
[dockerrun]: https://docs.docker.com/engine/reference/run/
