#!/data/data/com.termux/files/usr/bin/bash
# KALKI hook dispatcher — usage: dispatch.sh <hook_name> <arg>
set -u
K="$HOME/.kalki"
HOOK="$1"; ARG="${2:-}"
LOG="$K/logs/hooks_$(date +%Y%m%d).log"

[ -z "$HOOK" ] && { echo "no hook"; exit 2; }
SCRIPT="$K/hooks/${HOOK}.sh"
[ ! -x "$SCRIPT" ] && { echo "unknown hook: $HOOK"; exit 3; }

# policy lookup
POLICY=$(grep "^HOOK_${HOOK}=" "$K/policy.conf" | cut -d= -f2)
POLICY="${POLICY:-confirm}"

TS=$(date +%H:%M:%S)
echo "[$TS] hook=$HOOK arg=$ARG policy=$POLICY" >>"$LOG"

if [ "$POLICY" = "block" ]; then
  echo "🚫 blocked by policy"
  exit 4
fi

if [ "$POLICY" = "confirm" ]; then
  echo "⚙️  HOOK: $HOOK"
  echo "   arg: $ARG"
  printf "run? [y/N] > "; read -r c
  case "$c" in y|Y|yes|haan|ha|ok) ;; *) echo "⏭️  skipped"; exit 0;; esac
fi

export ARG
OUT=$("$SCRIPT" 2>&1)
RC=$?
echo "[$TS] rc=$RC out=$(printf '%s' "$OUT" | head -c 200)" >>"$LOG"
printf '%s\n' "$OUT"
exit $RC
