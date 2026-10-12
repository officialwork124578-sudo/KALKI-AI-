#!/data/data/com.termux/files/usr/bin/bash
[ -z "$ARG" ] && { echo "no url"; exit 1; }
am start -a android.intent.action.VIEW -d "$ARG" >/dev/null 2>&1
