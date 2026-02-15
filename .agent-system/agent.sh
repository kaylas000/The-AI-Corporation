#!/bin/bash
set -e

R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'; C='\033[0;36m'; N='\033[0m'
log() { echo -e "${C}[$(date +%H:%M:%S)]${N} $1"; }
ok() { echo -e "${G}✅ $1${N}"; }
warn() { echo -e "${Y}⚠️  $1${N}"; }
fail() { echo -e "${R}❌ $1${N}"; exit 1; }
step() { echo -e "\n${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}\n${B}  $1${N}\n${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}\n"; }

source ~/.agent/config.sh 2>/dev/null || {
    export SMART_MODEL="groq/llama-3.3-70b-versatile"
    export MAX_RETRY=3
    export GROQ_COOLDOWN=12
}

PROMPT="$*"
[ -z "$PROMPT" ] && echo "Usage: agent \"task\"" && exit 1

PROJECT_NAME=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | tr ' ' '-' | cut -c1-40)
WORKDIR="/workspaces/$PROJECT_NAME"

log "🤖 Agent: $PROMPT"
mkdir -p "$WORKDIR" && cd "$WORKDIR"
[ ! -d ".git" ] && git init && git config user.name "AI" && git config user.email "ai@localhost"

mkdir -p .agent
LOG=".agent/log"

step "1/4: PLANNING"
cat > PLAN.md << PLAN
# $PROMPT

## Tech Stack
- Python, requests, beautifulsoup4, sqlite3

## Files
- main.py, parser.py, db.py, tests/

## Functions
- parse() - scrape
- save() - store in SQLite
PLAN
ok "Plan created"
sleep 3

step "2/4: SCAFFOLD"
mkdir -p src tests
echo "__pycache__/" > .gitignore
echo "# $PROJECT_NAME" > README.md
git add -A && git commit -m "scaffold" 2>/dev/null || true
ok "Structure ready"

step "3/4: CODE"
aider --model "$SMART_MODEL" --yes --message "Implement $PROMPT based on PLAN.md. Create all files with working code." 2>&1 | tee "$LOG"
sleep "$GROQ_COOLDOWN"
ok "Code written"

step "4/4: TEST"
if [ -f "requirements.txt" ]; then
    pip install -q -r requirements.txt
    pip install -q pytest
    pytest tests/ -v 2>&1 | tee test.log && ok "Tests passed" || warn "Tests failed"
fi

git add -A && git commit -m "feat: $PROMPT" 2>/dev/null || true
echo -e "\n${G}✅ Done: $WORKDIR${N}\n"
