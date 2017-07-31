#!/bin/bash
brew install jq # easier handling of json data

# get project ARN from
# aws devicefarm list-projects
# get device pool from
# aws devicefarm list-device-pools --arn $PROJECT_ARN

# constants
echo $PROJECT_ARN
echo $DEVICE_POOL_ARN
echo $IPA_NAME
# create the upload request
#aws devicefarm create-upload –-project-arn $PROJECT_ARN -–name $APK_NAME -–type IOS_APP
echo "===== Upload IPA"
APP_UPLOAD="$(aws devicefarm create-upload --project-arn $PROJECT_ARN --name $IPA_NAME --type IOS_APP | jq '.upload')"
echo $APP_UPLOAD
UPLOAD_URL="$(echo $APP_UPLOAD  | jq '.url')"
UPLOAD_URL=${UPLOAD_URL//\"}

APP_ARN="$(echo $APP_UPLOAD | jq '.arn')"
APP_ARN=${APP_ARN//\"}

echo $IPA_NAME
echo $UPLOAD_URL

curl -T $BUDDYBUILD_IPA_PATH $UPLOAD_URL

sleep 30