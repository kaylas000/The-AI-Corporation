#!/bin/bash
set -e
echo "🔄 Installing AI Agent System..."

# Проверяем наличие aider
if ! command -v aider &> /dev/null; then
    pip install -q aider-chat
fi

# Копируем файлы
cp .bashrc ~/.bashrc
rm -rf ~/.agent
cp -r .agent-system ~/.agent

# Права на выполнение
chmod +x ~/.agent/agent.sh

# Применяем bashrc
source ~/.bashrc

echo "✅ Done! Type: help-ai"
