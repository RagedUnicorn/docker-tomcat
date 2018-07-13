#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description script for attaching to running docker-tomcat container

set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_TOMCAT_NAME="tomcat"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: attaching to container ${DOCKER_TOMCAT_NAME}. To detach from the container use Ctrl-p Ctrl-q"
# attach to container
docker attach "${DOCKER_TOMCAT_NAME}"

cd "${WD}"
