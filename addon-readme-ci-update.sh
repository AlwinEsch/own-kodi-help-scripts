#!/bin/bash

BASE_PATH=$(dirname $0)/..

if [ ! $1 ];then
    echo "Needed add-on path not set!"
    exit 1
fi

ADDON_DIR=$1
PREV_RELEASE=$(grep -oP /job/.+?/badge $ADDON_DIR/README.md | cut -d "/" -f 7)
PREV_RELEASE=$(echo $PREV_RELEASE | tr -d '\r')
CURRENT_RELEASE=$(cat $BASE_PATH/kodi/cmake/addons/bootstrap/repositories/binary-addons.txt | cut -d " " -f 3 | tr -d '\r')

printf " - README.md CI update to %s (old release %s) " $CURRENT_RELEASE $PREV_RELEASE


if [[ $PREV_RELEASE == $CURRENT_RELEASE ]]; then
  printf "ignored, already done\n"
  exit 0
fi

sed -i "s/branch=$PREV_RELEASE/branch=$CURRENT_RELEASE/g" $ADDON_DIR/README.md
sed -i "s/branchName=$PREV_RELEASE/branchName=$CURRENT_RELEASE/g" $ADDON_DIR/README.md
sed -i "s/job\/$PREV_RELEASE\/badge/job\/$CURRENT_RELEASE\/badge/g" $ADDON_DIR/README.md

printf "performed\n"

/usr/bin/git -C $ADDON_DIR add ./README.md
/usr/bin/git -C $ADDON_DIR commit -m "update CI branch within README.md to $CURRENT_RELEASE"
