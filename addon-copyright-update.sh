#!/bin/bash

if [ ! $1 ];then
    echo "Needed add-on path not set!"
    exit 1
fi

ADDON_DIR=$1
CURRENT_YEAR=$(date +%Y)
UPDATE_IT=0

printf " - Copyright year update to %s " $CURRENT_YEAR

for f in $(find $ADDON_DIR -type f -print); do
    if [[ $f == $ADDON_DIR/build/** ]] || \
       [[ $f != *.cpp ]] && \
       [[ $f != *.c ]] && \
       [[ $f != *.hpp ]] && \
       [[ $f != *.h ]] || \
       [[ $(sed -n 1,10p $f) != *"Team Kodi (https://kodi.tv)"* ]]; then
        continue
    fi

    grep -q "${CURRENT_YEAR} Team Kodi (https://kodi.tv)" $f
    if [ $? == 1 ]; then
        sed -i "0,/20[0-9][0-9] Team Kodi/{s/20[0-9][0-9] Team Kodi/${CURRENT_YEAR} Team Kodi/g}" $f
        UPDATE_IT=1
    fi
done

if [ -f "$ADDON_DIR/debian/copyright" ]; then
    sed -i "0,/20[0-9][0-9] Team Kodi/{s/20[0-9][0-9] Team Kodi/${CURRENT_YEAR} Team Kodi/g}" $ADDON_DIR/debian/copyright
fi

if [ $UPDATE_IT == 1 ]; then
    printf "performed\n"
    /usr/bin/git -C $ADDON_DIR add .
    /usr/bin/git -C $ADDON_DIR commit -m "update source codes copyright year to $CURRENT_YEAR"
else
    printf "ignored, already done\n"
fi
