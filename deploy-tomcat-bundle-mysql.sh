#!/bin/bash -v

release="BOS-6.0.0-beta-016-SNAPSHOT-Tomcat-6.0.35"
deploy_dir="/tmp/${release}"

${deploy_dir}/bin/shutdown.sh

rm -fr ${deploy_dir}
unzip -d /tmp $(dirname $0)/bundle/tomcat/target/${release}.zip
#sed -i 's/username="bonita"/username="root"/;s/password="bpm"/password="root"/' ${deploy_dir}/conf/Catalina/localhost/bonita.xml
#sed -i 's/user=bonita/user=root/;s/password=bpm/password=root/' ${deploy_dir}/conf/bitronix-resources.properties
#sed -i 's/h2/mysql/' ${deploy_dir}/bin/setenv.sh
#
#cp -v /home/lvaills/Bonita/mysql-connector-java-5.1.24/mysql-connector-java-5.1.24-bin.jar ${deploy_dir}/lib/
#
