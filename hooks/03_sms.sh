#!/data/data/com.termux/files/usr/bin/bash
# ARG="number|body"
n="${ARG%%|*}"; b="${ARG#*|}"
[ -z "$n" ] && { echo "no number"; exit 1; }
termux-sms-send -n "$n" "$b" && echo "sms→$n"
