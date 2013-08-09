#/bin/bash

sudo yum -y install git, python27, python-pip
sudo easy_install virtualenv

echo 'alias pip="/usr/bin/pip-python"' >> $HOME/.bashrc
