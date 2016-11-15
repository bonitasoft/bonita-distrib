#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    exit ${COD_RET}
  fi
}

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
