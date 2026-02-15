# ==========================================
# 🤖 AI AGENT SYSTEM
# ==========================================

export PATH="$HOME/.local/bin:$PATH"
export GROQ_API_KEY="YOUR_KEY_HERE"

# НАВИГАЦИЯ
alias cs='gh codespace ssh'
alias repos='ls -la /workspaces/'

repo() {
    if [ -z "$1" ]; then
        echo "📂 Repos:"; ls -1 /workspaces/; return
    fi
    cd "/workspaces/$1" && pwd && git status --short
}

# GIT
alias gs='git status'
alias ga='git add -A'
alias gp='git push'
alias gl='git log --oneline -10'

save() {
    git add -A && git commit -m "${1:-wip}" && git push 2>/dev/null
}

# AI COMMANDS
alias ai='aider --model groq/llama-3.1-8b-instant --dark-mode --auto-commits --yes'
alias aia='aider --model groq/llama-3.3-70b-versatile --architect --dark-mode --yes'

agent() {
    if [ ! -f "$HOME/.agent/agent.sh" ]; then
        echo "❌ Agent not installed. Run: bash /workspaces/The-AI-Corporation/install.sh"
        return 1
    fi
    bash "$HOME/.agent/agent.sh" "$@"
}

# AUTO-RESTORE
if [ ! -d "$HOME/.agent" ] && [ -f "/workspaces/The-AI-Corporation/install.sh" ]; then
    bash /workspaces/The-AI-Corporation/install.sh > /dev/null 2>&1
fi

alias sync-system='bash /workspaces/The-AI-Corporation/install.sh'

help-ai() {
    echo "
    ╔══════════════════════════════════════╗
    ║        🤖 AI AGENT SYSTEM            ║
    ╠══════════════════════════════════════╣
    ║  agent \"task\"  — автономный агент   ║
    ║  ai            — aider быстрый       ║
    ║  aia           — aider умный         ║
    ║  repo          — перейти в репо      ║
    ║  save          — commit + push       ║
    ║  sync-system   — обновить систему    ║
    ╚══════════════════════════════════════╝
    "
}

echo "💡 help-ai — список команд"
