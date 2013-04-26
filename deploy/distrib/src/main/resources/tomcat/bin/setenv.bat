@echo on

rem Sets some variables
set BONITA_HOME="-Dbonita.home=%CATALINA_HOME%\bonita"
set DB_OPTS="-Dsysprop.bonita.db.vendor=h2"
rem set SECURITY_OPTS="-Djava.security.auth.login.config=%CATALINA_HOME%\bonita\client\platform\conf\jaas-standard.cfg"

set CATALINA_OPTS=%CATALINA_OPTS% %BONITA_HOME% %DB_OPTS% -Dfile.encoding=UTF-8 -Xshare:auto -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError

set CATALINA_PID=%CATALINA_BASE%\catalina.pid
