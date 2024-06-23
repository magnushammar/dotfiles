#!/bin/bash

# Killing older instance incase of upgrade
HOST_PID=$(pgrep sconnect_host_l)
if [ $HOST_PID > 0 ]; then
echo Killing $HOST_PID
kill $HOST_PID
fi

# Killing older instance in case of upgrade
pkill -f sconnect_host_linux || true

set -x
set -e

# Create the SConnect folder
DIR_SCONNECT=~/.sconnect
if [ -d $DIR_SCONNECT ]; then
     rm -r $DIR_SCONNECT
fi
mkdir -p $DIR_SCONNECT

# Create the Firefox folder
DIR_MOZILLA=~/.mozilla/native-messaging-hosts
if ! [ -d $DIR_MOZILLA ]; then
     mkdir -p $DIR_MOZILLA
fi

# Create the Chrome folder
DIR_GOOGLE=~/.config/google-chrome/NativeMessagingHosts
if ! [ -d $DIR_GOOGLE ]; then
     mkdir -p $DIR_GOOGLE
fi

# Deploy the files
HOST_FILE=sconnect_host_linux

if [ -d $DIR_MOZILLA ]; then
     if [ -f $DIR_MOZILLA/com.gemalto.sconnect.json ]; then
          rm $DIR_MOZILLA/com.gemalto.sconnect.json
     fi
     cp com.gemalto.sconnect-ff.json $DIR_MOZILLA/com.gemalto.sconnect.json
fi

if [ -d $DIR_GOOGLE ]; then
     if [ -f $DIR_GOOGLE/com.gemalto.sconnect.json ]; then 
          rm $DIR_GOOGLE/com.gemalto.sconnect.json
     fi
     cp com.gemalto.sconnect.json $DIR_GOOGLE
fi

cp $HOST_FILE $DIR_SCONNECT

# Make the host file an executable
chmod 755 $DIR_SCONNECT/$HOST_FILE

# Modify the current username into the json file
if [ -d $DIR_MOZILLA ]; then
     sed -i 's/<<<user>>>/'$USER'/g' $DIR_MOZILLA/com.gemalto.sconnect.json
fi
 
if [ -d $DIR_GOOGLE ]; then
     sed -i 's/<<<user>>>/'$USER'/g' $DIR_GOOGLE/com.gemalto.sconnect.json
fi
