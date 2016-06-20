#!/bin/sh

testReturnCode() {
  COD_RET=$1
  if [ ${COD_RET} -ne 0 ]; then
    echo "ERROR ${COD_RET} $2"
    exit ${COD_RET}
  fi
}

./bin/startup.sh
