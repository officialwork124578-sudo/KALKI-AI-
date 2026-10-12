#!/data/data/com.termux/files/usr/bin/bash
case "$ARG" in
  get) termux-clipboard-get;;
  set\ *) termux-clipboard-set "${ARG#set }";;
  *) echo "usage: get|set <text>";;
esac
