#!/bin/bash

ENVFILE=".env"
source $ENVFILE
export OS_USERNAME
export OS_TENANT_NAME
export OS_PASSWORD
export OS_AUTH_URL

STACK_NAME=$1
heat stack-delete $STACK_NAME >/dev/null

#Wait for stack to finish deletion
echo "Waiting for stack to be deleted"
ELAPSED=0
while [[ $? -eq 0 ]]
do
	sleep 5
	let ELAPSED=$ELAPSED+5
	echo -ne "\r$ELAPSED seconds elapsed"
	heat stack-show $STACK_NAME | grep "stack_status " | grep DELETE_IN_PROGRESS > /dev/null
done

echo "."

#Check finish status
STATUS=$(heat stack-show $STACK_NAME | grep "stack_status " | cut -d '|' -f 3 | tr -d ' ')

if [ "$STATUS" == "DELETE_COMPLETE" -o "$STATUS" == "" ]
then
	echo "Stack deleted successfully"
	exit 0
fi

echo "ERROR DELETING STACK:$STATUS"
