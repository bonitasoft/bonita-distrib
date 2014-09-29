
Bonita deploy version XXX_VERSION_XXX

Contents of this package:

|-- Tomcat-<tomcat.version>                 			Content necessary in order to deploy on a tomcat servlet container
|   |-- bin
|   |   |-- setenv.sh                       			Script setting system variables for linux
|   |   `-- setenv.bat                      			Script setting system variable for windows
|   |-- conf
|   |   |-- Catalina
|   |   |   `-- localhost
|   |   |       `-- bonita.xml              			Datasources configuration
|   |   |-- bitronix-config.properties
|   |   |-- bitronix-resources.properties
|   |   |-- context.xml
|   |   |-- logging.properties              			Logs configuration
|   |   `-- server.xml                      			Default tomcat conf file including valve configuration
|   |-- lib
|   |   `-- *.jar                           			Common libs that can be shared by several webapps (JDBC driver, valve preventing session fixation issue)
|   `-- webapps
|   |   |-- ROOT
|       	`-- favicon.ico
|       `-- bonita.war                      			Webapp containing the portal, the engine and the REST API
|
|-- Jboss-<jboss.version>                  	 			Content necessary in order to deploy on a JBoss AS
|   |-- bin
|   |   |-- standalone.conf                        		Script setting JVM options for linux
|   |   `-- standalone.conf.bat                    		Script setting JVM options for windows
|   |-- modules
|   |   |-- com
|   |   |	`-- h2database
|   |   |		`-- h2
|   |   |			`-- main							JDBC driver & module conf for H2
|   |   |				|-- h2-*.jar	
|   |   |				`-- module.xml
|   |   `-- org
|   |   	`-- bonitasoft
|   |   		`-- bonita-tomcat-valve					Lib & module conf for the Valve preventing session fixation issue
|   |   			`-- main
|   |   				|-- bonita-tomcat-valve-*.jar	
|   |   				`-- module.xml
|   |-- standalone
|   |   |-- configuration
|   |   |	|-- standalone-full-ha.xml					Datasource & logs configuration
|   |   |	|-- standalone-full.xml						Datasource & logs configuration
|   |   |	|-- standalone-ha.xml						Datasource & logs configuration
|   |   |	`-- standalone.xml							Datasource & logs configuration
|   |   |-- deployments
|   |   |	|-- h2.sar
|   |   |	|	|-- META-INF
|   |   |	|	|	|-- jboss-deployment-structure.xml
|   |   |	|	|	`-- jboss-service.xml
|   |   |	|	`-- bonita-jboss-h2-mbean-*.jar
|   |   |	`-- bonita-all-in-one-*.ear              	EAR containing the portal, the engine and the REST API
|   |   `-- lib
|   |       `-- *.jar                    				Common libs that can be shared by several webapps (H2 listener)
|   `-- welcome-content
|       `-- favicon.ico
|    
|-- bonita_home-<engine.version>            			BONITA_HOME folder, contains all Bonita Open Solution configuration files
|   |-- client
|   `-- server
|-- license                                 			License files
`-- README.txt                              			You are here!

In order to install bonita you need to copy into the root folder of your application server:
- the content of the directory matching it
- create a directory named "bonita"
- copy the content of bonita_home-<engine.version> in it
- for Jboss update the file bonita/server/platform/conf/bonita-platform.xml to remove every occurrence of "java:comp/env/"
