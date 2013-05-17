#!/bin/bash

deploy_dir="/tmp/BOS-6.0.0-beta-016-SNAPSHOT-Tomcat-6.0.35"
rm -fr ${deploy_dir}
unzip -d /tmp $(dirname $0)/bundle/tomcat/target/BOS-6.0.0-beta-016-SNAPSHOT-Tomcat-6.0.35.zip

cp /home/lvaills/Bonita/mysql-connector-java-5.1.24/mysql-connector-java-5.1.24-bin.jar ${deploy_dir}/lib/

sed -i 's/username="bonita"/username="root"/;s/password="bpm"/password="root"/' /tmp/BOS-6.0.0-beta-016-SNAPSHOT-Tomcat-6.0.35/conf/Catalina/localhost/bonita.xml


