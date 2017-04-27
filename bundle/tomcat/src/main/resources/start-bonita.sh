#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    exit ${COD_RET}
  fi
}

# Setup the JVM
if [ "x$JRE_HOME" != "x" ]; then
    JAVA_CMD="$JRE_HOME/bin/java"
else
    if [ "x$JAVA_HOME" != "x" ]; then
        JAVA_CMD="$JAVA_HOME/bin/java"
    else
        JAVA_CMD=java
    fi
fi
export JAVA_CMD

# Check Java version is 8+
java_version=$("$JAVA_CMD" -version 2>&1 | grep -i version | sed 's/.*version ".*\.\(.*\)\..*"/\1/; 1q')
if [ "x$java_version" = "x" ]; then
  echo "No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK 1.8+, or add 'java' to your PATH"
  exit 12
else
  if [ "$java_version" -lt "8" ]; then
    echo "Invalid Java version (1.$java_version) < 1.8. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK 1.8+, or add the valid 'java' version to your PATH"
    exit 18
  fi
fi

if [ -d "./setup" ]; then
  echo "-----------------------------------------------------"
  echo "Initializing and configuring Bonita BPM Tomcat bundle"
  echo "-----------------------------------------------------"

  ./setup/setup.sh init $@
  testReturnCode $?

  ./setup/setup.sh configure $@
  testReturnCode $?

fi

echo "-----------------------------------------------------"
echo "Starting Tomcat server..."
echo "-----------------------------------------------------"
./server/bin/startup.sh
