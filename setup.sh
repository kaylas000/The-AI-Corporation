#!/bin/bash
echo "🔄 Restoring AI System..."
pip install aider-chat -q
cp .bashrc ~/
cp .aider.conf.yml ~/ 2>/dev/null || true
cp -r .agent-system/ ~/.agent/ 2>/dev/null || true
chmod +x ~/.agent/agent.sh ~/.agent/scripts/*.sh ~/.agent/ai/*.sh 2>/dev/null || true
source ~/.bashrc
echo "✅ Done! Type: help-ai"
