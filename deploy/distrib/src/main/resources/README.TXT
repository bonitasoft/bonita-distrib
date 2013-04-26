
Bonita deploy version XXX_VERSION_XXX

Contents of this package:

|-- tomcat-<tomcat.version>					Content necessary in order to deploy on a tomcat bundle
|   |-- bin
|   |   |-- setenv.sh						Script setting system variables for linux
|   |   `-- setenv.bat						Script setting system variable for windows
|   |-- conf
|   |   |-- server.xml						default tomcat conf file including valve configuration
|   |   |-- context.xml						datasources configuration
|   |   `-- logging.properties				logs configuration
|   |-- lib
|   |   `-- *.jar							common libs that can be shared by several webapps (JDBC driver, valve preventing session fixation issue)
|   |-- webapps
|   |   `-- bonita.war                      Webapp containing the portal, the engine and the REST API
|	|
|-- bonita_home-<engine.version>			BONITA_HOME folder, contains all Bonita Open Solution configuration files
|   |-- client                                   
|   `-- server
|-- license                                 License files
`-- README.txt                              You are here!

In order to install bonita you need to copy into the root folder of your application server:
- the content of the directory matching it
- create a directory named "bonita"
- copy the content of bonita_home-<engine.version> in it
