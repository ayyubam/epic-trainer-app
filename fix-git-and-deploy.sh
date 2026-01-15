#!/bin/bash
# fix-git-and-deploy.sh - Fix Git issues and deploy properly

echo "🛠️  Fixing Git and Deploying"
echo "============================"

cd /Users/menelikmitchell/Desktop/EPIC-TRAINER-APP

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"
echo ""

# Step 1: Backup
echo "📦 Creating backup..."
BACKUP="backup-$(date +%Y%m%d-%H%M%S).html"
cp index.html "$BACKUP"
echo "✅ Backup: $BACKUP"
echo ""

# Step 2: Fix main branch if needed
echo "🔧 Checking main branch status..."
git checkout main

# Check if main has diverged
if ! git pull origin main 2>/dev/null; then
    echo "⚠️  Main branch has diverged. Fixing..."
    echo "   Resetting local main to match remote..."
    git fetch origin
    git reset --hard origin/main
    echo "✅ Main branch fixed"
else
    echo "✅ Main branch is up to date"
fi
echo ""

# Step 3: Merge feature branch into main
echo "🔄 Merging changes from $CURRENT_BRANCH to main..."
git merge "$CURRENT_BRANCH" --no-edit

# Step 4: Deploy to Netlify
echo "🚀 Deploying to Netlify..."
git add .
git commit -m "Deploy to Netlify: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo ""
echo "✅ DEPLOYED SUCCESSFULLY!"
echo ""
echo "🌐 Netlify: https://epictrainerassist.netlify.app/"
echo "⏰ Will update in 1-2 minutes"
echo ""
echo "📊 Check deployment status:"
echo "   https://app.netlify.com/sites/epictrainerassist/deploys"
