@echo off
set LOCAL_MAVEN_REPO=C:\.m2\repository
set PROJECT_VERSION=6.0-Beta-SNAPSHOT

mvn clean install 
cd deploy/builder
mvn clean 
mvn install  deploy -Dmaven.test.skip=true -Dmaven.repo.local=./target/repository -Dlocal.repo.path=%LOCAL_MAVEN_REPO%
mvn install:install-file  -Dfile=target/BOS-%PROJECT_VERSION%-deploy.zip -Dpackaging=zip -DpomFile=pom.xml
cd ../../bundle
mvn clean install 
