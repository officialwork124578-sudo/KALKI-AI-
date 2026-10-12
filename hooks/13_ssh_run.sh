#!/data/data/com.termux/files/usr/bin/bash
# ARG="host|cmd"
h="${ARG%%|*}"; c="${ARG#*|}"
[ -z "$h" ] && { echo "no host"; exit 1; }
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 "$h" "$c"
