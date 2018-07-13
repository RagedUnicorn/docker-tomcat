#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description cleanup script for docker-tomcat container.
# Does not delete other containers that where built from the dockerfile

set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_TOMCAT_NAME="tomcat"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# search for containers including non-running containers
docker ps -a | grep "${DOCKER_TOMCAT_NAME}" > /dev/null

# if a container can be found - delete it
if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Cleaning up container ${DOCKER_TOMCAT_NAME} ..."
  docker rm "${DOCKER_TOMCAT_NAME}" > /dev/null
else
  echo "$(date) [INFO]: No existing container with name: ${DOCKER_TOMCAT_NAME} found"
fi

cd "${WD}"
