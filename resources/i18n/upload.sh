#!/bin/sh

usage() {
    echo "***********************************************************************************"
    echo "Usage:     $0 --crowdin-api-key=<key> [--branch-name=<branch>] [--crowdin-project=<crowdin project>]"
    echo ""
    echo "  --crowdin-api-key the crowdin api key of crowdin project"
    echo "  --crowdin-project crowdin project (default: bonita-bpm)"
    echo "  --branch-name branch name to upload to crowdin (default to master)"
    echo "***********************************************************************************"
    exit 1;
}

npm_pot() {
    npm install && npm run pot
    check_errors $? "Error while generating pot files"
}

# $1 previous command exit code
# $2 error message
check_errors() {
  if [ $1 -ne 0 ]
  then
    echo $2
    exit $1
  fi
}

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
BUILD_DIR=$SCRIPT_DIR
BASE_DIR=$SCRIPT_DIR

PROJECT="bonita-bpm"
BRANCH_NAME=master
for i in "$@"; do
    case $i in
        --crowdin-api-key=*)
        CROWDINKEY="${i#*=}"
        shift
        ;;
        --branch-name=*)
        BRANCH_NAME="${i#*=}"
        shift
        ;;
        --crowdin-project=*)
        PROJECT="${i#*=}"
        shift
        ;;
    esac
done
if [ -z "$CROWDINKEY" ]; then
  echo "ERROR crowdin API key is needed";
  usage;
fi

echo "***********************************************************************************"
echo "web distrib TRANSLATION UPLOAD"
echo "***********************************************************************************"
cd $BASE_DIR

echo "Building pot files..."
npm_pot

echo "Exporting community pot to $PROJECT crowdin project ..."
curl -F "files[$BRANCH_NAME/bonita-web/distrib/resources.pot]=@$BUILD_DIR/resources.pot"  \
     -F "export_patterns[$BRANCH_NAME/bonita-web/distrib/resources.pot]=/$BRANCH_NAME/bonita-web/distrib/resources_%locale_with_underscore%.po" \
   https://api.crowdin.com/api/project/$PROJECT/update-file?key=$CROWDINKEY
if [ $? -ne 0 ]
then
  echo "Error while updating pot file: $?"
  curl -F "files[$BRANCH_NAME/bonita-web/distrib/resources.pot]=@$BUILD_DIR/resources.pot"  \
       -F "export_patterns[$BRANCH_NAME/bonita-web/distrib/resources.pot]=/$BRANCH_NAME/bonita-web/distrib/resources_%locale_with_underscore%.po" \
     https://api.crowdin.com/api/project/$PROJECT/add-file?key=$CROWDINKEY
     if [ $? -ne 0 ]
     then
       echo "Error while adding pot file: $?"
       exit $?
     fi
fi
