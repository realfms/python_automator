#!/bin/bash

cd $HOME
cd backoffice_process_manager

source venv/bin/activate

cd backoffice_process_manager

file=".config"
url=`cat .config`

wget --output-document .env $url

file=".env"

while read line
do
    if [ -z "$line" ]; then
    	continue;
    fi

    value="export $line";
    echo $value;
    `$value`
done < "$file"

foreman start
