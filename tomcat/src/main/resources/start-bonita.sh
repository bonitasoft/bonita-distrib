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
        echo "JAVA_HOME is not set. Use java in path."
        JAVA_CMD="java"
    fi
fi
echo "Java command path is $JAVA_CMD"
export JAVA_CMD

echo "Check that Java version is compatible with Bonita"
java_version=$("$JAVA_CMD" -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)
echo "Java version: $java_version"
if [ "x$java_version" = "x" ]; then
  echo "No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK, or add 'java' to your PATH"
  exit 12
fi

if [ "$java_version" != "8" -a "$java_version" != "11" ]; then
  echo "Invalid Java version $java_version not 8 or 11. Please set JRE_HOME or JAVA_HOME system variable to a JRE / JDK related to one of these versions, or add the valid 'java' version to your PATH"
  exit 18
fi
echo "Java version is compatible"

if [ -d "./setup" ]; then
  echo "------------------------------------------------------"
  echo "Initializing and configuring Bonita Tomcat bundle"
  echo "------------------------------------------------------"

  ./setup/setup.sh init $@
  testReturnCode $?

  ./setup/setup.sh configure $@
  testReturnCode $?

fi

echo "------------------------------------------------------"
echo "Starting Bonita Tomcat bundle"
echo "------------------------------------------------------"
./server/bin/startup.sh
