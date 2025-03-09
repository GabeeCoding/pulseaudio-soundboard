#!/bin/bash

#This script controls the thingy that makes you hear
#the soundboard mic output through your own speakers

#just make this a toggling script

#check if this module is already there

already_there=$(pactl list modules short | grep -E 'module-loopback.*source=VirtualSink.monitor.*latency_msec=1')

if [ $? -eq 0 ]; then
	#its already there
	#nuke it
	id=$(awk '{print $1}' <<< $already_there)
	pactl unload-module "$id"
	echo "removed listen in"
else
	#its not there
	#so make it
	pactl load-module module-loopback source=VirtualSink.monitor latency_msec=1
	echo "added listen in"
fi
