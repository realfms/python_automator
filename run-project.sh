#!/bin/bash

. getenv.sh

cd $REPO_DST
cd $REPO_SHORT_NAME

source venv/bin/activate

$PREPARE_CMD
$RUN_CMD
