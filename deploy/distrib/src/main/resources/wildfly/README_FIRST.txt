# Welcome to Bonita BPM Community edition WildFly bundle

## Installation: basic configuration + first start

### Install with connection to an external database
Pre-requisites
* Create your database
* If the database is proprietary, have its drivers handy. We embed PostgreSQL and MySQL drivers.

Installation
* Edit the file setup/database.properties: set the database values to point to your existing database
* If you use Microsoft SQL Server or Oracle database, copy your database drivers in setup/lib folder
* Run start-bonita.sh (Unix) or start-bonita.bat (Windows) to launch the Bonita BPM Community WildFly bundle

### Install with the embedded H2 database (for testing purposes)
H2 is not fit for production. Use this default setting for a quick setup of the bundle.
You will still be able to update the database configuration later on.
* Run start-bonita.sh (Unix) or start-bonita.bat (Windows) to launch the Bonita BPM Community WildFly bundle


## Database configuration change after first start
* Edit the file setup/database.properties: change the database values to suit your needs
* If you switch to Microsoft SQL Server or Oracle database, copy your database drivers in setup/lib folder
* Run start-bonita.sh (Unix) or start-bonita.bat (Windows) to launch the Bonita BPM Community WildFly bundle


## Advanced bundle configuration (can be done before or after first start)
You must not configure WildFly files directly anymore.
If you decide to do it anyway, your custom values will be overwritten by Bonita BPM startup.
If you need to finely tune the configuration, modify the following template file:
    setup/wildfly-templates/standalone.xml
They are used as a basis for WildFly configuration and will overwrite WildFly provided files.


## Bonita BPM internal configuration update
### Update other configuration items
* In setup/ folder, run `setup(.sh|.bat) pull` to retrieve your current configuration from database
* Edit any configuration file in `pulled` folder setup/platform_conf/current. Example of frequently customized files are:
setup/platform_conf/current/platform_engine/bonita-platform-community-custom.properties
setup/platform_conf/current/tenants/1/tenant_engine/bonita-tenant-community-custom.properties
* Run `setup(.sh|.bat) push` to push the new configuration to the database
* Restart the Bonita BPM Community WildFly bundle so the new configuration is taken into account


## FAQ

### When I run on H2, I get prompted to confirm that I want to use H2
=> Yes, H2 is not recommended for production, but only in development/testing phase. Confirm once, you will not be prompted any longer.
Alternatively, you can run `start-bonita(.sh|.bat) --allow-default` if you do not want to be prompted for confirmation.