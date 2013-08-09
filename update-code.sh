#!/bin/bash

cd $HOME
cd backoffice_process_manager

source venv/bin/activate

git pull origin automator

echo "Updating base platform dependencies"
sh ./backoffice_process_manager/platform-installation-script.sh

echo "Updating python dependencies"
pip-python install -r backoffice_process_manager/requirements.txt

