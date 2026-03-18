#!/bin/zsh

CURRENT=$(git branch --show-current)

echo "📥 Pulling main..."

git checkout main && \
git pull --rebase origin main && \

echo "✅ Done"
