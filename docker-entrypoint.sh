#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for tomcat

# abort when trying to use unset variable
set -o nounset

exec gosu tomcat ${CATALINA_HOME}/bin/catalina.sh run
