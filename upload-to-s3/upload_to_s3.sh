#!/bin/bash

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
S3_BUCKET=$3
S3_REGION=$4
LONG_BUILD_VERSION=$5
WORKSPACE=$(printenv WORKSPACE)

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $S3_REGION

function send_status() {
	aws ses send-email --from someone@example.com --to someone@example.com --subject "Some Subject" --text "$1"
}

send_status "Build started"

aws s3 sync $WORKSPACE s3://$S3_BUCKET/$BUILD_VERSION --exclude ".git/*" --exclude "jenkins@tmp/*" --exclude ".gitignore" 

if [ $? -eq 0 ]
then
    send_status "Build (BUILD_VERSION) upload finished successfully"
else
    send_status "Build failed.See Jenkins logs for more details"
fi
