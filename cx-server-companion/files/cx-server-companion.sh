#!/bin/bash

readonly container_name='cx-jenkins-master'
readonly nexus_container_name='cx-nexus'
readonly cache_docker_image='sonatype/nexus3:3.13.0'
readonly cxserver_companion_docker_image='ppiper/cxserver-companion'
readonly container_port_http=8080
readonly container_port_https=8443

readonly network_name='cx-network'

readonly bold_start="\033[1m"
readonly bold_end="\033[0m"

function log_error()
{
    echo -e "\033[1;31m[Error]\033[0m $1" >&2
}

function log_info()
{
    echo -e "\033[1;33m[Info]\033[0m $1" >&2
}

function log_warn()
{
    echo -e "\033[0;33m[Warning]\033[0m $1" >&2
}

function assert_config_set()
{
    if [ -z "${!1}" ]; then
        log_error "Config parameter '$1' not set."; exit 1;
    fi
}

function get_container_id()
{
    local container_id=$(docker ps --filter "name=${1}" -q)
    echo "${container_id}"
}

function is_container_status()
{
    #set -x
    local container_id=$(docker ps --filter "name=${1}" --filter "status=${2}" -q)
    if [ -z "${container_id}" ]; then
        false
    else
        true
    fi
}

#checks whether the supplied container name is running
function is_running()
{
    local container_id="$(get_container_id "${1}")"
    if [ ! -z "$container_id" ]; then
        log_info "The ${1} container is already running with container id '${container_id}'."
        true
    else
        false
    fi
}

function retry()
{
    local attempts=$1
    shift
    local delay=$1
    shift
    local expected_status_code=$1
    shift
    local i

    for ((i=0; i < attempts; i++)); do
        echo -n "."
        #set -x
        eval "${*} 1> /dev/null"
        if [ $? -eq "${expected_status_code}" ]; then
            echo " success."
            return 0
        fi
        sleep "${delay}"
    done

    log_error "Command \"$*\" failed ${attempts} times."
    false
}

function trace_execution()
{
    echo -e "\033[1m>>\033[0m $*"
}

function run()
{
    trace_execution "$*"
    eval "$*"
    return $?
}

# join , "${arr[@]}" => joins arr by commas to get comma separated string
function join()
{
    local IFS="$1"
    shift
    echo "$*"
}

function get_proxy_parameters()
{
    local proxy_params=()
    local behind_proxy=false

    local image_name="${1}"

    local image_http_proxy=$(get_image_environment_variable "${image_name}" http_proxy)
    local image_https_proxy=$(get_image_environment_variable "${image_name}" https_proxy)
    local image_no_proxy=$(get_image_environment_variable "${image_name}" no_proxy)

    if [ ! -z "${http_proxy}" ]; then
        proxy_params+=(-e HTTP_PROXY="${http_proxy}" -e http_proxy="${http_proxy}")
        behind_proxy=true
    elif [ ! -z "${image_http_proxy}" ]; then
        behind_proxy=true
    fi


    if [ ! -z "${https_proxy}" ]; then
        proxy_params+=(-e HTTPS_PROXY="${https_proxy}" -e https_proxy="${https_proxy}")
        behind_proxy=true
    elif [ ! -z "${image_https_proxy}" ]; then
        behind_proxy=true
    fi

    local no_proxy_values=()
    if [ ! -z "${image_no_proxy}" ]; then
        # image default value
        no_proxy_values=("${image_no_proxy}")
    fi
    if [ ! -z "${no_proxy}" ]; then
        # overwrites potential image value
        no_proxy_values=("${no_proxy}")
    fi

    if [ ! -z "${x_no_proxy}" ]; then
        # append to whatever is there
        no_proxy_values+=("${x_no_proxy}")
    fi
    
    if [ "${behind_proxy}" = true ]; then	
        no_proxy_values+=("${nexus_container_name}")	
    fi

    if [ ${#no_proxy_values[@]} != 0 ]; then
        local no_proxy_values_string="$(join , "${no_proxy_values[@]}")"
        proxy_params+=(-e NO_PROXY="${no_proxy_values_string}" -e no_proxy="${no_proxy_values_string}")
    fi

    local dbg_info=()
    dbg_info+=("Proxy base settings of image '${image_name}':")
    if [ ! -z "${image_http_proxy}" ];  then dbg_info+=("  http_proxy='${image_http_proxy}'"); fi;
    if [ ! -z "${image_https_proxy}" ]; then dbg_info+=("  https_proxy='${image_https_proxy}'"); fi;
    if [ ! -z "${image_no_proxy}" ];    then dbg_info+=("  no_proxy='${image_no_proxy}'"); fi;

    dbg_info+=("Proxy settings of environment / server.cfg:")
    if [ ! -z "${http_proxy}" ];  then dbg_info+=("  http_proxy='${http_proxy}'"); fi;
    if [ ! -z "${https_proxy}" ]; then dbg_info+=("  https_proxy='${https_proxy}'"); fi;
    if [ ! -z "${no_proxy}" ];    then dbg_info+=("  no_proxy='${no_proxy}'"); fi;
    if [ ! -z "${x_no_proxy}" ];  then dbg_info+=("  x_no_proxy='${x_no_proxy}'"); fi;

    dbg_info+=("Actual Command line params:")
    dbg_info+=("$(join $'\n''  ' "${proxy_params[@]}")")
    dbg_info+=(" ")

    local dbg_info_str="$(join $'\n' "${dbg_info[@]}")"
    # remove comment to dump debug information
    #echo "${dbg_info_str}" >> "proxy.dump"

    echo " ${proxy_params[*]}"
}

function wait_for_started()
{
    echo -n "Waiting for the Cx server to start"
    retry 120 1 0 docker exec "${container_name}" curl --noproxy localhost --silent "http://localhost:${container_port_http}/api/json"
}

function stop_jenkins()
{
    container_id="$(get_container_id "${container_name}")"
    if [ -z "${container_id}" ]; then
        log_info "The Cx server is not running."
    else
        echo 'Stopping Jenkins'
        stop_jenkins_container
    fi
}

function stop_jenkins_container()
{
    echo -n "Jenkins username (leave empty for unprotected server): "
    read -r user_name

    user_and_pass=()
    if [ ! -z "${user_name}" ]; then
        echo -n "Password for ${user_name}: "
        read -r -s password
        user_and_pass=(-u "${user_name}:${password}")
    fi

    echo ""
    echo "Initiating safe shutdown..."

    exitCmd=(docker exec ${container_name} curl --noproxy localhost --write-out '%{http_code}' --output /dev/null --silent "${user_and_pass[@]}" -X POST "http://localhost:${container_port_http}/safeExit")

    if [ ! -z "${password}" ]; then
        trace_execution "${exitCmd[@]//${password}/******}"
    else
        trace_execution "${exitCmd[@]}"
    fi

    echo -n "Waiting for Cx server to accept safeExit signal..."
    local attempts=120
    local i
    for ((i=0; i < attempts; i++)); do
        echo -n "."
        local result="$("${exitCmd[@]}")"
        if [ "${result}" = "503" ]; then
            sleep 1
        elif [ "${result}" = "200" ]; then
            echo " success."
            break
        elif [ "${result}" = "401" ]; then
            echo ""
            log_error "Wrong credentials."
            exit 1
        else
            echo ""
            log_error "Failed with code ${result}."
            exit 1
        fi
    done

    echo -n "Waiting for running jobs to finish..."
    retry 360 5 0 "is_container_status ${container_name} 'exited'"
}

function stop_nexus()
{
    nexus_container_id="$(get_container_id "${nexus_container_name}")"
    if [ -z "${nexus_container_id}" ]; then
        log_info "The cache server is not running."
    else
        echo 'Stopping nexus'
        run docker stop "${nexus_container_name}"
        remove_networks
    fi
}

function get_image_environment_variable()
{
    cmd='echo $'"${2}"

    env_value="$(docker run --rm --entrypoint /bin/sh "${1}" -c "${cmd}")"
    if [ $? -ne 0 ]; then
        log_error "Failed to extract environment variable '${2}' from image '${1}'"
        exit 1
    fi
    echo "${env_value}"
}

function print_proxy_config()
{
    if [ ! -z "${http_proxy}" ]; then
        echo "   - http_proxy=${http_proxy}"
    fi
    if [ ! -z "${https_proxy}" ]; then
        echo "   - https_proxy=${https_proxy}"
    fi
    if [ ! -z "${no_proxy}" ]; then
        echo "   - no_proxy=${no_proxy}"
    fi
    if [ ! -z "${x_no_proxy}" ]; then
        echo "   - x_no_proxy=${x_no_proxy}"
    fi

}

function print_jenkins_config()
{
    echo "   - jenkins_home=${jenkins_home}"
    if [ ! -z "${x_java_opts}" ]; then
        echo "   - x_java_opts=${x_java_opts}"
    fi
    print_proxy_config
}

function print_nexus_config()
{
    echo "Starting docker container for download cache server."
    echo "Parameters:"
    if [ ! -z "${mvn_repository_url}" ]; then
        echo "   - mvn_repository_url=${mvn_repository_url}"
    fi
    if [ ! -z "${npm_registry_url}" ]; then
        echo "   - npm_registry_url=${npm_registry_url}"
    fi
    if [ ! -z "${x_nexus_java_opts}" ]; then
        echo "   - x_nexus_java_opts=${x_nexus_java_opts}"
    fi
    print_proxy_config
}

function start_nexus()
{
    if [ ${cache_enabled} = true ] ; then
        if is_running "${nexus_container_name}" ; then
            stop_nexus
        fi

        if [ $(docker network ls|grep -c ${network_name}) -gt 1 ]; then
            remove_networks
        fi

        if [ $(docker network ls|grep -c ${network_name}) -eq 0 ]; then
            run docker network create "${network_name}"
        fi

        local my_container_id=$(head -n 1 /proc/self/cgroup | cut -d '/' -f3)
        run docker network connect "${network_name}" "${my_container_id}"
        start_nexus_container
    else
        echo "Download cache disabled."
    fi
}

function start_nexus_container()
{
    # check if exited and start if yes
    if is_container_status "${nexus_container_name}" 'exited'; then
        echo "Nexus container was stopped. Restarting stopped instance..."
        run docker start "${nexus_container_name}"
        if [ $? -ne "0" ]; then
            log_error "Failed to start existing nexus container."
            exit $?;
        fi
    else
        run docker pull "${cache_docker_image}"
        if [ $? -ne "0" ]; then
            log_error "Failed to pull ${cache_docker_image}."
            exit $?;
        fi

        local environment_variable_parameters=()
        if [ ! -z "${x_nexus_java_opts}" ]; then
            local container_java_opts="$(get_image_environment_variable ${cache_docker_image} INSTALL4J_ADD_VM_PARAMS)"
            local effective_java_opts=" -e INSTALL4J_ADD_VM_PARAMS=\""${container_java_opts}" "${x_nexus_java_opts}"\""
        fi
        environment_variable_parameters+="$(get_proxy_parameters "${cache_docker_image}")"
        environment_variable_parameters+="${effective_java_opts}"

        print_nexus_config

        local nexus_port_mapping=""
        if [ ! -z "${DEVELOPER_MODE}" ]; then
            nexus_port_mapping="-p 8081:8081"
        fi

        run docker run --name "${nexus_container_name}" --rm "${nexus_port_mapping}" --network="${network_name}" -d "${environment_variable_parameters[@]}" "${cache_docker_image}"
        if [ $? -ne "0" ]; then
            log_error "Failed to start new nexus container."
            exit $?;
        fi
    fi

    wait_for_nexus_started
    init_nexus
}

function wait_for_nexus_started()
{
    echo -n "Waiting for the nexus server to start"
    retry 120 1 0 docker exec "${nexus_container_name}" curl --noproxy localhost --silent -X GET http://localhost:8081/service/rest/v1/script --header \'Authorization: Basic YWRtaW46YWRtaW4xMjM=\' --header \'Content-Type: application/json\'
}

function init_nexus()
{
    if [ -z "${mvn_repository_url}" ]; then
        mvn_repository_url='https://repo.maven.apache.org/maven2/'
    fi
    if [ -z "${npm_registry_url}" ]; then
        npm_registry_url='https://registry.npmjs.org/'
    fi

    echo "Initializing Nexus"

    if [ ! -z "${no_proxy}" ]; then
        local no_proxy_nexus_init="${no_proxy},${nexus_container_name}"
    else
        local no_proxy_nexus_init="${nexus_container_name}"
    fi

    no_proxy=${no_proxy_nexus_init} node /cx-server/init-nexus.js "{\"mvn_repository_url\": \"${mvn_repository_url}\", \"npm_registry_url\": \"${npm_registry_url}\", \"http_proxy\": \"${http_proxy}\", \"https_proxy\": \"${https_proxy}\", \"no_proxy\": \"${no_proxy}\"}"
}

function start_jenkins()
{
    if ! is_running "${container_name}" ; then
        start_jenkins_container
    else
        log_info "Cx Server is already running."
    fi
}

function start_jenkins_container()
{
    # check if exited and start if yes
    if is_container_status ${container_name} 'exited'; then
        echo "Cx Server container was stopped. Restarting stopped instance..."
        run "docker start ${container_name}"
        if [ $? -ne "0" ]; then
            log_error "Failed to start existing cx-server container."
            exit $?;
        fi
    else
        customDockerfileDir="custom_image"
        if [ -e "${customDockerfileDir}/Dockerfile" ]; then
            echo "Custom Dockerfile in '${customDockerfileDir} 'detected..."
            echo "Starting **customized** docker container for Cx Server."
            echo "Parameters:"
            get_port_mapping port_mapping
            echo "   - jenkins_home=${jenkins_home}"
            print_jenkins_config
            echo ""

            image_name="ppiper/jenkins-master-customized"

            run "docker build --pull -t ${image_name} ${customDockerfileDir}"
            if [ $? -ne "0" ]; then
                log_error "Failed to build custom Dockerfile."
                exit $?;
            fi
        else
            echo "Starting docker container for Cx Server."
            echo "Parameters:"
            get_port_mapping port_mapping
            echo "   - docker_registry=${docker_registry}"
            echo "   - docker_image=${docker_image}"
            print_jenkins_config
            echo ""

            assert_config_set "docker_image"
            assert_config_set "jenkins_home"

            if [ ! -z "${docker_registry}" ]; then
                image_name="${docker_registry}/${docker_image}"
            else
                image_name="${docker_image}"
            fi

            if [ -z ${DEVELOPER_MODE} ]; then 
                run "docker pull ${image_name}"; 
                if [ $? -ne "0" ]; then
                    log_error "Failed to pull '$image_name'."
                    exit $?;
                fi
            fi
        fi

        # determine docker gid
        docker_gid=$(stat -c '%g' /var/run/docker.sock)

        if [ -z "${docker_gid}" ]; then
            log_error "Failed to determine docker group id."
            exit 1
        else
            user_parameter="-u 1000:${docker_gid}"
        fi

        if [ ! -z "${x_java_opts}" ]; then
            local container_java_opts="$(get_image_environment_variable "${image_name}" JAVA_OPTS)"
            local effective_java_opts="-e JAVA_OPTS=\"${container_java_opts} ${x_java_opts}\""
        fi

        local environment_variable_parameter=()
        if [ ${cache_enabled} = true ] ; then
            environment_variable_parameters+=(" -e DL_CACHE_NETWORK=${network_name}")
        fi
        environment_variable_parameters+=("$(get_proxy_parameters "${image_name}")")
        environment_variable_parameters+=(${effective_java_opts})

        mount_parameters=()
        mount_parameters+=("-v /var/run/docker.sock:/var/run/docker.sock")
        mount_parameters+=("-v ${jenkins_home}:/var/jenkins_home")

        if [ "${tls_enabled}" == true ]; then
            assert_config_set "tls_certificate_directory"
            if [ ! -f ${tls_certificate_directory}/jenkins.crt ] || [ ! -f ${tls_certificate_directory}/jenkins.key ]; then
                log_error "TLS certificate or private key is not found in the configured path."
                log_error "Ensure that the TLS certificate jenkins.crt and the private key jenkins.key exist inside the directory ${tls_certificate_directory}"
                exit 1
            fi
            mount_parameters+=("--mount source=${tls_certificate_directory},target=/var/ssl/jenkins,type=bind")
            effective_jenkins_opts="-e JENKINS_OPTS=\"--httpsCertificate=/var/ssl/jenkins/jenkins.crt --httpsPrivateKey=/var/ssl/jenkins/jenkins.key --httpsPort=${container_port_https} --httpPort=${container_port_http}\""
        else
            effective_jenkins_opts="-e JENKINS_OPTS=\"--httpPort=${container_port_http} --httpsPort=-1\""
        fi

        environment_variable_parameters+=(${effective_jenkins_opts})

        if [ ! -z "${cx_server_path}" ]; then
            if [ ${host_os} = 'windows' ] ; then
                cx_server_path="//$(echo $cx_server_path | sed -e 's/://' -e 's/\\/\//g')"
            fi
            mount_parameters+=("-v \"${cx_server_path}\":/var/cx-server:ro")
        fi

        # start container
        run docker run ${user_parameter} --name "${container_name}" -d -p "${port_mapping}" "${mount_parameters[@]}" "${environment_variable_parameters[@]}" "${image_name}"
        if [ $? -ne "0" ]; then
            log_error "Failed to start new cx-server container."
            exit $?;
        fi
    fi

    wait_for_started
}

function backup_volume()
{
    # FNR will skip the header and awk will print only 4th column of the output.
    free_space=$(df -h /backup | awk 'FNR > 1 {print $4}')
    used_space=$(docker run --rm -v ${jenkins_home}:/volume alpine du -sh /volume|awk '{print $1}')
    log_info "Available free space on the host is ${free_space} and the size of the volume is ${used_space}"

    free_space_bytes=$(df /backup | awk 'FNR > 1 {print $4}')
    used_space_bytes=$(docker run --rm -v ${jenkins_home}:/volume alpine du -s /volume|awk '{print $1}')
    # Defensive estimation: Backup needs twice the volume size (copying + zipping)
    estimated_free_space_after_backup=$(expr ${free_space_bytes} - $(expr ${used_space_bytes} \* 2))

    if [[ ${estimated_free_space_after_backup} -lt 0 ]]; then
      log_error "Not enough disk space for creating a backup. We require twice the size of the volume."
      exit 1
    fi

    # Backup can be taken when Jenkins server is up
    # https://wiki.jenkins.io/display/JENKINS/Administering+Jenkins
    log_info "Backup of ${jenkins_home} is in progress. It may take several minutes to complete."
    sh -c "mkdir -p /backup/temp/ && \
            rm -rf /backup/temp/ && \
            cp -pr /jenkins_home /backup/temp/ && \
            tar czf /backup/${backup_file_name} -C /backup/temp/ . /cx-server/mount/server.cfg &&\
            chmod u=rw,g=rw,o= /backup/${backup_file_name} && \
            rm -rf /backup/temp/"
    if [ $? -ne "0" ] || [ ! -f /backup/${backup_file_name} ]; then
        log_error "Failed to take a backup of ${jenkins_home}."
        exit 1;
    fi
    log_info "Backup is completed and available at /backup directory. File name is ${backup_file_name}"
    log_info "Please note, this backup contains sensitive information."
}

function command_help_text()
{
    # 14 is the field width of the command name column
    printf "  ${bold_start}%-14s${bold_end} %s\n" "${1}" "${2}"
}

function display_help()
{
    if [ ! -z "$1" ]; then
        echo "'cx-server $1', unknown command"
    fi
    echo ""
    echo "Usage: cx-server [COMMAND]"
    echo ""
    echo "Tool for controlling the lifecycle of the Cx server."
    echo "Use server.cfg for customizing parameters."
    echo ""
    echo "Commands:"
    command_help_text 'start'         'Starts the server container using the configured parameters for jenkins_home, docker_registry, docker_image, http_port.'
    command_help_text 'status'        'Display status information about Cx Server'
    command_help_text 'stop'          'Stops the running server container.'
    command_help_text 'remove'        "Removes a stopped server container. A subsequent call of 'start' will instantiate a fresh container."
    command_help_text 'backup'        "Takes a backup of the configured 'jenkins_home' and stores it in the configured 'backup_directory'."
    command_help_text 'restore'       "Restores the content of the configured 'jenkins_home' by the contents of the provided backup file. Usage: 'cx-server restore <absolute_path_to_backup_file>'."
    command_help_text 'update script' 'Explicitly pull the Docker image containing this script to update to its latest version. Running this is not required, since the image is updated automatically.'
    command_help_text 'update image'  "Updates the configured 'docker_image' to the newest available version of Cx Server image on Docker Hub."
    command_help_text 'help'          "Shows this help text."
}

function restore_volume()
{
    if [ -z "$1" ]; then
        log_error "No argument supplied, restore requires a name of the backup file."
        exit 1
    fi
    if [ ! -f "/backup/${1}" ]; then
        log_error "Backup file /backup/${1} can not be read or does not exist."
        exit 1
    fi
    local back_up_file="/backup/${1}"
    log_warn "Restore will stop the jenkins, delete content of ${jenkins_home} and restore it with ${back_up_file}\n Do you really want to continue?(yes/no)"
    read answer
    if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ]; then
        stop_jenkins
        log_info "Starting to restore the state of the ${jenkins_home} from ${back_up_file}"
        rm -rf /jenkins_home/* /jenkins_home/..?* /jenkins_home/.[!.]* && tar -C /jenkins_home/ -zxf ${back_up_file} && cp /jenkins_home/cx-server/mount/server.cfg /cx-server/mount/server.cfg && chmod u=rw,g=rw,o=rw /cx-server/mount/server.cfg
        if [ $? -eq 0 ]; then
            log_info "Restore completed"
            remove_containers
            log_info "Jenkins is stopped.\n Would you like to start it?(yes/no)"
            read answer
            if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ]; then
                read_configuration
                start_nexus
                start_jenkins
            fi
        else
            log_error "There was an error restoring the backup"
        fi
    elif [ "$answer" == "N" ] || [ "$answer" == "n" ] || [ "$answer" == "NO" ] || [ "$answer" == "no" ]; then
        log_info "Cancelling restore"
    else
        log_info "Invalid input"
        exit 1
    fi
}

function remove_containers()
{
    run docker rm "${container_name}"
}

function remove_networks()
{
    for network_id in $(docker network ls | grep ${network_name} | awk '{print $1}')
    do
        run docker network remove "${network_id}"
    done
}

function read_configuration()
{
    dos2unix /cx-server/mount/server.cfg
    source /cx-server/default-server.cfg
    source /cx-server/mount/server.cfg
    if [ $? -ne 0 ]; then
        log_error 'Failed to load config from server.cfg file.'
        exit 1
    fi
}

function check_image_update()
{
    if [ -z ${DEVELOPER_MODE} ]; then docker pull "${cxserver_companion_docker_image}"; fi

    echo -n "Checking for new version of Cx Server Docker image... "

    local return_code
    local stdout

    if [ ! -z ${docker_registry} ]; then
        echo "skipping update check because custom docker registry is used."
    else
        local proxy_params=$(get_proxy_parameters "${cxserver_companion_docker_image}")
        stdout="$(docker run --rm ${proxy_params[*]} "${cxserver_companion_docker_image}" node /cx-server/checkversion.js "${docker_image}")"
        return_code=$?

        if [ ${return_code} -eq 0 ]; then
            echo "'${docker_image}' is up to date."
        elif [ ${return_code} -eq 3 ]; then
            echo "newer version available: '${stdout}' (current version '${docker_image}')."
            echo -e "${bold_start}Please run 'cx-server update image' to update Cx Server Docker image to its newest version.${bold_end}"
        else
            log_warn "check returned with error code (${return_code}). Error message: '${stdout}'."
        fi
    fi
}

function update_image()
{
    if [ -z ${DEVELOPER_MODE} ]; then docker pull "${cxserver_companion_docker_image}"; fi
    if [ ! -z ${docker_registry} ]; then
        log_error "You are using a custom docker registry. Automated updating is only supported for Docker Hub. Please perform a manual update."
        exit 1
    fi

    echo "Checking for newest version of Cx Server Docker image... "

    local newimagecmd_return_code
    local newimagecmd_stdout

    local proxy_params=$(get_proxy_parameters "${cxserver_companion_docker_image}")
    newimagecmd_stdout="$(node ../checkversion.js "${docker_image}")"
    newimagecmd_return_code=$?

    if [ ${newimagecmd_return_code} -eq 0 ]; then
        echo "Your current version '${docker_image}' is up to date."
    elif [ ${newimagecmd_return_code} -eq 3 ]; then
        echo "Newer version detected. Updating to '${newimagecmd_stdout}'."

        local replaceimgcmd_returncode
        local replaceimagecmd_stdout
        replaceimagecmd_stdout=$(node ../updateversion.js "${docker_image}" "${newimagecmd_stdout}")
        replaceimgcmd_returncode=$?

        if [ ${replaceimgcmd_returncode} -eq 0 ]; then
            echo "Success: ${replaceimagecmd_stdout}"
        else
            log_error "${replaceimagecmd_stdout}"
            exit ${replaceimgcmd_returncode}
        fi

    else
        log_error "Check returned with error code (${newimagecmd_return_code}). Error message: '${newimagecmd_stdout}'."
    fi
}

function update_cx_server_script()
{
    # Bash
    if [ ! -f '/cx-server/cx-server' ]; then
        echo ""
        log_error 'Failed to read newest cx-server version for Bash. Skipping update.'
    else
        newest_version="$(</cx-server/cx-server)"

        if [ ! -f '/cx-server/mount/cx-server' ]; then
            echo ""
            log_warn 'Failed to read current cx-server version for Bash. Updating to new version.'
            echo "${newest_version}" > '/cx-server/mount/cx-server'
        fi
        this_version="$(</cx-server/mount/cx-server)"
        if [ "${this_version}" != "${newest_version}" ]; then
            echo " detected newer version. Applying update."
            echo "${newest_version}" > '/cx-server/mount/cx-server'
        fi
    fi


    # Windows
    if [ ! -f '/cx-server/cx-server.bat' ]; then
        echo ""
        log_error 'Failed to read newest cx-server version for Windows. Skipping update.'
    else
        newest_version_bat="$(</cx-server/cx-server.bat)"

        if [ ! -f '/cx-server/mount/cx-server.bat' ]; then
            echo ""
            log_warn 'Failed to read current cx-server version for Windows. Updating to new version.'
            echo "${newest_version_bat}" > '/cx-server/mount/cx-server.bat'
        fi
        this_version_bat="$(</cx-server/mount/cx-server.bat)"
        if [ "${this_version_bat}" != "${newest_version_bat}" ]; then
            echo " detected newer version for Windows. Applying update."
            echo "${newest_version_bat}" > '/cx-server/mount/cx-server.bat'
            unix2dos /cx-server/mount/cx-server.bat
        fi
    fi
    exit 0
}

# With too little memory, containers might get killed without any notice to the user.
# This is likely the case when running Docker on Windows or Mac, where a Virtual Machine is used which has 2 GB memory by default.
# At least, we can indicate that memory might be an issue to the user.
function check_memory() {
    memory=$(free -m | awk '/^Mem:/{print $2}');
    # The "magic number" is an approximation based on setting the memory of the Linux VM to 4 GB on Docker for Mac
    if [ "${memory}" -lt "3900" ]; then
        echo "${memory}"
    fi
}

function warn_low_memory() {
    local memory=$(check_memory)
    if [ ! -z "${memory}" ]; then
        log_warn "Low memory assigned to Docker detected (${memory} MB). Please ensure Docker has at least 4 GB of memory, otherwise your builds are likely to fail."
        log_warn "Depending on the number of jobs running, much more memory might be required."
        log_warn "On Windows and Mac, check how much memory Docker can use in 'Preferences', 'Advanced'. See https://docs.docker.com/docker-for-windows/#advanced or https://docs.docker.com/docker-for-mac/#advanced for more details."
    fi
}

function warn_low_memory_with_confirmation() {
    warn_low_memory
    local memory=$(check_memory)
    if [ ! -z "${memory}" ]; then
        log_warn "Are you sure you want to continue starting Cx Server with this amount of memory? (Y/N)"

        read answer
        if [ "$answer" == "Y" ] || [ "$answer" == "y" ] || [ "$answer" == "YES" ] || [ "$answer" == "yes" ]; then
            log_warn "Please keep an eye on the available memory, for example, using 'docker stats'."
        else
            exit 1
        fi
    fi
}

function get_port_mapping(){
    declare -n return_value=$1
    local mapping=""
    if [ "${tls_enabled}" == true ]; then
        echo "   - https_port=${https_port}"
        assert_config_set "https_port"
        mapping="${https_port}:${container_port_https}"
    else
        echo "   - http_port=${http_port}"
        assert_config_set "http_port"
        mapping="${http_port}:${container_port_http}"
    fi
    return_value=$mapping
}

### Start of Script
read_configuration

# ensure that docker is installed
command -v docker > /dev/null 2>&1 || { echo >&2 "Docker does not seem to be installed. Please install docker and ensure that the docker command is included in \$PATH."; exit 1; }

if [ "$1" == "backup" ]; then
    backup_volume
elif [ "$1" == "restore" ]; then
    restore_volume "$2"
elif [ "$1" == "start" ]; then
    warn_low_memory_with_confirmation
    check_image_update
    start_nexus
    start_jenkins
elif [ "$1" == "stop" ]; then
    check_image_update
    stop_jenkins
    stop_nexus
elif [ "$1" == "start_cache" ]; then
    start_nexus
elif [ "$1" == "stop_cache" ]; then
    stop_nexus
elif [ "$1" == "remove" ]; then
    remove_containers
    remove_networks
elif [ "$1" == "update" ]; then
    if [ "$2" == "script" ]; then
        docker pull "${cxserver_companion_docker_image}"
    elif [ "$2" == "image" ]; then
        stop_nexus
        stop_jenkins
        remove_containers
        remove_networks
        backup_volume
        update_image
        read_configuration
        start_nexus
        start_jenkins
    else
        log_error "Missing qualifier. Please specify a update qualifier. Execute 'cx-server' for more information."
    fi
elif [ "$1" == "help" ]; then
    display_help
    warn_low_memory
elif [ "$1" == "status" ]; then
    node /cx-server/status.js "{\"cache_enabled\": \"${cache_enabled}\"}"
else
    display_help "$1"
    warn_low_memory
fi

if [ -z ${DEVELOPER_MODE} ]; then update_cx_server_script; fi
