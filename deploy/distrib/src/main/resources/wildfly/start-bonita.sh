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
        JAVA_CMD="java"
    fi
fi

export JAVA_CMD

# Check Java version is 8+
java_version=$("$JAVA_CMD" -version 2>&1 | grep -i version | sed 's/.*version ".*\.\(.*\)\..*"/\1/; 1q')
echo "java_version: $java_version"
if [ "x$java_version" = "x" ]; then
  echo "No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK 1.8+"
  exit 12
else
  if [ "$java_version" -lt "8" ]; then
    echo "Invalid Java version (1.$java_version) < 1.8. Please set JAVA or JAVA_HOME variable to a JDK / JRE 1.8+"
    exit 18
  fi
fi

read unused

if [ -d "./setup" ]; then
  echo "------------------------------------------------------"
  echo "Initializing and configuring Bonita BPM WildFly bundle"
  echo "------------------------------------------------------"

  ./setup/setup.sh init $@
  testReturnCode $?

  ./setup/setup.sh configure $@
  testReturnCode $?

fi

echo "------------------------------------------------------"
echo "Starting Bonita BPM WildFly bundle"
echo "------------------------------------------------------"
./server/bin/standalone.sh
