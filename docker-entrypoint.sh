#!/usr/bin/env bash

if [ -z "$BUCKET" ]; then
    echo "BUCKET environment variable not set, launch with -e BUCKET=my-bucket-name"
    exit 1
fi

if [ -z "$PROJECT_ID" ]; then
    echo "PROJECT_ID environment variable not set, launch with -e PROJECT_ID=my-project-name"
    exit 1
fi

THIS_MONTHS_LOGS=appengine.googleapis.com/request_log/`date +"%Y"`/`date +"%m"`

SRC=gs://$BUCKET/$THIS_MONTHS_LOGS
DST=/mnt/logfiles_incoming/$THIS_MONTHS_LOGS

echo Syncing Logs of $PROJECT_ID `date +"%Y"`.`date +"%m"`
echo Project:
echo Src: $SRC
echo Dst: $DST

sed -i s/PROJECT_ID/$PROJECT_ID/ ~/.boto

./gsutil -m rsync -r $SRC $DST

 #gsutil will return non zero code when there is nothing to sync -> please check errors for logs
true