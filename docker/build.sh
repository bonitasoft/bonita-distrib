#!/bin/bash

set -e

print_error() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  printf "${RED}ERROR - $1\n${NC}"
}

exit_with_usage() {
  SCRIPT_NAME=$(basename "$0")
  [ -n "$1" ] && print_error "$1" >&2
  echo ""
  echo "Usage: ./$SCRIPT_NAME [options] -- [--build-arg key=value]"
  echo ""
  echo "Options:"
  echo "  -a docker_build_args_file  file to read docker build arguments from"
  echo "  -c                         use Docker cache while building image - by default build is performed with '--no-cache=true'"
  echo ""
  echo "Examples:"
  echo "  $> ./$SCRIPT_NAME --"
  echo "  $> ./$SCRIPT_NAME -a build_args -c -- --build-arg key1=value1 --build-arg key2=value2"
  echo ""
  exit 1
}

# parse command line arguments
no_cache="true"
while [ "$#" -gt 0 ]; do
  # process next argument
  case $1 in
  -a)
    shift
    BUILD_ARGS_FILE=$1
    if [ -z "$BUILD_ARGS_FILE" ]; then
      exit_with_usage "Option -a requires an argument."
    fi
    if [ ! -f "$BUILD_ARGS_FILE" ]; then
      exit_with_usage "Build args file not found: $BUILD_ARGS_FILE"
    fi
    ;;
  -c)
    no_cache="false"
    ;;
  --)
    break
    ;;
  *)
    exit_with_usage "Unrecognized option: $1"
    ;;
  esac
  if [ "$#" -gt 0 ]; then
    shift
  fi
done

shift
BUILD_ARGS="--no-cache=${no_cache}"

# validate Dockerfile
if [ ! -f "Dockerfile" ]; then
  exit_with_usage "File not found: Dockerfile"
fi

# append build args found in docker_build_args_file
if [ -n "$BUILD_ARGS_FILE" ] && [ ! -f "$BUILD_ARGS_FILE" ]; then
  exit_with_usage "Build args file not found: $BUILD_ARGS_FILE"
fi
if [ -n "$BUILD_ARGS_FILE" ] && [ -f "$BUILD_ARGS_FILE" ]; then
  BUILD_ARGS="$BUILD_ARGS $(echo $(cat $BUILD_ARGS_FILE | sed 's/^/--build-arg /g'))"
fi

# append build args found on command line
BUILD_ARGS="$BUILD_ARGS $*"

# Remove any pre-existing zip file:
rm -f ./files/BonitaCommunity-*.zip
cp ../tomcat/target/BonitaCommunity-*.zip files/
BONITA_VERSION=$(head -10 ../pom.xml | grep "<version>" | sed -e 's/.*<version>//g' -e 's/<\/version>.*//g')
if [[ "$BONITA_VERSION" == *"-SNAPSHOT"* ]]; then
  echo "SNAPSHOT version detected: sending sha256 and BONITA_URL as extra parameters"
  BONITA_SHA256=$(sha256sum ./files/BonitaCommunity-*.zip | cut -d' ' -f1)
  BUILD_ARGS="${BUILD_ARGS} --build-arg BONITA_VERSION=${BONITA_VERSION}"
  BUILD_ARGS="${BUILD_ARGS} --build-arg BONITA_SHA256=${BONITA_SHA256}"
fi

IMAGE_NAME=bonitasoft/bonita
echo ". Building image <${IMAGE_NAME}:${BONITA_VERSION}>"

build_cmd="docker build ${BUILD_ARGS} -t ${IMAGE_NAME}:${BONITA_VERSION} ."
echo "Running command: '$build_cmd'"
eval "$build_cmd"

echo ". Done!"
