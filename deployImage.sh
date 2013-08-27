#!/bin/bash

INSTALL_TEMPLATE=deploy.cf
ENVFILE=$(grep -A 5 EnvURL $INSTALL_TEMPLATE | grep Default | head -1 | cut -d ':' -f 2- | cut -d '"' -f 2)
TIMEOUT=600

. getenv.sh > /dev/null 2>&1

STACK_NAME="$INSTALL_TEMPLATE$$"
heat stack-create -c $TIMEOUT -r -f $INSTALL_TEMPLATE $STACK_NAME >/dev/null

#Wait for stack to finish
echo "Waiting for stack to complete"
ELAPSED=0
while [[ $? -eq 0 ]]
do
	sleep 5
	let ELAPSED=$ELAPSED+5
	echo -ne "\r$ELAPSED seconds elapsed"
	heat stack-show $STACK_NAME | grep "stack_status " | grep CREATE_IN_PROGRESS > /dev/null
done

echo "."

#Check finish status
STATUS=$(heat stack-show $STACK_NAME | grep "stack_status " | cut -d '|' -f 3 | tr -d ' ')

if [ "$STATUS" == "CREATE_COMPLETE" ]
then
	echo "Project images configured OK"
	read -p "Do you want to generate the images (Y/n):" -n 1 -r
	echo 
	if [[ $REPLY =~ ^[Nn]$ ]]
	then
		echo "You selected not to generate images."
		echo "Do it later with snapImages.sh $STACK_NAME"
		exit 1
	fi
	./snapImages.sh $STACK_NAME
	exit 0
fi

echo "ERROR:$STATUS"
