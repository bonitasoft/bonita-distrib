FROM ubuntu:18.04

LABEL maintainer="Bonitasoft Runtime team <rd.engine@bonitasoft.com>"

# Execute instructions less likely to change first

# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  gnupg2 \
  mysql-client-core-5.7 \
  openjdk-11-jre-headless \
  postgresql-client \
  unzip \
  zip \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/custom-init.d/

# create user to launch Bonita as non-root
RUN groupadd -r bonita -g 1000 \
  && useradd -u 1000 -r -g bonita -d /opt/bonita/ -s /sbin/nologin -c "Bonita User" bonita

# grab gosu and jattach
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -fsSL "https://github.com/tianon/gosu/releases/download/1.13/gosu-$(dpkg --print-architecture)" -o /usr/local/bin/gosu \
  && curl -fsSL "https://github.com/tianon/gosu/releases/download/1.13/gosu-$(dpkg --print-architecture).asc" -o /usr/local/bin/gosu.asc \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu


# use --build-arg key=value in docker build command to override arguments
ARG BONITA_VERSION
ARG BRANDING_VERSION
ARG BONITA_SHA256
ARG BASE_URL
ARG BONITA_URL

ENV BONITA_VERSION ${BONITA_VERSION:-7.12.2}
ENV BRANDING_VERSION ${BRANDING_VERSION:-2021.1-SNAPSHOT}
ENV BONITA_SHA256  ${BONITA_SHA256:-90705794b6a64b33782a31de31f0ac2bcb96fb3e8836845466cc0eb5dc459e59}
ENV ZIP_FILE BonitaCommunity-${BRANDING_VERSION}.zip
ENV BASE_URL ${BASE_URL:-https://github.com/bonitasoft/bonita-platform-releases/releases/download}
ENV BONITA_URL ${BONITA_URL:-${BASE_URL}/${BRANDING_VERSION}/BonitaCommunity-${BRANDING_VERSION}.zip}
RUN echo "Downloading Bonita from url: ${BONITA_URL}"

RUN mkdir /opt/files
COPY files /opt/files

RUN if [ -f "/opt/files/BonitaCommunity-${BRANDING_VERSION}.zip" ]; then echo "File already present in /opt/files"; else curl -fsSL ${BONITA_URL} -o /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip; fi \
  && sha256sum /opt/files/${ZIP_FILE} \
  && echo "$BONITA_SHA256" /opt/files/${ZIP_FILE} | sha256sum -c - \
  && unzip -q /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip -d /opt/bonita/ \
  && unzip /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/webapps/bonita.war -d /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/webapps/bonita/ \
  && rm /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/webapps/bonita.war \
  && rm -f /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip \
  && chown -R bonita:bonita /opt/bonita \
  && chmod -R +rX /opt/bonita \
  && chmod go+w /opt/bonita \
  && chmod 777 /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/logs \
  && chmod 777 /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/temp \
  && chmod 777 /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/work \
  && chmod -R go+w /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/conf \
  && chmod -R go+w /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/bin \
  && chmod -R go+w /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/lib/bonita \
  && chmod -R go+w /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/webapps/bonita/WEB-INF/web.xml \
  && chmod -R go+w /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/setup
  # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)




# create Volume to store Bonita files
VOLUME /opt/bonita

COPY templates /opt/templates
# expose Tomcat port
EXPOSE 8080

# command to run when the container starts
ENTRYPOINT ["/opt/files/startup.sh"]
