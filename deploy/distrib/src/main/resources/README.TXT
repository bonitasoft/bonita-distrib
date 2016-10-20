Bonita Community edition deploy version ${project.version}

Contents of this package:

|-- Tomcat-${tomcat.version}                 			Content necessary in order to deploy on a tomcat servlet container
|   `-- server
|   |   |-- bin
|   |   |   |-- setenv.sh                               Script setting system variables for linux
|   |   |   `-- setenv.bat                              Script setting system variable for windows
|   |   |-- conf
|   |   |   `-- Catalina
|   |   |   |   `-- localhost
|   |   |   |       `-- bonita.xml                      Datasources configuration
|   |   |   |-- bitronix-config.properties
|   |   |   |-- bitronix-resources.properties
|   |   |   |-- context.xml
|   |   |   |-- logging.properties                      Logs configuration
|   |   |   `-- server.xml                              Default tomcat conf file including valve configuration
|   |   |-- lib
|   |   |   `-- *.jar                                   Common libs that can be shared by several webapps (JDBC driver, valve preventing session fixation issue)
|   |   `-- webapps
|   |       |-- ROOT
|   |       | 	`-- favicon.ico
|   |       `-- bonita.war                              Webapp containing the portal, the engine and the REST API
|   `-- start-bonita(.sh|.bat)                          Script used to start Bonita BPM Tomcat bundle
|   `-- stop-bonita(.sh|.bat)                           Script used to stop Bonita BPM Tomcat bundle
|
|-- wildfly-${wildfly.version}                 	 	    Content necessary in order to deploy on a WildFly AS
|   `-- server
|   |   |-- bin
|   |   |   |-- standalone.conf                         Script setting JVM options for linux
|   |   |   `-- standalone.conf.bat                     Script setting JVM options for windows
|   |   |-- standalone
|   |   |   |-- configuration
|   |   |   |   `-- standalone.xml					    Datasource & logs configuration
|   |   |   `-- deployments
|   |   |       `-- bonita-all-in-one-*.ear             EAR containing the portal, the engine and the REST API
|   |   `-- modules
|   |       `-- system
|   |           `-- layers
|   |               `-- base
|   |                   `-- sun
|   |                       `-- jdk
|   |                           `-- main
|   |                               `-- module.xml      Describe the list of sdk packages use by WildFly extended with the ones required by Bonita
|   `-- start-bonita(.sh|.bat)                          Script used to start Bonita BPM WildFly bundle
|
|-- setup						                        Platform installation files (Database scripts + configuration files + bundle configurator)
|-- license                                 			License files
`-- README.txt                              			You are here!

In order to install bonita you need to copy into the root folder of your application server:
- the content of the directory matching it
- for WildFly update the files `platform-setup/platform_conf/initial/platform_engine/bonita-platform-community-custom.properties`
  and `setup/platform_conf/initial/tenant_template_engine/bonita-tenant-community-custom.properties`:
      - uncomment lines containing "java:comp/env/"
      - remove every occurrence of "java:comp/env/" (leave the rest of the value)
