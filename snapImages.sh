#!/bin/bash

echo "Extracting images:"

function checkisshutdown
{
	STATUS=$(nova list | grep $1 | cut -d '|' -f 6 | tr -d ' ')
	
	if [ "$STATUS" = "Shutdown" ]
	then
		return 1
	fi
	return 0
}

function imageInstance
{
	INSTANCE_ID=$1
	INSTANCE=$2

	#Check and turning off instance
	checkisshutdown $INSTANCE_ID
	if [ $? -eq 0 ]
	then
		#Sleep and check again
		sleep 10
		checkisshutdown $INSTANCE_ID
		if [ $? -eq 0 ]
		then
			echo "Image was still running. Snapshot could be inconsistent"
		fi
	fi

	#Snapshot instance
	echo "Saving current instance image with name:$NEW_IMAGE_PREFIX-$INSTANCE"
	nova image-create --poll $INSTANCE_ID $NEW_IMAGE_PREFIX-$INSTANCE
	IMAGE_LIST="$IMAGE_LIST $NEW_IMAGE_PREFIX-$RESOURCE"
}

function saveStackImages
{
	local STACK_NAME

	STACK_NAME=$1
	INSTANCE_LIST=$(heat resource-list $STACK_NAME | grep -e Instance -e "AWS::CloudFormation::Stack" | cut -d '|' -f 2 | tr -d ' ')

	for RESOURCE in $INSTANCE_LIST
	do

		#Get resource type
		RES_TYPE=$(heat resource-show $STACK_NAME $RESOURCE | grep resource_type | cut -d '|' -f 3 | tr -d ' ')
		if [ "$RES_TYPE" == "AWS::CloudFormation::Stack" ]
		then
			echo "Found stack:$RESOURCE"
			STACK_ID=$(heat resource-show $STACK_NAME $RESOURCE | grep physical_resource_id | cut -d '|' -f 3 | tr -d ' ')
			saveStackImages $STACK_ID
		else
			echo "Found server:$RESOURCE"
			INSTANCE_ID=$(heat resource-show $STACK_NAME $RESOURCE | grep physical_resource_id | cut -d '|' -f 3 | tr -d ' ')
			imageInstance $INSTANCE_ID $RESOURCE
		fi
	done
}

ENVFILE=".env"
source $ENVFILE
export OS_USERNAME
export OS_TENANT_NAME
export OS_PASSWORD
export OS_AUTH_URL

IMAGE_LIST=""

saveStackImages $1

echo "All images are completed"
read -p "Do you want to download new images (Y/n):" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
        echo "Downloading images"
	for IMAGE in $IMAGE_LIST
	do
		echo "$IMAGE:"
		glance image-download --file /mnt/img/$IMAGE.img --progress $IMAGE
	done
fi

read -p "Do you want to delete the installation stack (Y/n):" -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
	echo "You selected not to delete installation stack."
        echo "Do it later with deleteStack.sh $STACK_NAME"
        exit 1
fi

./deleteStack.sh $1
