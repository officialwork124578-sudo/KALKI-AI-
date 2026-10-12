#!/data/data/com.termux/files/usr/bin/bash
termux-battery-status | jq -r '"\(.percentage)% | \(.status) | \(.temperature)°C"'
