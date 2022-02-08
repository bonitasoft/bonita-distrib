#!/bin/sh

# Set some JVM system properties required by Bonita

LOGGING_MANAGER="-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"
LOG_CONF_FILE_PATH="-Dlog4j.configurationFile=${BONITA_SERVER_LOGGING_FILE:-/opt/bonita/conf/logs/log4j2-appenders.xml,/opt/bonita/conf/logs/log4j2-loggers.xml}"

PLATFORM_SETUP="-Dorg.bonitasoft.platform.setup.folder=${CATALINA_HOME}/../setup"
H2_DATABASE_DIR="-Dorg.bonitasoft.h2.database.dir=${CATALINA_HOME}/../h2_database"
INCIDENT_LOG_DIR="-Dorg.bonitasoft.engine.incident.folder=${CATALINA_HOME}/logs"

# Define the RDMBS vendor use by Bonita Engine to store data. Valid values are: h2, postgres, sqlserver, oracle, mysql.
DB_OPTS="-Dsysprop.bonita.db.vendor=h2"

# Define the RDMBS vendor use by Bonita Engine to store Business Data. Valid values are: h2, postgres, sqlserver, oracle, mysql.
# If you use different DB engines by tenants, please update directly bonita-tenant-community-custom.properties
BDM_DB_OPTS="-Dsysprop.bonita.bdm.db.vendor=h2"

# Arjuna (JTA service added to Tomcat and required by Bonita Engine for transaction management)
ARJUNA_OPTS="-Dcom.arjuna.ats.arjuna.common.propertiesFile=${CATALINA_HOME}/conf/jbossts-properties.xml"

TRANSACTION_XATIMEOUT_OPTS="-Dbonita.runtime.transaction.xa-timeout={{TRANSACTION_XATIMEOUT_OPTS}}"

# Optional JAAS configuration. Usually used when delegating authentication to LDAP / Active Directory server
#SECURITY_OPTS="-Djava.security.auth.login.config=${CATALINA_HOME}/conf/jaas-standard.cfg"

# Optional JMX remote access Configuration. Used to enable remote JMX agent in tomcat to monitor Heap Memory, Threads, CPU Usage, Classes, and configure various MBeans.
if [ "$JMX_REMOTE_ACCESS" = 'true' ]; then
        host=$(echo $(hostname -i) | xargs)
        JMX_REMOTE_ACCESS_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=${host} -Dcom.sun.management.jmxremote.port=9000 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.password.file=${CATALINA_HOME}/conf/jmxremote.password -Dcom.sun.management.jmxremote.access.file=${CATALINA_HOME}/conf/jmxremote.access"
fi

# Pass the JVM system properties to Tomcat JVM using CATALINA_OPTS variable
CATALINA_OPTS="${CATALINA_OPTS} ${LOG_CONF_FILE_PATH} ${PLATFORM_SETUP} ${TRANSACTION_XATIMEOUT_OPTS} ${H2_DATABASE_DIR} ${DB_OPTS} ${BDM_DB_OPTS} ${ARJUNA_OPTS} ${INCIDENT_LOG_DIR} ${JMX_REMOTE_ACCESS_OPTS} -Dfile.encoding=UTF-8 -Xshare:auto -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${CATALINA_HOME}/logs -Djava.security.egd=file:/dev/./urandom -Dlog4j2.formatMsgNoLookups=true"
export CATALINA_OPTS

# Only set CATALINA_PID if not already set (check for empty value) by startup script (usually done by /etc/init.d/tomcat8 but not by startup.sh nor catalina.sh)
if [ -z ${CATALINA_PID+x} ]; then
        CATALINA_PID=${CATALINA_BASE}/catalina.pid;
        export CATALINA_PID;
fi

# extra lib required at Tomcat startup
export CLASSPATH="${CATALINA_HOME}/lib/ext/*"
