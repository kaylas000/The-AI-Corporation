#!/bin/bash
set -e

echo "🔄 Installing AI Agent System..."

# Проверяем, что мы в репо The-AI-Corporation
if [ ! -f ".bashrc" ]; then
    echo "❌ Error: Run this from The-AI-Corporation repo"
    exit 1
fi

# Устанавливаем aider (если нет)
if ! command -v aider &> /dev/null; then
    pip install -q aider-chat
fi

# Копируем bashrc
cp .bashrc ~/.bashrc

# Копируем aider config
cp .aider.conf.yml ~/.aider.conf.yml 2>/dev/null || true

# Копируем agent-system
rm -rf ~/.agent
cp -r .agent-system ~/.agent 2>/dev/null || mkdir -p ~/.agent

# Делаем скрипты исполняемыми
chmod +x ~/.agent/agent.sh 2>/dev/null || true
chmod +x ~/.agent/scripts/*.sh 2>/dev/null || true
chmod +x ~/.agent/ai/*.sh 2>/dev/null || true

# Применяем bashrc
source ~/.bashrc

echo "✅ System installed! Type: help-ai"
