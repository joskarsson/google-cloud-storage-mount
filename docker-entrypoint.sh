#!/bin/sh

if [ -z "$BUCKET" ]; then
    echo "BUCKET environment variable not set, launch with -e BUCKET=my-bucket-name"
    exit 1
fi

if [ -z "$PROJECT_ID" ]; then
    echo "PROJECT_ID environment variable not set, launch with -e PROJECT_ID=my-project-name"
    exit 1
fi

KEY_FILE=/etc/gcsfuse/gs_service_key_file.json

if [ ! -f $KEY_FILE ]; then
   echo $KEY_FILE does not exist please launch with -v /path-to-key-file/key-file.json:$KEY_FILE
   exit 1
fi

if [ -z "$MONTH" ]; then
    MONTH=`date +"%m"`
fi

YEAR=`date +"%Y"`
THIS_MONTHS_LOGS=appengine.googleapis.com/request_log/$YEAR/$MONTH

SRC=gs://$BUCKET/$THIS_MONTHS_LOGS
DST=/mnt/logfiles_incoming/$THIS_MONTHS_LOGS

echo Syncing Logs of $PROJECT_ID $YEAR.$MONTH
echo $SRC : $DST

mkdir -p $DST
gsutil -m rsync -r -p $PROJECT_ID $SRC $DST

#gsutil will return non zero code when there is nothing to sync -> please check errors for logs
exit 0