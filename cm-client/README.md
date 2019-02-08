# CM Client

The CM Client can handle basic change management related tasks in SAP Solution Manager or with CTS via ODATA requests. The client is intended to be used in continuous integration and continuous delivery scenarios and supports only the actions necessary within those scenarios. See the [documentation](https://github.com/SAP/devops-cm-client) for more details.

# How to use this image

On a linux machine you can run 

`docker run --rm ppiper/cm-client cmclient --help`

This will print the CM Client's help information. For a comprehensive overview of available commands please read the [documentation](https://github.com/SAP/devops-cm-client#usage).

# How to build this image

`docker build -t cm-client .`

## This image provides:

- [CM CLient](https://github.com/SAP/devops-cm-client)

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file][license].

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[license]: https://github.com/SAP/devops-docker-images/blob/master/LICENSE

