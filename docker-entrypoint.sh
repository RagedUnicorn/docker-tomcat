#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for tomcat

# abort when trying to use unset variable
set -o nounset

exec su-exec tomcat ${CATALINA_HOME}/bin/catalina.sh run
