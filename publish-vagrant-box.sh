#!/bin/bash

BOX_FILE_NAME=`node get-box-filename.js`
BUCKET_NAME="spantree-vagrant"

echo  "Removing old box file"
rm $BOX_FILE_NAME

echo "Building Vagrant box file"
packer build -only=virtualbox_iso Packerfile

echo "Uploading box to S3"
s3cmd put --acl-public $BOX_FILE_NAME "s3://${BUCKET_NAME}/${BOX_FILE_NAME}"