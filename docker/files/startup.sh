#!/bin/bash

# if we are root user, we restrict access to files to the user 'bonita'
if [ "$(id -u)" = '0' ]; then
	chmod -R go-rwx /opt/bonita/
  chown -R bonita:bonita /opt/custom-init.d/
	exec gosu bonita "$BASH_SOURCE" "$@"
fi

# ensure to apply the proper configuration
if [ ! -f /opt/bonita/${BONITA_VERSION}-configured ]
then
	/opt/files/config.sh \
      && touch /opt/bonita/${BONITA_VERSION}-configured || exit 1
fi
if [ -d /opt/custom-init.d/ ]
then
	for f in $(ls -v /opt/custom-init.d/*.sh)
	do
		[ -f "$f" ] && . "$f"
	done
fi
# launch tomcat
export LOGGING_CONFIG="-Djava.util.logging.config.file=${BONITA_SERVER_LOGGING_FILE:-/opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/conf/logging.properties}"
exec /opt/bonita/BonitaCommunity-${BRANDING_VERSION}/server/bin/catalina.sh run
