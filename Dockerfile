FROM ragedunicorn/openjdk:1.2.0-jdk-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>"

#    ______                           __
#   /_  __/___  ____ ___  _________ _/ /_
#   / / / __ \/ __ `__ \/ ___/ __ `/ __/
#  / / / /_/ / / / / / / /__/ /_/ / /_
# /_/  \____/_/ /_/ /_/\___/\__,_/\__/

# image args
ARG TOMCAT_USER=tomcat
ARG TOMCAT_GROUP=tomcat

# software versions
ENV \
  TOMCAT_MAJOR_VERSION=8 \
  TOMCAT_MINOR_VERSION=8.5.38 \
  SU_EXEC_VERSION=0.2-r0

ENV \
  TOMCAT_USER="${TOMCAT_USER}" \
  TOMCAT_GROUP="${TOMCAT_GROUP}" \
  CATALINA_HOME=/opt/apache-tomcat

# explicitly set user/group IDs
RUN addgroup -S "${TOMCAT_GROUP}" -g 9999 && adduser -S -G "${TOMCAT_GROUP}" -u 9999 "${TOMCAT_USER}"

RUN \
  set -ex; \
  apk add --no-cache su-exec="${SU_EXEC_VERSION}"

WORKDIR /home

RUN \
  set -ex; \
  if ! wget -q https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz; then \
    echo >&2 "Error: Failed to download Tomcat binary"; \
    exit 1; \
  fi && \
  if ! wget -qO - https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz.sha512 | sha512sum -c -; then \
    echo >&2 "Error: Failed to verify Tomcat signature"; \
    exit 1; \
  fi && \
  tar zxf apache-tomcat-*.tar.gz && \
  rm apache-tomcat-*.tar.gz && \
  mkdir -p /opt/apache-tomcat && \
  mv apache-tomcat-"${TOMCAT_MINOR_VERSION}"/* /opt/apache-tomcat/ && \
  rm -r apache-tomcat-"${TOMCAT_MINOR_VERSION}" && \
  chown -R "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/

# add tomcat config
COPY config/tomcat-users.xml /opt/apache-tomcat/conf/tomcat-users.xml
COPY config/tomcat-users-template.xml /opt/apache-tomcat/conf/tomcat-users-template.xml
# overwrite manager context
COPY config/context.xml /opt/apache-tomcat/webapps/manager/META-INF/context.xml

# add healthcheck script
COPY docker-healthcheck.sh /

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chown "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/conf/tomcat-users.xml && \
  chown "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/conf/tomcat-users-template.xml && \
  chown "${TOMCAT_USER}":"${TOMCAT_GROUP}" /opt/apache-tomcat/webapps/manager/META-INF/context.xml && \
  chmod 755 /docker-entrypoint.sh && \
  chmod 755 /docker-healthcheck.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
