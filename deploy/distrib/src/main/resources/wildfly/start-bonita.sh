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
        JAVA="$JAVA_HOME/bin/java"
    else
        JAVA="java"
    fi
fi
# Check Java version is 8+
java_version=$("$JAVA" -version 2>&1 | grep -i version | sed 's/.*version ".*\.\(.*\)\..*"/\1/; 1q')
if [ "$java_version" -lt "8" ]; then
    echo "Wrong Java version ($java_version) < 8. Please set JAVA or JAVA_HOME variable to a JDK / JRE 8+"
    exit 18
fi

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
