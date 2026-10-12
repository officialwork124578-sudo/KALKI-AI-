#!/data/data/com.termux/files/usr/bin/bash
# KALKI AI — One-shot installer
set -u

echo "═══ KALKI INSTALLER ═══"
sleep 1

# --- 1. Termux deps ---
echo "▸ [1/6] Termux packages..."
pkg install -y jq curl wget git tmux termux-api python-pip openssh 2>&1 | tail -2

# --- 2. proot Ubuntu ---
echo "▸ [2/6] Ubuntu container..."
if ! proot-distro list 2>/dev/null | grep -q "ubuntu"; then
  proot-distro install ubuntu
fi

# --- 3. Ollama + models ---
echo "▸ [3/6] Ollama + models..."
proot-distro login ubuntu -- bash -c "
  command -v ollama >/dev/null 2>&1 || {
    apt update -qq
    apt install -y -qq curl jq zstd
    curl -fsSL https://ollama.com/install.sh | sh
  }
  ollama list 2>/dev/null | grep -q qwen2.5:3b || ollama pull qwen2.5:3b
  ollama list 2>/dev/null | grep -q qwen2.5:7b || ollama pull qwen2.5:7b
"

# --- 4. Kalki files ---
echo "▸ [4/6] KALKI files..."
mkdir -p ~/.kalki/{keys,logs,hooks,skills,memory,sessions}
mkdir -p ~/bin
cp kalki.sh ~/bin/kalki 2>/dev/null
cp brain-watchdog.sh ~/bin/brain-watchdog.sh 2>/dev/null
cp dispatch.sh ~/.kalki/dispatch.sh 2>/dev/null
cp hooks/*.sh ~/.kalki/hooks/ 2>/dev/null
cp skills/*.md ~/.kalki/skills/ 2>/dev/null
cp banner.txt ~/.kalki/banner.txt 2>/dev/null
cp policy.conf ~/.kalki/policy.conf 2>/dev/null
cp registry.json ~/.kalki/registry.json 2>/dev/null
chmod +x ~/bin/kalki ~/bin/brain-watchdog.sh ~/.kalki/dispatch.sh ~/.kalki/hooks/*.sh

# --- 5. Aliases ---
echo "▸ [5/6] Shell aliases..."
grep -q "kalki-start" ~/.bashrc || cat >> ~/.bashrc <<'K'

kalki-start() {
  tmux has-session -t brain 2>/dev/null || {
    echo "🐘 brain..."
    tmux new-session -d -s brain 'proot-distro login ubuntu -- bash -c "ollama serve 2>&1 | tee ~/ollama.log"'
    sleep 6
  }
  tmux has-session -t watchdog 2>/dev/null || tmux new-session -d -s watchdog '~/bin/brain-watchdog.sh'
  curl -s -m 3 http://127.0.0.1:11434/api/tags >/dev/null 2>&1 || sleep 8
  bash ~/bin/kalki
}
alias kalki='kalki-start'

kalki-remember() { echo "[$(date +%F)] $1" >> ~/.kalki/memory/facts.md; echo "✅ $1"; }
K

# --- 6. Boot script ---
echo "▸ [6/6] Auto-boot..."
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/01-kalki.sh <<'B'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
sleep 8
tmux new-session -d -s brain 'proot-distro login ubuntu -- bash -c "ollama serve 2>&1 | tee ~/ollama.log"'
sleep 6
tmux new-session -d -s watchdog '~/bin/brain-watchdog.sh'
B
chmod +x ~/.termux/boot/01-kalki.sh

source ~/.bashrc

echo ""
echo "═══ ✅ INSTALL COMPLETE ═══"
echo "Next:  bash ~/.kalki/setup-keys.sh  (keys daalo)"
echo "Then:  kalki                         (chalao)"
