#!/data/data/com.termux/files/usr/bin/bash
[ -z "$ARG" ] && { echo "no cmd"; exit 1; }
bash -lc "$ARG"
