#!/usr/bin/env bash
export LOCAL_MAVEN_REPO=${LOCAL_MAVEN_REPO:-"/opt/apache/repository"}
export PROJECT_VERSION=6.0-Beta-SNAPSHOT

echo "Will build ${PROJECT_VERSION} using this local repository : ${LOCAL_MAVEN_REPO}"

mvn clean install
cd deploy/builder
mvn clean 
mvn package -Dmaven.test.skip=true -Dmaven.repo.local=./target/repository -Dlocal.repo.path=${LOCAL_MAVEN_REPO} 
mvn install:install-file -Dfile=target/BOS-SP-${PROJECT_VERSION}-deploy.zip -Dpackaging=zip -DpomFile=pom.xml

cd ../../bundle
mvn clean install

