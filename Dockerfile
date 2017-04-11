FROM ubuntu:zesty

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
  com.ragedunicorn.version="1.0"

#    ______                           __
#   /_  __/___  ____ ___  _________ _/ /_
#   / / / __ \/ __ `__ \/ ___/ __ `/ __/
#  / / / /_/ / / / / / / /__/ /_/ / /_
# /_/  \____/_/ /_/ /_/\___/\__,_/\__/

# software versions
ENV \
  JRE_VERSION=jre1.8.0_101 \
  JRE_SHORT_VERSION=jre-8u101 \
  TOMCAT_MAJOR_VERSION=8 \
  TOMCAT_MINOR_VERSION=8.0.43 \
  CA_CERTIFICATES_VERSION=20161130 \
  DIRMNGR_VERSION=2.1.15-1ubuntu7 \
  WGET_VERSION=1.18-2ubuntu1 \
  GOSU_VERSION=1.10

ENV \
  JRE_HOME=/opt/jre/"${JRE_VERSION}" \
  TOMCAT_USER=tomcat \
  CATALINA_HOME=/opt/apache-tomcat

# explicitly set user/group IDs
RUN groupadd -r "${TOMCAT_USER}" --gid=999 && useradd -r -g "${TOMCAT_USER}" --uid=999 "${TOMCAT_USER}"

# install gosu
RUN \
  set -x && \
  apt-get update && apt-get install -y --no-install-recommends \
    dirmngr="${DIRMNGR_VERSION}" \
    ca-certificates="${CA_CERTIFICATES_VERSION}" \
    wget="${WGET_VERSION}" && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
  export GNUPGHOME && \
  GNUPGHOME="$(mktemp -d)" && \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
  rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/jre
WORKDIR /opt

# install java
RUN \
  wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/8u101-b13/"${JRE_SHORT_VERSION}"-linux-x64.tar.gz && \
  tar -zxf "${JRE_SHORT_VERSION}"-linux-x64.tar.gz -C /opt/jre && \
  update-alternatives --install /usr/bin/java java /opt/jre/"${JRE_VERSION}"/bin/java 100 && \
  rm "${JRE_SHORT_VERSION}"-linux-x64.tar.gz

WORKDIR /home

# install tomcat
RUN \
  set -x && \
  wget -q https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz && \
  wget -qO- https://archive.apache.org/dist/tomcat/tomcat-"${TOMCAT_MAJOR_VERSION}"/v"${TOMCAT_MINOR_VERSION}"/bin/apache-tomcat-"${TOMCAT_MINOR_VERSION}".tar.gz.md5 | md5sum -c - && \
  tar zxf apache-tomcat-*.tar.gz && \
  rm apache-tomcat-*.tar.gz && \
  mv apache-tomcat-"${TOMCAT_MINOR_VERSION}" /opt/apache-tomcat && \
  chown -R ${TOMCAT_USER}":${TOMCAT_USER}" /opt/apache-tomcat/ && \
  apt-get purge -y --auto-remove wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# add tomcat config
COPY conf/tomcat-users.xml /opt/apache-tomcat/conf/tomcat-users.xml
COPY docker-entrypoint.sh /

RUN \
  chown ${TOMCAT_USER}":${TOMCAT_USER}" /docker-entrypoint.sh && \
  chmod 755 /docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
