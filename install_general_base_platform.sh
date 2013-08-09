#/bin/bash

sudo yum -y install git, python27, python-pip
sudo easy_install virtualenv

sudo yum erase -y ruby rubygems
sudo yum -y install ruby19

yum erase -y ruby rubygems

sudo ln -s /usr/bin/gem1.9 /usr/bin/gem
sudo ln -s /usr/bin/ruby1.9 /usr/bin/ruby

sudo gem install foreman

echo 'alias pip="/usr/bin/pip-python"' >> $HOME/.bashrc
