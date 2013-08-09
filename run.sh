#!/bin/bash

cd $HOME
cd backoffice_process_manager

source venv/bin/activate

cd backoffice_process_manager

foreman start
