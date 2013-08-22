#!/bin/bash

. getenv.sh
nova --os-auth-url $OS_AUTH_URL --os-tenant-name $OS_TENANT_NAME --os-username $OS_USERNAME --os-password $OS_PASSWORD boot --flavor $FLAVOR --image $IMAGE_BASE --user-data doUpdateImage.sh $INST_NAME
