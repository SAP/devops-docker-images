## Operations Guide for Cx Server

This guide describes life-cycle management of the Cx Server for Continuous Integration and Delivery. The server is controlled with the `cx-server` script.

#### Introduction
The `cx-server` and the `server.cfg` files will help to manage the complete lifecycle of Jenkins server. You can generated these file by using the below docker command.
```
docker run -it --rm -u `id -u`:`id -g` -v ${PWD}:/cx-server/mount/ ppiper/cxserver-companion:latest init
```

For the convenient usage of the script, a [completion script](https://raw.githubusercontent.com/SAP/devops-docker-images/master/cx-server-companion/cx-server/life-cycle-scrips/cx-server-completion.bash) for `cx-server` is provided. 
Source it in your shell, or refer to the documentation of your operating system for information on how to install this script system wide.

#### System requirement

##### Productive usage
In order to setup the cx-server for the productive purpose, we recommend the minimum hardware and software requirements as mentioned below.
As of now, we do not support the productive setup on a Windows operating system.

| Property | Recommendation |
| --- | --- |
| Operating System | `Ubuntu 16.04.4 LTS`  |
| Docker | `18.06.1-ce` |
| Memory  | `4GB` reserved for docker |
| Available Disk Space | `4GB` |

##### Development usage
The `cx-server` can also run on a Windows or MacOs. But, only for the development purposes. 
In order to run the `cx-server` on Windows, you need to share the `C` drive with a docker demon as explained [here](https://docs.docker.com/docker-for-windows/#shared-drives). 
Set the docker memory to at least 4GB, you can [configure](https://docs.docker.com/docker-for-windows/#advanced) this under the `Advanced` settings tab.
 
#### Configuring the `cx-server`
The `cx-server` can be customized to fit your use case. The `server.cfg` file contains the configuration details of your `cx-server`.

  | Property | Mandatory | Default Value | Description |
  | --- | --- | --- | --- |
  |`docker_image` | X | `ppiper/jenkins-master:latest`|  Jenkins docker image name with the version to be used|
  |`docker_registry` |  | Default docker registry used by the docker demon on the host machine |  Docker registry to be used to pull docker images from|
  |`jenkins_home`| X|`jenkins_home_volume`| The volume to be used as a `jenkins_home`. Please ensure, this volume is accessible by the user with id `1000` |
  |`http_port`| X (If `tls_enabled` is `false`) |`80`| The HTTP port on which the server listens for incoming connections.|
  |`tls_enabled`| |`false`| Use Transport Layer Security encryption for additional security|
  |`tls_certificate_directory`| X (If `tls_enabled` is `true`) | | Absolute path to the directory where the `jenkins.key` and `jenkins.crt` files exists|
  |`https_port`| X (If `tls_enabled` is `true`)|`443`| The HTTPS port on which the server listens for incoming connections.|
  |`http_proxy`| | | Effective value of `http_proxy` environment variable wich is automatically passed on to all containers in the CI/CD setup. The Java proxy configuration of Jenkins and the download cache are automatically derived from this value. Proxy authentication is supported by the syntax `http://username:password@myproxy.corp:8080`. |
  |`https_proxy`| | | Same as `http_proxy` but for https URLs. Jenkins only supports one proxy URL. Therefore, if `https_proxy` and `http_proxy` are defined, the URL of `https_proxy` takes precedence for initializing the Jenkins proxy settings. |
  |`no_proxy`| | | Whitelisting of hosts from the proxy. It will be appended to any previous definition of `no_proxy`|
  |`backup_directory`| | `(pwd)/backup` | Directory where the backup of the jenkins home directory contents are stored|
  |`backup_file_name`| |`jenkins_home_YYYY-MM-DDThhmmUTC.tar.gz`| Name of the backup file to be created|
  |`x_java_opts`| | | Additional `JAVA_OPTS` that need to be passed to the Jenkins container|
  |`cache_enabled`| |`true` | Flag to enable or disable the caching mechanism for `npm` and `maven` dependencies|
  |`mvn_repository_url`| | Maven central repository URL| It will be used if you need to configure a custom maven repository|
  |`npm_registry_url`| | Central NPM registry| It will be used if you need to configure a custom npm registry|
  |`x_nexus_java_opts`| | | You can configure the JAVA_OPTS of the download cache server using this option|

#### Life-cycle of `cx-server` 
##### start
You can start the Jenkins server by launching the `start` command.

```bash
./cx-server start
``` 

When launched, it checks if the Docker container named `cx-jenkins-master` already exists.
If yes, it restarts the stopped container. Otherwise, it spawns a new Docker container based on the configuration in `server.cfg`.

##### status

The status command provides basic overview about your Cx Server instance.

```bash
./cx-server status
``` 

##### stop
The Cx Server can be stopped with the `stop` command.
```bash
./cx-server stop
``` 
This stops the Jenkins Docker container if it is running. A subsequent `start` command restores the container.

##### remove
This command removes the Jenkins container from the host if it is not running.

```bash
./cx-server remove
```

##### backup
The `jenkins_home` contains the state of the Jenkins which includes important details such as settings, Jenkins workspace, and job details.
Considering the importance of it, taking regular backup of the `jenkins_home` is **highly recommended**. 

```bash
./cx-server backup
```
This command creates a backup file and stores it on a host machine inside a directory named `backup`. In order to store the backup on external storage, you can customize the location and name of the backup file in the `server.cfg`.

> **Note:** Administrator of the Jenkins must ensure that the backup is stored in a safe storage.

##### restore
In an event of a server crash, the state of the Jenkins can be restored to a previously saved state if there is a backup file available. You need to execute the `restore` command along with the absolute path to the backup file that you want to restore the state to.
 
Example:

```bash
./cx-server restore /home/cx-server/backup/jenkins_home_2018-03-07T1528UTC.tar.gz
```

> **Warning:** In order to restore the Jenkins home directory, this command stops the Jenkins server first and **delete the content of the Jenkins home directory**.
> After the completion of the restore operation, it starts the Jenkins server upon user confirmation.

##### update script
The `cx-server` script can be updated via the `update script` command, if a new version is available.
```bash
./cx-server update script
```

##### update image
By default, the Cx Server image defined by `docker_image` in `server.cfg` always points to the newest released version.
In productive environments, you will however likely want to fix the Cx Server image to a specific version.
By defining `docker_image` with a version tag (e.g. `docker_image=ppiper/jenkins-master:v3`), you avoid unintended updates as a side-effect of restarting the Continuous Delivery server.
However, this introduces the risk of getting stuck on an outdated version. Therefore, if you are using an outdated Cx Server version, the `cx-server` script will warn you and recommend to run the `cx-server update image` command.
The `cx-server update image` command updates the Cx Server to the newest available version.
If `v6` is the newest released version, running an update with `docker_image=ppiper/jenkins-master:v3` will update the configuration to `docker_image=ppiper/jenkins-master:v6`.
For this, it executes the following sequence of steps:
* Stop potentially running Cx Server instance
* Perform full backup of home directory
* Update `docker_image` value in `server.cfg` to newest version
* Start Cx Server

Note: The command only works if you use the default image from Docker Hub.
```bash
./cx-server update image
```

#### Caching mechanism 
The `cx-server` provides the local cache for maven and node dependencies. This is enabled by default. A Docker image of [Sonatype Nexus OSS 3.x](https://www.sonatype.com/download-oss-sonatype) is used for this. 

By default the caching service makes use of maven central and npm registries for downloading the dependencies. This can be customized in `server.cfg`. 

In a distributed build environment, the Nexus server is started on each agent.
The agent initializer script `launch-jenkins-agent.sh` takes care of the automatic start of the caching server.
However, when the agent is disconnected, download cache service **will NOT be stopped** automatically.
It is the responsibility of an admin to stop the Nexus service.
This can be achieved by stopping the Docker image on the agent server. 

Example:

```bash
ssh my-user@agent-server
docker stop cx-nexus
docker network remove cx-network
```

If you prefer to use different caching mechanism or not using any, you can disable the caching mechanism in the `server.cfg`.

```bash
cache_enabled=false
```

#### TLS encryption
The `cx-server` can be configured to use the TLS certificate for additional security. 
In order to enable this, set the `tls_enabled` flag to true in the `server.cfg`. 
It is also important to provide the certificates and a private key to `cx-server`.
Set the `tls_certificate_directory` in the `server.cfg` to the directory where the certificate and private key(RSA) exists.
[Here](self-signed-tls.md) you can find a guide to create your self-signed certificate. 
Please note that currently the TLS encryption is not supported for the Windows environment.

Example:

```bash
tls_enabled=true
tls_certificate_directory="/var/tls/jenkins"
https_port="443"
```
>**Note:** If you are enabling the TLS for already existing `cx-server`, then please remove the old container so that the new changes can take effect. 
You can do it by executing below commands.
```bash
./cx-server stop
./cx-server remove
./cx-server start
```

#### Plugins
All the plugins that are required to run the SAP S/4HANA Cloud SDK Continuous Delivery Pipeline and the Piper steps
are already pre-installed. If you update or downgrade them to a specific version, it will be lost every time the `cx-server` image is updated. 
All the plugins are updated with the latest version. 
If there is a need, the user can install additional plugins and configure them. 
However, the `cx-server update` will not update the plugins that are custom installed.

#### Troubleshooting
 
##### Disk space cleanup
If you encounter an issue related to diskspace on a cx-server, you can free up space by launching [system prune](https://docs.docker.com/engine/reference/commandline/system_prune/) command.

***WARNING***
Do not launch this command when cx-server is not running. Because the command will remove all the containers that are stopped. In addition, it also removes the cache and docker images that are not used anymore. 

```bash
docker system prune --all
```

##### Logs

You can find the logs of the `cx-server` and the caching server as part of the Docker logs on the host machine. 

```
docker logs cx-jenkins-master
docker logs cx-nexus
```


