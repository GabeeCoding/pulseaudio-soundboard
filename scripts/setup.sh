#!/bin/sh

pactl load-module module-null-sink sink_name=VirtualSink sink_properties=device.description="Virtual_Speaker"
pactl load-module module-null-sink sink_name=VirtualSource sink_properties=device.description="Virtual_Microphone"
pactl load-module module-loopback source=VirtualSink.monitor sink=VirtualSource
pactl load-module module-remap-source master=VirtualSource.monitor source_name=VirtualMic source_properties=device.description="Virtual_Miccc"
