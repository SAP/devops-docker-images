# RFC CTS+ Docker File

## Description

To bring an SAP UI5 application to an ABAP-Frontend-Server you need to create a transport request and upload the application. If you want to automate a Continuous Delivery pipeline for this scenario, you have two options.

| Recommended Solution | Requirements | Link |
|-----|----|----|
| Use OData API | SAPUI 7.53 or newer and AS ABAP 7.50 SP08 or 7.51 SP07 or 7.52 SP03 or newer | [CM Client][cmclient]
| Use RFC Communication | older versions of AS ABAP | This Docker image or follow the [CI Best Practices Guide][bestpractice] |

Setting up the RFC communication is tedious and clutters the build server. Detailed instructions can be found in the [CI Best Practices Guide][bestpractice]. 
This Dockerfile provides a simpler and cleaner way to run the node-rfc wrapper and the SAP NetWeaver RFC Library. The only thing you need to have is a Docker environment to build and to execute the node-rfc wrapper image. The image can be used stand-alone in a custom Continuous Delivery environment or you can use it within our Jenkins library [project "Piper"][piper].

## Requirements

* General requirements can be found in the [repository readme][general]
* An S-User for [SAP ONE][sapone]
* Download NWRFC library ```SAP NW RFC SDK 7.50``` for Linux on x86_64 from [SAP ONE][sapone]

## How to build it

This image will not be provided on hub.docker.com. You need to [build][dockerbuild] this Dockerfile locally before using it. 

### Build Arguments
| Argument | Description |
| ---------| ------------|
| **NWRFC_FILE** | Path to your NWRFC zip file |

The build arguments can be a local path or an URL. Please consider the rules for the build context and the used [ADD][dockerbuildadd] command.

The following example assumes the NWRFC library is accessible via HTTP:
```
docker build -t ppiper/node-rfc --build-arg NWRFC_FILE=https://<location>/nwrcf.zip --file Dockerfile https://github.com/SAP/devops-docker-images.git#:node-rfc
```

## How to execute it

### Environment Variables
| Variable | Description |
| -------- | ----------- |
| **ABAP_DEVELOPMENT_USER** | ABAP user to access RFC |
| **ABAP_DEVELOPMENT_PASSWORD** | ABAP user password  |
| **ABAP_DEVELOPMENT_SERVER** | Application server URL |
| **ABAP_DEVELOPMENT_INSTANCE** | ABAP instance ID |
| **ABAP_DEVELOPMENT_CLIENT** | ABAP client ID |
| **ABAP_APPLICATION_NAME** | ABAP application name |
| **ABAP_APPLICATION_DESC** | ABAP application description |
| **ABAP_PACKAGE** | ABAP package name |
| **ZIP_FILE_URL**     |  URL of the UI5 zip file location to upload |
| **CODE_PAGE** | Code page like UTF8 |
| **ABAP_ACCEPT_UNIX_STYLE_EOL** | true: 'X' or 'Yes' or '1', false: '-' |
| **TRANSPORT_DESCRIPTION** | Transport description text |

Assuming you have built the image with using the tag `ppiper/node-rfc` you can run it with:

```
docker run --env <environment variables> ppiper/node-rfc cts createTransportRequest|uploadToABAP|releaseTransport
```

[piper]: https://sap.github.io/jenkins-library/
[noderfc]: https://sap.github.io/node-rfc/install.html
[sapone]: https://launchpad.support.sap.com/
[bestpractice]: https://developers.sap.com/tutorials/ci-best-practices-fiori-abap.html
[general]: https://github.com/SAP/devops-docker-images/blob/master/README.md
[dockerbuild]: https://docs.docker.com/engine/reference/commandline/build/
[dockerbuildadd]: https://docs.docker.com/engine/reference/builder/#add
[dockerrun]: https://docs.docker.com/engine/reference/run/
[cmclient]: https://github.com/SAP/devops-cm-client
