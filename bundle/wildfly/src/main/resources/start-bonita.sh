#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    exit ${COD_RET}
  fi
}

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
        JAVA_CMD="$JAVA_HOME/bin/java"
    else
        echo "JAVA_HOME is not set. Use java in path."
        JAVA_CMD="java"
    fi
else
    JAVA_CMD=$JAVA
fi
echo "Java command path is $JAVA_CMD"
export JAVA_CMD

echo "Check that Java version is compatible with Bonita"
java_full_version=$("$JAVA_CMD" -version 2>&1 | grep -i version | sed 's/.*version "\(.*\)".*$/\1/g')
echo "Java full version: $java_full_version"
if [ "x$java_full_version" = "x" ]; then
  echo "No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK, or add 'java' to your PATH"
  exit 12
fi

java_version_1st_digit=$(echo "$java_full_version" | sed 's/\(.*\)\..*\..*$/\1/g')
# pre Java 9 versions, get minor version
if [ "$java_version_1st_digit" -eq "1" ]; then
  java_version=$(echo "$java_full_version" | sed 's/.*\.\(.*\)\..*$/\1/g')
  java_version_expected=8
else
  java_version=$java_version_1st_digit
  java_version_expected=11
fi
echo "Java version: $java_version"

if [ "$java_version" -ne "$java_version_expected" ]; then
  echo "Invalid Java version $java_version not 8 or 11. Please set JRE_HOME or JAVA_HOME system variable to a JRE / JDK related to one of these versions, or add the valid 'java' version to your PATH"
  exit 18
fi
echo "Java version is compatible"

if [ -d "./setup" ]; then
  echo "------------------------------------------------------"
  echo "Initializing and configuring Bonita WildFly bundle"
  echo "------------------------------------------------------"

  echo "------------------------------------------------------"
  echo "WARNING: Bonita WildFly bundle has been deprecated in Bonita 7.9."
  echo "We advise you to switch to the Tomcat bundle when migrating to Bonita 7.9."
  echo "The WildFly bundle was mainly used with the SQL Server database. The Tomcat bundle is now compatible with it, and is the recommended solution."
  echo "------------------------------------------------------"

  ./setup/setup.sh init $@
  testReturnCode $?

  ./setup/setup.sh configure $@
  testReturnCode $?

fi

echo "------------------------------------------------------"
echo "Starting Bonita WildFly bundle"
echo "------------------------------------------------------"
./server/bin/standalone.sh
