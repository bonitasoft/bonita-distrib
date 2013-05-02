
Bonita deploy version XXX_VERSION_XXX

Contents of this package:

|-- Tomcat-<tomcat.version>                 Content necessary in order to deploy on a tomcat servlet container
|   |-- bin
|   |   |-- setenv.sh                       Script setting system variables for linux
|   |   `-- setenv.bat                      Script setting system variable for windows
|   |-- conf
|   |   |-- server.xml                      Default tomcat conf file including valve configuration
|   |   |-- context.xml                     datasources configuration
|   |   `-- logging.properties              logs configuration
|   |-- lib
|   |   `-- *.jar                           Common libs that can be shared by several webapps (JDBC driver, valve preventing session fixation issue)
|   `-- webapps
|       `-- bonita.war                      Webapp containing the portal, the engine and the REST API
|
|-- Jboss-<jboss.version>                   Content necessary in order to deploy on a JBoss AS
|   |-- bin
|   |   |-- run.conf                        Script setting JVM options for linux
|   |   `-- run.conf.bat                    Script setting JVM options for windows
|   |
|   `-- server
|       `--default
|          |-- lib
|          |   `-- *.jar                    Common libs that can be shared by several webapps (JDBC driver, valve preventing session fixation issue)
|          `-- deploy
|               |-- bonita.ear              EAR containing the portal, the engine and the REST API
|               |-- jbossweb.sar
|               |   `-- server.xml          Default Jboss conf file including valve configuration
|               |-- properties-service.xml  System variables configuration
|               `-- h2-ds.xml               Datasource configuration
|    
|-- bonita_home-<engine.version>            BONITA_HOME folder, contains all Bonita Open Solution configuration files
|   |-- client
|   `-- server
|-- license                                 License files
`-- README.txt                              You are here!

In order to install bonita you need to copy into the root folder of your application server:
- the content of the directory matching it
- create a directory named "bonita"
- copy the content of bonita_home-<engine.version> in it
- for Jboss update the file bonita/server/platform/conf/bonita-platform.xml to remove every occurrence of "java:comp/env/"
