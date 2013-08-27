#!/bin/bash

echo "Downloading environment"

CONFIGFILE=".config"
ENVFILE=".env"

#Check if we have a call parm (should be a url for the env)
if [ "$1" != "" ]
then
	URL=$1
else
	URL=`cat $CONFIGFILE`
fi

wget --output-document $ENVFILE $URL
source $ENVFILE
export OS_USERNAME
export OS_TENANT_NAME
export OS_PASSWORD
export OS_AUTH_URL

