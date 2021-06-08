#!/bin/sh

BASEDIR=$(cd $(dirname "$0") && pwd -P)

${BASEDIR}/server/bin/shutdown.sh
