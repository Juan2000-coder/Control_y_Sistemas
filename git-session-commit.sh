#!/bin/bash
# git-session-commit.sh
# Usage: ./git-session-commit.sh "mensaje opcional"
# Commitea el progreso de la sesión actual

cd "$(dirname "$0")/.."

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
MSG="${1:-avance sesión $(date +%Y-%m-%d)}"

git add -A
git status --short
git commit -m "$MSG"
echo "✅ Commiteado en $BRANCH: $MSG"
