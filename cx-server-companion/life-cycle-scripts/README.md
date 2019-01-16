# Cx Server Development Guide

The Cx Server script was moved into the companion Docker image, the remaining script is only a wrapper to invoke Docker.
This allows us to make the Cx Server work on Windows easily.

This has a few consequences for developing the script, which are described in this document.

When you make changes to `cx-server-companion/cx-server-companion.sh`, you need to build the `ppiper/cxserver-companion` image locally.
From this directory (`jenkins-master/cx-server`), the command to do so is:

```bash
docker build [--build-arg cx_server_base_uri=https://github.some.domain/raw/path/to/cx-server] -t ppiper/cxserver-companion ../../ppiper-cxserver-companion
```

The build argument `cx_server_base_uri` is optional and only required if you don't want to use the `cx-server` version from GitHub.com.

When you make changes to `ppiper/jenkins-master`, you also need to build the image locally.
The important part is that you tag the image after building it.
Assuming you changed an image, configured the `docker_registry` and `image_name` in the `server.cfg`, then you have to tag your image locally with `docker_registry/image_name`.

Usually, when running `cx-server`, the companion and Jenkins images are automatically pulled from Docker Hub.
This is designed for simple usage, but if you've built the images yourself, it will overwrite your changes.
To prevent this, set the environment variable `DEVELOPER_MODE` to _any_ value.

Run in developer mode on Bash
```bash
export DEVELOPER_MODE=1
./cx-server [command]
```

Run in developer mode in `cmd.exe`
```
set DEVELOPER_MODE=1
cx-server.bat [command]
```

Run in developer mode in Powershell
```
$env:DEVELOPER_MODE = 1
cx-server.bat [command]
```

To switch back to the "normal" behavior, unset the environment variable `DEVELOPER_MODE`.

Also __please note__ that the `cx-server` script always worked with the assumption that it was invoked from its directory, which is still the case.

For more convenient usage of `cx-server`, you can source the `cx-server-completion.bash` script, which makes the sub-commands of `cx-server` known.
