#!/data/data/com.termux/files/usr/bin/bash
[ -z "$ARG" ] && { echo "no path"; exit 1; }
case "$ARG" in /*|~*) ;; *) ARG="$HOME/$ARG";; esac
[ -r "$ARG" ] || { echo "unreadable"; exit 1; }
head -c 4096 "$ARG"
