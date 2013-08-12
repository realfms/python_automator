#!/bin/bash

cd $HOME
cd backoffice_process_manager

source venv/bin/activate

cd backoffice_process_manager

echo "Updating source code"
git pull origin automator

echo "Updating static files cache"
python manage.py collectstatic --noinput

echo "Updating base platform dependencies"
sh ./system-dependencies.sh

echo "Updating python dependencies"
pip install -r requirements.txt

