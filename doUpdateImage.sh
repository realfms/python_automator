#!/bin/bash

#Clone source repo
cd /dev/shm
git clone https://github.com/realfms/python_automator.git
cd python_automator
git checkout FMS-OPST

./install.sh

#Put config
echo "http://10.95.158.5/repo/backoffice_process_manager/.env" > .config

#Init repo
init-repo.sh

#Update the code to latest version
update-code.sh

#Run the project. May be optional
run-project.sh

