FROM alpine:3.15

LABEL maintainer="Bonitasoft Runtime team <rd.engine@bonitasoft.com>"

# Execute instructions less likely to change first

# Install packages
RUN apk add --no-cache curl unzip bash su-exec jattach openjdk11-jre-headless

RUN mkdir /opt/custom-init.d/

# create user to launch Bonita as non-root
RUN addgroup -S -g 1000 bonita \
 && adduser -u 1000 -S  -G bonita -h /opt/bonita/ -s /sbin/nologin  bonita


# Install Bundle

## ARGS and ENV required to download and unzip the toncat bundle
# use --build-arg key=value in docker build command to override arguments
ARG BONITA_VERSION
ARG BRANDING_VERSION
ARG BONITA_SHA256
ARG BASE_URL
ARG BONITA_URL

ENV BONITA_VERSION ${BONITA_VERSION:-7.14.0}
ENV BRANDING_VERSION ${BRANDING_VERSION:-2022.1-u0}
ENV BONITA_SHA256  ${BONITA_SHA256:-a88b3f4368bd68dda4eccf4680a71b7e523678811b6b3bcd61cd85e67e9b9aeb}
ENV ZIP_FILE BonitaCommunity-${BRANDING_VERSION}.zip
ENV BASE_URL ${BASE_URL:-https://github.com/bonitasoft/bonita-platform-releases/releases/download}
ENV BONITA_URL ${BONITA_URL:-${BASE_URL}/${BRANDING_VERSION}/BonitaCommunity-${BRANDING_VERSION}.zip}

## Must copy files first because the bundle is either taken from url or from local /opt/files if present
RUN mkdir /opt/files
COPY files /opt/files

RUN if [ -f "/opt/files/BonitaCommunity-${BRANDING_VERSION}.zip" ]; then echo "File already present in /opt/files"; else curl -fsSL ${BONITA_URL} -o /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip \
  && echo "$BONITA_SHA256 */opt/files/$ZIP_FILE" | sha256sum -c - ; fi \
  && unzip -q /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip -d /opt/bonita/ \
  && mv /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/* /opt/bonita \
  && rmdir /opt/bonita/BonitaCommunity-${BRANDING_VERSION} \
  && unzip /opt/bonita/server/webapps/bonita.war -d /opt/bonita/server/webapps/bonita/ \
  && rm /opt/bonita/server/webapps/bonita.war \
  && rm -f /opt/files/BonitaCommunity-${BRANDING_VERSION}.zip \
  && mkdir -p /opt/bonita/conf/logs/ \
  && mkdir -p /opt/bonita/logs/ \
  && mv /opt/files/log4j2/log4j2-appenders.xml /opt/bonita/conf/logs/ \
  && mv /opt/bonita/server/conf/log4j2-loggers.xml /opt/bonita/conf/logs/ \
  && chown -R bonita:bonita /opt/bonita \
  && chmod go+w /opt/ \
  && chmod -R +rX /opt \
  && chmod go+w /opt/bonita \
  && chmod 777 /opt/bonita/server/logs \
  && chmod 777 /opt/bonita/logs/ \
  && chmod 777 /opt/bonita/server/temp \
  && chmod 777 /opt/bonita/server/work \
  && chmod -R go+w /opt/bonita/server/conf \
  && chmod -R go+w /opt/bonita/server/bin \
  && chmod -R go+w /opt/bonita/server/lib/bonita \
  && chmod -R go+w /opt/bonita/setup

# ENV only required at runtime
ENV HTTP_API false
ENV HTTP_API_USERNAME http-api
ENV HTTP_API_PASSWORD ""
ENV MONITORING_USERNAME monitoring
ENV MONITORING_PASSWORD mon1tor1ng_adm1n
ENV JMX_REMOTE_ACCESS false
ENV REMOTE_IP_VALVE_ENABLED false
# Allow to redirect access logs to stdout:
ENV ACCESSLOGS_STDOUT_ENABLED false
# Allow to redirect access logs to file:
ENV ACCESSLOGS_FILES_ENABLED false
# If access log files enabled, where to put the access log files:
ENV ACCESSLOGS_PATH /opt/bonita/logs
# access log files enabled, should we append new HOSTNAME directory to full path:
ENV ACCESSLOGS_PATH_APPEND_HOSTNAME false
# max days access log files are conserved:
ENV ACCESSLOGS_MAX_DAYS 30
# max Http threads Tomcat will use to serve HTTP/1.1 requests:
ENV HTTP_MAX_THREADS 20


COPY templates /opt/templates
# exposed ports (Tomcat, JMX)
EXPOSE 8080 9000

# command to run when the container starts
ENTRYPOINT ["/opt/files/startup.sh"]
CMD ["/opt/bonita/server/bin/catalina.sh","run"]

