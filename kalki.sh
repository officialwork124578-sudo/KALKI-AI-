#!/data/data/com.termux/files/usr/bin/bash
# KALKI AI by JOHN WICK — Directed By 3rD EYE — v4 CHAT
set -u


K="$HOME/.kalki"; mkdir -p "$K/logs"
LOG="$K/logs/kalki_$(date +%Y%m%d).log"
OLLAMA="http://127.0.0.1:11434"
MODEL_CHAT="qwen2.5:3b"
MODEL_TOOL="qwen2.5:7b"
MODEL_CODE="qwen2.5-coder:7b"
OR_URL="https://openrouter.ai/api/v1/chat/completions"
OR_MODEL="deepseek/deepseek-chat-v3:free"

log(){ printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*" >>"$LOG"; }

# ---------- FINGERPRINT AUTH ----------
say_now(){ termux-tts-speak "$1" >/dev/null 2>&1 & }
auth(){
  local r i
  for i in 1 2 3; do
    r=$(termux-fingerprint 2>/dev/null)
    echo "$r" | grep -q AUTH_RESULT_SUCCESS && return 0
  done
  return 1
}

clear
# Trishul pulse
for i in 1 2 3; do
  printf "\n\033[31m\033[1m          🔱  T R I S H U L   A W A K E N S  🔱\033[0m\n"
  sleep 0.3
  printf "\r\033[33m\033[1m          🔱  T R I S H U L   A W A K E N S  🔱\033[0m"
  sleep 0.3
done
echo ""
sleep 0.3
clear
# Eye blink
for i in 1 2 3; do
  printf "\n\033[36m\033[1m     ╱╲\n    ╱  ╲\n   ╱ ◉  ╲\n  ╱──────────╲\033[0m\n"
  sleep 0.3
  clear
  printf "\n\033[35m\033[1m     ╱╲\n    ╱  ╲\n   ╱ ●  ╲\n  ╱──────────╲\033[0m\n"
  sleep 0.3
  clear
done
cat "$HOME/.kalki/banner.txt"
echo ""
if ! auth; then echo "❌ Access denied."; exit 1; fi

# ---------- BANNER ----------

OR_ENABLED=1
HIST=()

build_msgs(){
  local out='[{"role":"system","content":"You are KALKI, sovereign AI on Android Termux. Reply ALWAYS in Hinglish (Roman). VERY concise. Two modes: (1) NORMAL CHAT = plain Hinglish text. (2) TOOL CALL = emit ONE line JSON only: {\"hook\":\"NAME\",\"arg\":\"VALUE\",\"say\":\"short Hinglish\"}. HOOKS: 01_shell(cmd) 02_open_url(url) 03_sms(num|body) 04_notify(text) 05_clipboard(get or set TEXT) 06_battery() 07_location() 08_camera(path) 09_tts(text) 10_file_read(path) 11_file_write(path|content) 12_http_get(url) 13_ssh_run(host|cmd) 14_web_search(query). Examples: battery kitni hai -> {\"hook\":\"06_battery\",\"arg\":\"\",\"say\":\"Battery check\"}. uname kya hai -> {\"hook\":\"01_shell\",\"arg\":\"uname -a\",\"say\":\"Chala raha hoon\"}. tum kaun ho -> plain Hinglish, no JSON."}' 
  local m
  for m in "${HIST[@]}"; do
    out="$out,$m"
  done
  printf '%s]' "$out"
}

ask_groq(){
  local msgs="$1"
  local key
  [ -s "$HOME/.kalki/keys/groq.key" ] || return 1
  key=$(cat "$HOME/.kalki/keys/groq.key")
  # Skip if placeholder
  case "$key" in PASTE_GROQ_KEY_HERE|"") return 1;; esac
  curl -s -m 20 https://api.groq.com/openai/v1/chat/completions \
    -H "Authorization: Bearer $key" \
    -H "Content-Type: application/json" \
    -d "$(jq -nc --argjson msgs "$msgs" '{model:"llama-3.3-70b-versatile",messages:$msgs,max_tokens:500}')" \
    | jq -r '.choices[0].message.content // empty' 2>/dev/null
}

ask_local(){
  local msgs="$1"
  curl -s -m 180 "$OLLAMA/api/chat" \
    -d "$(jq -nc --argjson msgs "$msgs" --arg m "$MODEL_CHAT" '{model:$m,messages:$msgs,stream:false,keep_alive:-1,options:{num_predict:400}}')" \
    | jq -r '.message.content // empty' 2>/dev/null
}

ask_or(){
  local msgs="$1" key
  [ -f "$K/openrouter.key" ] || return 1
  key=$(cat "$K/openrouter.key")
  curl -s -m 60 "$OR_URL" \
    -H "Authorization: Bearer $key" -H "Content-Type: application/json" \
    -d "$(jq -nc --argjson msgs "$msgs" --arg m "$OR_MODEL" '{model:$m,messages:$msgs}')" \
    | jq -r '.choices[0].message.content // empty' 2>/dev/null
}

run_hook(){
  local r="$1"
  local jline
  jline=$(printf '%s' "$r" | grep -oE '\{[^{}]*"hook"[^{}]*\}' | head -1)
  if [ -z "$jline" ]; then
    # also accept legacy {"action":...}
    jline=$(printf '%s' "$r" | grep -oE '\{[^{}]*"action"[^{}]*\}' | head -1)
    if [ -n "$jline" ]; then
      # map legacy
      act=$(printf '%s' "$jline" | jq -r '.action // empty')
      arg=$(printf '%s' "$jline" | jq -r '.arg // empty')
      case "$act" in
        shell) hook="01_shell";;
        open)  hook="02_open_url";;
        sms)   hook="03_sms";;
        *)     return 1;;
      esac
      [ -z "$arg" ] && return 1
      bash "$HOME/.kalki/dispatch.sh" "$hook" "$arg"
      return 0
    fi
    return 1
  fi
  local hook arg
  hook=$(printf '%s' "$jline" | jq -r '.hook // empty')
  arg=$(printf '%s' "$jline" | jq -r '.arg // empty')
  [ -z "$hook" ] && return 1
  bash "$HOME/.kalki/dispatch.sh" "$hook" "$arg"
  return 0
}

# KALKI — load memory context
MEM_FACTS="$HOME/.kalki/memory/facts.md"
MEM_PREFS="$HOME/.kalki/memory/preferences.md"

while :; do
  printf '\n🧑 > '
  IFS= read -r inp || break
  [ -z "$inp" ] && continue

  case "$inp" in
    :exit|:quit|:q) echo "Bye."; break;;
    :clear) HIST=(); echo "🧹 history cleared"; continue;;
    :or) OR_ENABLED=$((1-OR_ENABLED)); echo "OpenRouter fallback: $([ $OR_ENABLED = 1 ] && echo ON || echo OFF)"; continue;;
    :help) sed -n '10,20p' "$HOME/bin/kalki"; continue;;
    :raw\ *) inp="${inp#:raw }";;
    :shell\ *) bash -lc "${inp#:shell }"; continue;;
    :web\ *) am start -a android.intent.action.VIEW -d "${inp#:web }" >/dev/null 2>&1; echo "opened"; continue;;
    :sms\ *) rest="${inp#:sms }"; num="${rest%% *}"; body="${rest#* }"; termux-sms-send -n "$num" "$body" && echo "sms sent"; continue;;
  esac

  # escape for JSON
  # KALKI: inject memory into user input
  _mem=""
  [ -f "$MEM_FACTS" ] && _mem="$_mem"$'\n[FACTS]\n'"$(tail -30 "$MEM_FACTS")"
  [ -f "$MEM_PREFS" ] && _mem="$_mem"$'\n[PREFS]\n'"$(cat "$MEM_PREFS")"
  inp_full="${inp}${_mem}"
  user_json=$(jq -nc --arg c "$inp_full" '{role:"user",content:$c}')
  HIST+=("$user_json")

  msgs=$(build_msgs)
  printf '🤖 thinking'
  reply=$(ask_groq "$msgs")
  if [ -z "$reply" ]; then
    reply=$(ask_local "$msgs")
  fi
  if [ -z "$reply" ] && [ "$OR_ENABLED" = "1" ]; then
    printf '\r🤖 [local fail → OpenRouter] '
    reply=$(ask_or "$msgs")
  fi
  printf '\r'
  if [ -z "$reply" ]; then
    echo "❌ no reply (brain down)"; continue
  fi

  # hook detect
  jline=$(printf '%s' "$reply" | grep -oE '\{[^{}]*"(hook|action)"[^{}]*\}' | head -1)
  say_txt=""
  if [ -n "$jline" ]; then
    say_txt=$(printf '%s' "$jline" | jq -r '.say // empty' 2>/dev/null)
    run_hook "$reply"
  fi
  if [ -n "$say_txt" ]; then
    echo "🤖 $say_txt"
  elif [ -n "$jline" ]; then
    # hook replied but no say field — show raw
    :
  else
    echo "🤖 $reply"
  fi

  HIST+=("$(jq -nc --arg c "$reply" '{role:"assistant",content:$c}')")
  log "user: $inp | reply: $reply"
done
