#!/bin/bash

cd $HOME

sudo yum -y install git

git clone https://github.com/PDI-DGS-Protolab/python_automator

echo 'export PATH=$PATH:$HOME/python_automator/' >> $HOME/.bashrc
