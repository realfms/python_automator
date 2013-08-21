#/bin/bash

. getenv.sh

cd $REPO_DST
#FMS - Check if already inited. User may be wrong
if [ -d $REPO_SHORT_NAME ]
then
	echo "Error. Found an already initted repo. Delete if necessary and try again"
	exit 1
fi

git clone $REPO_SRC
cd $REPO_SHORT_NAME
git checkout $BRANCH_NAME

virtualenv -p /usr/bin/python2.7 venv --distribute
source venv/bin/activate

#Add venv to gitignore
echo "venv" >> .gitignore

