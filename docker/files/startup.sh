#!/bin/bash
set -eo pipefail
# only execute bonita specific customization when the executable is tomcat
# it allows to not run this script when CMD is overridden
if [[ "$1" == "/opt/bonita/server/bin/catalina.sh" ]]
  then
  # if we are root user, we restrict access to files to the user 'bonita'
  if [ "$(id -u)" = '0' ]; then
    chmod -R go-rwx /opt/bonita/
    chown -R bonita:bonita /opt/custom-init.d/
    chown -R bonita:bonita /opt/files
    exec su-exec  bonita "$BASH_SOURCE" "$@"
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
fi
# launch tomcat

exec "$@"
