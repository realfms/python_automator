#!/bin/bash

echo "Extracting images:"
STACK_NAME=$1

function checkisshutdown
{
	STATUS=$(nova list | grep $1 | cut -d '|' -f 6 | tr -d ' ')
	
	if [ "$STATUS" = "Shutdown" ]
	then
		return 1
	fi
	return 0
}

. getenv.sh "" >/dev/null 2>&1

INSTANCE_LIST=$(heat resource-list $STACK_NAME | grep Instance | cut -d '|' -f 2 | tr -d ' ')
IMAGE_LIST=""

for INSTANCE in $INSTANCE_LIST
do
	echo "Found instance:$INSTANCE"

	#Get instance ID
	INSTANCE_ID=$(heat resource-show $STACK_NAME $INSTANCE | grep physical_resource_id | cut -d '|' -f 3 | tr -d ' ')
	
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
	IMAGE_LIST="$IMAGE_LIST $NEW_IMAGE_PREFIX-$INSTANCE"
done

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

./deleteStack.sh $STACK_NAME
