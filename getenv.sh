#!/bin/bash

echo "Downloading environment"

CONFIGFILE=".config"
ENVFILE=".env"

#Check if we have a call parm (should be a .config)
if [ "$1" != "" ]
then
	CONFIGFILE=$1
fi

url=`cat $CONFIGFILE`
wget --output-document $ENVFILE $url
source $ENVFILE

