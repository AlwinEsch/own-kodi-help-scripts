#!/bin/bash

SCRIPT_PATH=$(dirname $0)
BASE_PATH=$SCRIPT_PATH/..
USER=alwin

for d1 in $BASE_PATH/addons/$USER/*; do
  for d2 in $d1/*; do
    printf "Update addon %s\n" $(basename $d2)
    $SCRIPT_PATH/addon-copyright-update.sh $d2
    $SCRIPT_PATH/addon-readme-ci-update.sh $d2

    exit

  done
done
