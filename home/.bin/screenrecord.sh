ffmpeg -video_size 1600x900 -framerate 30 -f x11grab -i :0.0 -c:v libx264 -crf 0 -preset ultrafast ~/Videos/screen-$(date +"%Y%m%d-%H:%M:%S").mkv
