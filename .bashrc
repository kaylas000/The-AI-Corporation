# ==========================================
# 🤖 GLOBAL AI SYSTEM
# ==========================================

export PATH="$HOME/.local/bin:$PATH"
export GROQ_API_KEY="YOUR_KEY_HERE"

# ==========================================
# НАВИГАЦИЯ
# ==========================================
alias cs='gh codespace ssh'
alias css='gh codespace create'
alias csl='gh codespace list'
alias csd='gh codespace delete'
alias repos='ls -la /workspaces/'

repo() {
    if [ -z "$1" ]; then
        echo "📂 Доступные репозитории:"
        ls -1 /workspaces/
        echo ""
        echo "Использование: repo <имя>"
        return
    fi
    cd "/workspaces/$1" && echo "📍 $(pwd)" && gs
}

clone() {
    cd /workspaces/
    gh repo clone "$1"
    cd "$(basename $1)"
    echo "📍 $(pwd)"
}

new() {
    local NAME="$1"
    if [ -z "$NAME" ]; then
        echo "Использование: new <имя-репо>"
        return 1
    fi
    cd /workspaces/
    mkdir -p "$NAME" && cd "$NAME"
    git init
    echo "# $NAME" > README.md
    cp ~/.agent/scripts/templates/gitignore .gitignore 2>/dev/null || echo -e "__pycache__/\n*.pyc\n.env\nvenv/\nnode_modules/" > .gitignore
    git add -A
    git commit -m "init: $NAME"
    gh repo create "$NAME" --public --source=. --remote=origin --push
    echo "✅ Репо создан: https://github.com/$(gh api user -q .login)/$NAME"
}

# ==========================================
# GIT SHORTCUTS
# ==========================================
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gpl='git pull'

save() {
    git add -A
    git commit -m "${1:-wip: save}"
    git push 2>/dev/null || git push -u origin main
    echo "✅ Saved & pushed"
}

# ==========================================
# AI COMMANDS
# ==========================================
alias ai='aider --model groq/llama-3.1-8b-instant --dark-mode --auto-commits --no-show-model-warnings --yes'
alias aia='aider --model groq/llama-3.3-70b-versatile --architect --dark-mode --auto-commits --no-show-model-warnings --yes'

# agent — автономный агент
agent() {
    local DESC="$*"
    if [ -z "$DESC" ] && [ -f ".agent/description" ]; then
        DESC=$(cat .agent/description)
    fi
    if [ -z "$DESC" ]; then
        echo "Usage: agent \"project description\""
        return 1
    fi
    if [ ! -d ".agent" ]; then
        local DIR_NAME=$(echo "$DESC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g' | cut -c1-30)
        cd /workspaces/
        mkdir -p "$DIR_NAME" && cd "$DIR_NAME"
        git init
        gh repo create "$DIR_NAME" --public --source=. --remote=origin 2>/dev/null || true
    fi
    source ~/.agent/agent.sh "$DESC"
}

resume() {
    if [ ! -f ".agent/phase" ]; then
        echo "❌ No agent state. Start: agent \"description\""
        return 1
    fi
    local DESC=$(cat .agent/description 2>/dev/null || echo "resume")
    echo "📍 Phase: $(cat .agent/phase) | Task: $DESC"
    source ~/.agent/agent.sh "$DESC"
}

agent-status() {
    if [ -d ".agent" ]; then
        echo "Phase:   $(cat .agent/phase 2>/dev/null || echo 'none')"
        echo "Task:    $(cat .agent/description 2>/dev/null || echo 'none')"
        echo "Tests:   $(cat .agent/test_status 2>/dev/null || echo 'not run')"
        echo "Lint:    $(cat .agent/lint_status 2>/dev/null || echo 'not run')"
    else
        echo "No agent in this directory"
    fi
}

# ==========================================
# HELP
# ==========================================
help-ai() {
    echo "
    ╔══════════════════════════════════════╗
    ║        🤖 AI SYSTEM COMMANDS         ║
    ╠══════════════════════════════════════╣
    ║  НАВИГАЦИЯ:                          ║
    ║    cs        — войти в codespace     ║
    ║    csl       — список codespaces     ║
    ║    css       — создать codespace     ║
    ║    repo      — перейти в репо        ║
    ║    repos     — список репо           ║
    ║    clone     — клонировать репо      ║
    ║    new       — создать новый репо    ║
    ║                                      ║
    ║  GIT:                                ║
    ║    gs        — git status            ║
    ║    ga        — git add -A            ║
    ║    gc        — git commit -m         ║
    ║    gp        — git push              ║
    ║    gpl       — git pull              ║
    ║    gl        — git log (10)          ║
    ║    gd        — git diff              ║
    ║    save      — commit + push         ║
    ║                                      ║
    ║  AI:                                 ║
    ║    ai        — aider (быстрый 8b)    ║
    ║    aia       — aider (умный 70b)     ║
    ║    agent     — автономный агент      ║
    ║    resume    — продолжить агента     ║
    ║    agent-status — статус агента      ║
    ╚══════════════════════════════════════╝
    "
}

echo "💡 Напиши help-ai для списка команд"

# ==========================================
# AUTO-RESTORE SYSTEM
# ==========================================
if [ ! -d "$HOME/.agent" ] && [ -d "/workspaces/The-AI-Corporation" ]; then
    echo "🔄 Restoring AI system..."
    bash /workspaces/The-AI-Corporation/install.sh > /dev/null 2>&1
fi

# Quick sync command
alias sync-system='cd /workspaces/The-AI-Corporation && bash install.sh'
