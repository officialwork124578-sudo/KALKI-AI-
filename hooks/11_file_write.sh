#!/data/data/com.termux/files/usr/bin/bash
# ARG="path|content"
p="${ARG%%|*}"; c="${ARG#*|}"
case "$p" in /*|~*) ;; *) p="$HOME/$p";; esac
printf '%s' "$c" > "$p" && echo "wrote $(wc -c <"$p")B → $p"
