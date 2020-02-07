# JaCoCo CLI

Utility image for running the JaCoCo CLI in containerized CI environments.
It contains the openJDK JRE and `jacococli.jar`.

# How to use this image

Open a shell in the image and run `jacococli.jar` like:

```
$ docker run -it --rm ppiper/jacoco-cli
# java -jar /jacococli.jar
Command line interface for JaCoCo.

Usage: java -jar jacococli.jar --help | <command>
 <command> : dump|instrument|merge|report|classinfo|execinfo|version
 --help    : show help
 --quiet   : suppress all output on stdout

Argument "<command>" is required
```

# How to build this image

`docker build -t ppiper/jacoco-cli .`

## This image provides:

- [JaCoCo CLI](https://www.jacoco.org/jacoco/trunk/doc/cli.html)

## License

Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file][license].

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.

[license]: https://github.com/SAP/devops-docker-images/blob/master/LICENSE

