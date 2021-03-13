#!/bin/bash

mkdir blur

youtube-dl $(curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/Indiantiktokgonewild/hot.json?limit=12 | jq '.' | grep url_overridden_by_dest | grep -Eoh "https:\/\/v\.redd\.it\/\w{13}") 

for f in *.mp4;
do
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f ;
done


for f in blur/*.mp4; do echo "file $f" >> file_list.txt ; done 
ffmpeg -f concat -i file_list.txt final.mp4 


ffmpeg -ss 00:00:5 -i final.mp4 -frames 1 -vf "select=not(mod(n\,400)),scale=160:120,tile=3x2" thumbnail.png
