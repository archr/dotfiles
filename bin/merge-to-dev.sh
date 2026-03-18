#!/bin/zsh

CURRENT=$(git branch --show-current)

echo "🔀 Merging '$CURRENT' into dev..."

git checkout dev && \
git fetch origin dev && \
git reset --hard origin/dev && \
git merge $CURRENT || { git checkout $CURRENT; exit 1; }

echo "\n📋 Commits to be pushed:"
git log origin/dev..dev --oneline

echo "\nPush to dev? (y/n)"
read -r CONFIRM
if [[ "$CONFIRM" == "y" ]]; then
  git push origin dev --no-verify
  echo "✅ Done!"
else
  echo "⚠️  Push cancelled. Still on dev with local merge."
fi

git checkout $CURRENT
