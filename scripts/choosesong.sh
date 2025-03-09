#!/bin/bash

location=~/soundboard/selection
list=$(ls $location)

set -x


#--audio-quality 10
input="$(zenity --entry --text="$list")"
[ $? -ne 0 ] && exit

# searchresult(){
# 	ls -1 $location/*$input* | head -n 1
# }

searchresult2(){
    find -L "$location" -type f | awk -v input="$input" '
    {
        score = 0;
        if (tolower($0) ~ tolower(input)) score += 10;
        split($0, parts, "/");
        name = parts[length(parts)];
        if (tolower(name) ~ tolower(input)) score += 20;
        if (score > 0) print score, $0;
    }' | sort -k1 -nr | awk '{$1=""; print substr($0,2)}' | head -n 1
}

# searchresultlegacy(){
# 	find -L "$location" -type f | awk -v input="$input" '
# {
#     score = 0;
#     if (tolower($0) ~ tolower(input)) score += 10;
#     split($0, parts, "/");
#     name = parts[length(parts)];
#     if (tolower(name) ~ tolower(input)) score += 20;
#     if (score > 0) print $0, score;
# }' | sort -k2 -nr | cut -d ' ' -f1 | head -n 1
# }
location="$(searchresult2)"

ext(){
	grep "\.$1" <<< "$location"
}

#if the file extension is mp4 or m4a
if ext mp4 || ext m4a; then
    #then convert it
	ffmpeg -i "$location" -f wav - | paplay --device=VirtualSink
else
    #or just pass it to paplay for playing
	paplay --device=VirtualSink "$location"
fi
