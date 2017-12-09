FROM ragedunicorn/openjdk:1.0.1-jdk-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
  com.ragedunicorn.version="1.0"

#    ______                           __
#   /_  __/___  ____ ___  _________ _/ /_
#   / / / __ \/ __ `__ \/ ___/ __ `/ __/
#  / / / /_/ / / / / / / /__/ /_/ / /_
# /_/  \____/_/ /_/ /_/\___/\__,_/\__/

# software versions
ENV \
  TOMCAT_MAJOR_VERSION=8 \
  TOMCAT_MINOR_VERSION=8.0.43 \
  WGET_VERSION=1.19.1-r2 \
  SU_EXEC_VERSION=0.2-r0

ENV \
  TOMCAT_USER=tomcat \
  TOMCAT_GROUP=tomcat \
  CATALINA_HOME=/opt/apache-tomcat

# explicitly set user/group IDs
RUN addgroup -S "${TOMCAT_GROUP}" -g 9999 && adduser -S -G "${TOMCAT_GROUP}" -u 9999 "${TOMCAT_USER}"

RUN \
  set -ex; \
  apk add --no-cache su-exec="${SU_EXEC_VERSION}"

WORKDIR /home

RUN \
  apk add --no-cache \
    wget="${WGET_VERSION}"; \
  wget -q https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz; \
  wget -qO- https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz.md5 | md5sum -c -; \
  tar zxf apache-tomcat-*.tar.gz; \
  rm apache-tomcat-*.tar.gz; \
  mkdir -p /opt/apache-tomcat; \
  mv apache-tomcat-"${TOMCAT_MINOR_VERSION}"/* /opt/apache-tomcat/; \
  rm -r apache-tomcat-"${TOMCAT_MINOR_VERSION}"; \
  chown -R "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/

# add tomcat config
COPY conf/tomcat-users.xml /opt/apache-tomcat/conf/tomcat-users.xml
COPY conf/tomcat-users-template.xml /opt/apache-tomcat/conf/tomcat-users-template.xml

COPY docker-entrypoint.sh /

RUN \
  chown "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/conf/tomcat-users.xml; \
  chown "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/conf/tomcat-users-template.xml; \
  chmod 755 /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
