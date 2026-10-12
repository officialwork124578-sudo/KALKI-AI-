#!/data/data/com.termux/files/usr/bin/bash
# KALKI Brain Watchdog — keeps ollama alive
LOG="$HOME/.kalki/logs/watchdog.log"
mkdir -p "$(dirname "$LOG")"

while :; do
  # Check if brain tmux session alive
  if ! tmux has-session -t brain 2>/dev/null; then
    echo "[$(date +%T)] brain dead — restarting" >> "$LOG"
    tmux new-session -d -s brain 'proot-distro login ubuntu -- bash -c "ollama serve 2>&1 | tee ~/ollama.log"'
    sleep 8
  fi
  # Check if ollama responds
  if ! curl -s -m 3 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    echo "[$(date +%T)] ollama unresponsive — killing+restart" >> "$LOG"
    tmux kill-session -t brain 2>/dev/null
    sleep 2
    tmux new-session -d -s brain 'proot-distro login ubuntu -- bash -c "ollama serve 2>&1 | tee ~/ollama.log"'
    sleep 8
  fi
  sleep 20
done
