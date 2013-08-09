#/bin/bash

cd $HOME

mkdir backoffice_process_manager
cd backoffice_process_manager
virtualenv -p /usr/bin/python2.7 venv --distribute

source venv/bin/activate

git clone https://github.com/PDI-DGS-Protolab/backoffice_process_manager

cd backoffice_process_manager

git checkout automator
