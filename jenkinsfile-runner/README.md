# Jenkinsfile Runner

Dockerfile for an image with [Jenkinsfile Runner](https://github.com/jenkinsci/jenkinsfile-runner) based on `ppiper/jenkins-master`.

This allows to execute a `Jenkinsfile` from the command-line, thus without the need for a long-running, stateful Jenkins master instance.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/jenkinsfile-runner
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile an run

```
docker build -t ppiper/jenkinsfile-runner .
```

**Warning:** Building this image will take quite long, as the Jenkinsfile Runner is built from source and has many dependencies.
Expect high network traffic.

## Usage

Place a `Jenkinsfile` in the current directory, for example

```
node("master") {
    stage('Hello World') {
        sh 'echo Hello from Jenkins'
    }
}
```

Now you can run it via this command (on Linux and macOS), where the current working directory is mounted to `/workspace`:

```
docker run -v $(pwd):/workspace ppiper/jenkinsfile-runner
```

You should see the message `Hello from Jenkins`, along with more log output.

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.