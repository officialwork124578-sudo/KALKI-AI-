#!/data/data/com.termux/files/usr/bin/bash
f="${ARG:-$HOME/storage/pictures/kalki_$(date +%s).jpg}"
termux-camera-photo -c 0 "$f" && echo "photo→$f"
