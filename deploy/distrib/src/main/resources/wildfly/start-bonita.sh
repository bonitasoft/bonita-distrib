#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    echo "ERROR ${COD_RET} $2"
    exit ${COD_RET}
  fi
}

if [ -d "./setup" ]; then

    ./setup/setup.sh init $@
    testReturnCode $? "Setting up Bonita BPM platform Community edition"

    ./setup/setup.sh configure $@
    testReturnCode $? "Configuring WildFly bundle"

fi

./server/bin/standalone.sh
