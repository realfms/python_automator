#!/bin/bash

DESTPATH=/usr/bin

#Check if we're root
if [[ $EUID -ne 0 ]]; then
   echo "Root is required" 1>&2
   exit 1
fi

cp -f *.sh $DESTPATH
