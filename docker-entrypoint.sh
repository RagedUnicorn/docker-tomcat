#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for tomcat

set -euo pipefail

tomcat_home="/home/tomcat"
tomcat_template_user_config="/opt/apache-tomcat/conf/tomcat-users-template.xml"
tomcat_user_config="/opt/apache-tomcat/conf/tomcat-users.xml"
tomcat_app_user="/run/secrets/com.ragedunicorn.tomcat.app_user"
tomcat_app_user_password="/run/secrets/com.ragedunicorn.tomcat.app_user_password"

# if secret is set update configuration accordingly
if [ -f "${tomcat_app_user}" ] && [ -f "${tomcat_app_user_password}" ]; then
  # track whether init process was already done
  if [ ! -f "${tomcat_home}/.init" ]; then
    echo "$(date) [INFO]: Overriding tomcat configuration"

    cp "${tomcat_template_user_config}" "${tomcat_template_user_config}.tmp"
    sed -i -e "s/\\[username\\]/$(cat ${tomcat_app_user})/" "${tomcat_template_user_config}.tmp"
    sed -i -e "s/\\[password\\]/$(cat ${tomcat_app_user_password})/" "${tomcat_template_user_config}.tmp"
    sed -i -e "s/\\[roles\\]/admin-gui,admin-script,manager-gui,manager-script,manager-jmx/" "${tomcat_template_user_config}.tmp"

    mv "${tomcat_template_user_config}.tmp" "${tomcat_user_config}"
    rm "${tomcat_template_user_config}.tmp"

    touch "${tomcat_home}/.init"
    echo "$(date) [INFO]: Successfully updated tomcat configuration"
  fi
else
  echo "$(date) [INFO]: Using default tomcat users configuration"
fi

exec su-exec "${TOMCAT_USER}" "${CATALINA_HOME}/bin/catalina.sh" run
