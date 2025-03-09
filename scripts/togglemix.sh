#!/bin/bash
set -x
#This script makes your real mic audio go into the VirtualMic

#WHAT THIS SCRIPT SHOULD DO
#Toggle routing system mic to VirtualSource
#Make paplay soundboard process Quieter or louder (view with pactl list sink-inputs )


set_soundboard_volume(){
	#$1: percentage
	#im tempted
	#TO MANUALLY PARSE IT
	#NO IM NOT USING CHATGPT

	sinkinputnumber=
	pactl list sink-inputs | while read -r line; do
		if grep --silent "Sink Input #" <<< $line; then
			sinkinputnumber=$(awk '{print $3}' <<< $line | sed 's/#//')
			continue
		fi
		#echo "$sinkinputnumber EEEEEE"
		if grep --silent paplay <<< $line; then
			echo "setting volume of sink $sinkinputnumber to $1"
			#gotem
			#now change the volume
			pactl set-sink-input-volume "$sinkinputnumber" ${1}%
		fi
	done
}

already_there=$(pactl list modules short | grep -E "module-loopback.*source=alsa_input.pci.*Mic1.*sink=VirtualSource")
if [ $? -eq 0 ]; then
	#The routing is already there, nuke it
	id=$(awk '{print $1}' <<< $already_there)
	pactl unload-module "$id"
	echo "removed mic routing"
	#Set volume of paplay process to 100%
	set_soundboard_volume 100
else
	#its not there
	#so make it
	pactl load-module module-loopback source=alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source sink=VirtualSource
	#We turn down the volume of the song/sound thats currently playing
	#So that our voice is not lost in the sounds
	set_soundboard_volume 60
fi
