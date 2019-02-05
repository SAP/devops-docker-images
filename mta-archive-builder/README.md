# How to use this docker iamge

`docker run --rm -v `pwd`:/project -it <tag> mtaBuild <mta_args>`, e.g.

`docker run --rm -v `pwd`:/project -it mta:latest mtaBuild --version`

or

`docker run --rm -v `pwd`:/project -it mta:latest mtaBuild --mtar dummy.mtar --build-target NEO build`

The folder containing the project needs to be mounted into the image at `/project`.

# About this image

## This image provides:

- SAP Multi Target Archive Builder (MTA)
- Node
- SAP registry (@sap:registry https://npm.sap.com) contained in global node configuration.
- Maven

MTA delegates to other build tools. This image provides node and maven, so MTA can delegate
to these build technologies. In case more build tools are needed inherit from this image and
add more build tools.
