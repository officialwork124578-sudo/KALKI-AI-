#!/data/data/com.termux/files/usr/bin/bash
termux-location 2>/dev/null | jq -r '"lat=\(.latitude) lon=\(.longitude)"'
