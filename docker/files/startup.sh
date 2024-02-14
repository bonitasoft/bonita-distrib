#!/usr/bin/env bash
# Shebang needs to be `bash`, see https://github.com/adoptium/containers/issues/415 for details

set -eo pipefail

# Duplication from eclipse-temurin parent image entrypoint script
# Opt-in is only activated if the environment variable is set
if [ -n "$USE_SYSTEM_CA_CERTS" ] && [ "$(id -u)" = '0' ]; then

    # Copy certificates from /certificates to the system truststore, but only if the directory exists and is not empty.
    # The reason why this is not part of the opt-in is because it leaves open the option to mount certificates at the
    # system location, for whatever reason.
    if [ -d /certificates ] && [ "$(ls -A /certificates)" ]; then
        cp -a /certificates/* /usr/local/share/ca-certificates/
    fi

    CACERT=$JAVA_HOME/lib/security/cacerts

    # OpenJDK images used to create a hook for `update-ca-certificates`. Since we are using an entrypoint anyway, we
    # might as well just generate the truststore and skip the hooks.
    update-ca-certificates

    trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$CACERT"
fi


# only execute bonita specific customization when the executable is tomcat
# it allows to not run this script when CMD is overridden
if [[ "$1" == "/opt/bonita/server/bin/catalina.sh" ]]
  then
  # if we are root user, we restrict access to files to the user 'bonita'
  if [ "$(id -u)" = '0' ]; then
    chmod -R go-rwx /opt/bonita/
    chown -R bonita:bonita /opt/bonita/conf/logs/
    chown -R bonita:bonita /opt/custom-init.d/
    chown -R bonita:bonita /opt/files
    exec su-exec bonita "$BASH_SOURCE" "$@"
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
