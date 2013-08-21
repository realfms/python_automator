#!/bin/bash

. getenv.sh

cd $REPO_DST
cd $REPO_SHORT_NAME

source venv/bin/activate

echo "Updating base platform dependencies"
sh ./system-dependencies.sh

echo "Updating python dependencies"
pip install -r requirements.txt

echo "Updating source code"
git pull origin $BRANCH_NAME

echo "Updating static files cache"
python manage.py collectstatic --noinput
