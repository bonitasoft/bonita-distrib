#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    exit ${COD_RET}
  fi
}

if [ -d "./setup" ]; then

    ./setup/setup.sh init $@
    testReturnCode $?

    ./setup/setup.sh configure $@
    testReturnCode $?

fi

./server/bin/startup.sh
