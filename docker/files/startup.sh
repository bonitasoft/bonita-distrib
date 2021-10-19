#!/bin/bash
set -eo pipefail
# if we are root user, we restrict access to files to the user 'bonita'
if [ "$(id -u)" = '0' ]; then
	chmod -R go-rwx /opt/bonita/
  chown -R bonita:bonita /opt/custom-init.d/
	chown -R bonita:bonita /bonita/run
	chown -R bonita:bonita /opt/files
	exec gosu bonita "$BASH_SOURCE" "$@"
fi

if [[ ! -f /bonita/run/log4j2-appenders.xml ]]
then
	mv /opt/files/log4j2/log4j2*.xml /bonita/run/
	mv /opt/bonita/server/conf/log4j2-loggers.xml /bonita/run/
	chmod 666 /bonita/run/log4j2*.xml
fi

# ensure to apply the proper configuration
if [ ! -f /opt/bonita/${BONITA_VERSION}-configured ]
then
	/opt/files/config.sh \
      && touch /opt/bonita/${BONITA_VERSION}-configured || exit 1
fi
if [ -d /opt/custom-init.d/ ]
then
  echo "Custom scripts:"
  find /opt/custom-init.d -name '*.sh' | sort
	for f in $(find /opt/custom-init.d -name '*.sh' | sort)
	do
		[ -f "$f" ] && echo "Executing custom script $f" && . "$f"
	done
fi
# launch tomcat

exec /opt/bonita/server/bin/catalina.sh run
