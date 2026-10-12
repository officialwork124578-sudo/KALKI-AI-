# KALKI AI

**by JOHN WICK · Directed By 3rD EYE 👁️**

Sovereign · Unrestricted · Fingerprint-Auth · Ultrafast

## Architecture

- Multi-Brain Router: Groq (fast) → Gemini → OpenRouter → Local Ollama
- Local fallback: qwen2.5-coder:7b / qwen2.5:7b / qwen2.5:3b
- Auth: Termux fingerprint
- Tools: 14+ hooks (shell, SMS, camera, battery, clipboard, web-search, ssh, notify)
- Skills: on-demand .md loader
- Memory: 3-layer (facts + preferences + sessions)
- Watchdog: auto-restart brain on crash
- Auto-boot: Termux:Boot integration

## Install

    git clone https://github.com/officialwork124578-sudo/KALKI-AI-.git
    cd KALKI-AI-
    bash install.sh

## Run

    kalki

## Security

- Keys stored in ~/.kalki/keys/*.key (chmod 600)
- .gitignore blocks all key files
- Fingerprint auth per session

## License

Personal Sovereign Use
