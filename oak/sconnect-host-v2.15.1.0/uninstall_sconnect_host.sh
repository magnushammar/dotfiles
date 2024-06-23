#!/bin/bash

# Killing sconnect instance
HOST_PID=$(pgrep sconnect_host_l)
if [ $HOST_PID > 0 ]; then
echo Killing $HOST_PID
kill $HOST_PID
fi

# Remove the SConnect folder
DIR_SCONNECT=~/.sconnect
rm -r $DIR_SCONNECT


# Clean the Firefox folder
DIR_MOZILLA=~/.mozilla/native-messaging-hosts
if [ -d $DIR_MOZILLA ]; then
	rm -r $DIR_MOZILLA/com.gemalto.sconnect.json
fi


# Clean the Chrome folder
DIR_GOOGLE=~/.config/google-chrome/NativeMessagingHosts
if [ -d $DIR_GOOGLE ]; then
	rm -r $DIR_GOOGLE/com.gemalto.sconnect.json
fi

echo "Uninstall completed"