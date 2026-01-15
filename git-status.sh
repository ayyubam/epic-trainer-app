#!/bin/bash
# git-status.sh - Check Git status

echo "🔍 EPIC TRAINER STATUS"
echo "======================"
cd /Users/menelikmitchell/Desktop/EPIC-TRAINER-APP

# Branch info
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Branch: $CURRENT_BRANCH"
echo ""

# Changes
echo "📝 Uncommitted changes:"
git status --short
echo ""

# Recent commits
echo "📋 Recent commits:"
git log --oneline -3
echo ""

# Remote info
echo "🌐 Remotes:"
git remote -v
echo ""

# Deployment info
echo "🚀 Deployment:"
echo "   Netlify: https://epictrainerassist.netlify.app/"
echo "   GitHub: https://github.com/ayyubam/epic-trainer-app"
echo ""

echo "🛠️  Available scripts:"
echo "   ./git-status.sh        - This status check"
echo "   ./backup-deploy.sh     - Backup and deploy options"
echo "   ./fix-git-and-deploy.sh - Fix Git issues and deploy"
