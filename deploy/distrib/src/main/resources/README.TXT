Bonita Community edition deploy version ${project.version}

Contents of this package:

|-- Tomcat-${tomcat.version}                 			Content necessary in order to deploy on a tomcat servlet container
|   `-- server
|       |-- bin
|       |   |-- setenv.sh                               Script setting system variables for linux
|       |   `-- setenv.bat                              Script setting system variable for windows
|       |-- conf
|       |   `-- Catalina
|       |   |   `-- localhost
|       |   |       `-- bonita.xml                      Datasources configuration
|       |   |-- bitronix-config.properties
|       |   |-- bitronix-resources.properties
|       |   |-- context.xml
|       |   |-- logging.properties                      Logs configuration
|       |   `-- server.xml                              Default tomcat conf file
|       |-- lib
|       |   `-- *.jar                                   Common libs that can be shared by several webapps (JDBC driver, etc...)
|       `-- webapps
|           |-- ROOT
|           | 	`-- favicon.ico
|           `-- bonita.war                              Webapp containing the portal, the engine and the REST API
|
|-- wildfly-${wildfly.version}                 	 	    Content necessary in order to deploy on a WildFly AS
|   `-- server
|       |-- bin
|       |   |-- standalone.conf                         Script setting JVM options for linux
|       |   `-- standalone.conf.bat                     Script setting JVM options for windows
|       |-- standalone
|       |   |-- configuration
|       |   |   `-- standalone.xml					    Datasource & logs configuration
|       |   `-- deployments
|       |       `-- bonita-all-in-one-*.ear             EAR containing the portal, the engine and the REST API
|       `-- modules
|           `-- system
|               `-- layers
|                   `-- base
|                       `-- sun
|                           `-- jdk
|                               `-- main
|                                    `-- module.xml      Describe the list of sdk packages use by WildFly extended with the ones required by Bonita
|
|-- setup						                        Platform installation files (Database scripts + configuration files + bundle configurator)
|-- license                                 			License files
`-- README.txt                              			You are here!

In order to install Bonita BPM into your Application Server installation, you need:
- to rename your Application Server installation root folder with name `server`
- to copy into your Application Server installation the content of the folder named Tomcat-${tomcat.version} or wildfly-${wildfly.version}
