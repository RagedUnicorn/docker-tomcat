#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description run script for docker-tomcat container

# abort when trying to use unset variable
set -euo pipefail

WD="${PWD}"

# variable setup
DOCKER_TOMCAT_TAG="ragedunicorn/tomcat"
DOCKER_TOMCAT_NAME="tomcat"
DOCKER_TOMCAT_ID=0

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# check if there is already an image created
docker inspect ${DOCKER_TOMCAT_NAME} &> /dev/null

if [ $? -eq 0 ]; then
  # start container
  docker start "${DOCKER_TOMCAT_NAME}"
else
  ## run image:
  # -p expose port
  # -d run in detached mode
  # -i Keep STDIN open even if not attached
  # -t Allocate a pseudo-tty
  # --name define a name for the container(optional)
  DOCKER_TOMCAT_ID=$(docker run \
  -p 8080:8080 \
  -dit \
  --name "${DOCKER_TOMCAT_NAME}" "${DOCKER_TOMCAT_TAG}")
fi

if [ $? -eq 0 ]; then
  # print some info about containers
  echo "$(date) [INFO]: Container info:"
  docker inspect -f '{{ .Config.Hostname }} {{ .Name }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' ${DOCKER_TOMCAT_NAME}
else
  echo "$(date) [ERROR]: Failed to start container - ${DOCKER_TOMCAT_NAME}"
fi

cd "${WD}"
