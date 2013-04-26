#!/bin/sh

# Sets some variables
BONITA_HOME="-Dbonita.home=${CATALINA_HOME}/bonita"
DB_OPTS="-Dsysprop.bonita.db.vendor=h2"
#SECURITY_OPTS="-Djava.security.auth.login.config=$CATALINA_HOME/bonita/client/platform/conf/jaas-standard.cfg"


CATALINA_OPTS="${CATALINA_OPTS} ${BONITA_HOME} ${DB_OPTS} -Dfile.encoding=UTF-8 -Xshare:auto -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError"
export CATALINA_OPTS

CATALINA_PID=${CATALINA_BASE}/catalina.pid
export CATALINA_PID
