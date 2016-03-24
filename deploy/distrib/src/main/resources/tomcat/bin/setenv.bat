@echo on

rem Set some JVM system properties required by Bonita BPM

rem Bonita home folder (configuration files, temporary folder...) location
set BONITA_HOME="-Dbonita.home=%CATALINA_HOME%\bonita"
set PLATFORM_SETUP="-Dorg.bonitasoft.platform.setup.folder=%CATALINA_HOME%\platform-setup"

rem Define the RDMBS vendor use by Bonita Engine to store data
set DB_OPTS="-Dsysprop.bonita.db.vendor=h2"

rem Define the RDMBS vendor use by Bonita Engine to store Business Data
rem If you use different DB engines by tenants, please update directly bonita-tenant-community-custom.properties
set BDM_DB_OPTS="-Dsysprop.bonita.bdm.db.vendor=h2"

rem Bitronix (JTA service added to Tomcat and required by Bonita Engine for transaction management)
set BTM_OPTS="-Dbtm.root=%CATALINA_HOME%" "-Dbitronix.tm.configuration=%CATALINA_HOME%\conf\bitronix-config.properties"

rem Optionnal JAAS configuration. Usually used when delgating authentication to LDAP / Active Directory server
rem set SECURITY_OPTS="-Djava.security.auth.login.config=%CATALINA_HOME%\conf\jaas-standard.cfg"

rem Pass the JVM system properties to Tomcat JVM using CATALINA_OPTS variable
set CATALINA_OPTS=%CATALINA_OPTS% %BONITA_HOME% %PLATFORM_SETUP% %DB_OPTS% %BDM_DB_OPTS% %BTM_OPTS% -Dfile.encoding=UTF-8 -Xshare:auto -Xms1024m -Xmx1024m -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError

set CATALINA_PID=%CATALINA_BASE%\catalina.pid
