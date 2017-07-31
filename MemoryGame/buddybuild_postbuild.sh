#!/bin/bash
brew install jq # easier handling of json data

# get project ARN from
# aws devicefarm list-projects
# get device pool from
# aws devicefarm list-device-pools --arn $PROJECT_ARN

# constants
projectARN = "arn:aws:devicefarm:us-west-2:763902315568:project:e80bdcdf-fe0e-4d6b-a02e-786ddd69238a"
IPA_NAME=MemoryGame.ipa
DEVICE_POOL_ARN = "arn:aws:devicefarm:us-west-2::devicepool:082d10e5-d7d7-48a5-ba5c-b33d66efa1f5"
echo $PROJECT_ARN
echo $DEVICE_POOL_ARN
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