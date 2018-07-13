#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description build script for docker-tomcat container

# abort when trying to use unset variable
set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_TOMCAT_TAG="ragedunicorn/tomcat"
DOCKER_TOMCAT_NAME="tomcat"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: Building container: ${DOCKER_TOMCAT_NAME} - ${DOCKER_TOMCAT_TAG}"

# build java container
docker build -t "${DOCKER_TOMCAT_TAG}" ../

cd "${WD}"
