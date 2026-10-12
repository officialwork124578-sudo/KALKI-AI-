#!/data/data/com.termux/files/usr/bin/bash
[ -z "$ARG" ] && { echo "no url"; exit 1; }
curl -sL -m 20 "$ARG" | head -c 8192
