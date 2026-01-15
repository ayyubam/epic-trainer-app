#!/bin/bash
# backup-deploy.sh - Safe backup and deploy with options

echo "🚀 EPIC TRAINER DEPLOYMENT"
echo "=========================="
cd /Users/menelikmitchell/Desktop/EPIC-TRAINER-APP

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"
echo ""

# Backup
echo "📦 Creating backup..."
BACKUP="epic-backup-$(date +%Y%m%d-%H%M%S).html"
cp index.html "$BACKUP"
echo "✅ Backup: $BACKUP"
echo ""

echo "🎯 Deployment options:"
echo "1. Save backup only (no deploy)"
echo "2. Push to $CURRENT_BRANCH (GitHub only)"
echo "3. Deploy to Netlify (merge to main)"
echo ""

read -p "Choose option (1-3): " choice
echo ""

case $choice in
    1)
        echo "✅ Backup saved: $BACKUP"
        echo "   No changes pushed"
        ;;
        
    2)
        echo "📤 Pushing to $CURRENT_BRANCH branch..."
        git add .
        git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
        git push origin "$CURRENT_BRANCH"
        echo "✅ Pushed to GitHub!"
        echo "   Branch: $CURRENT_BRANCH"
        ;;
        
    3)
        echo "🌐 Preparing Netlify deployment..."
        
        # Save current changes
        git add .
        git commit -m "Save changes before deploy: $(date)"
        
        # Switch to main and update it
        echo "🔄 Updating main branch..."
        git checkout main
        git pull origin main
        
        # Merge feature branch
        echo "🔀 Merging $CURRENT_BRANCH into main..."
        git merge "$CURRENT_BRANCH" --no-edit
        
        # Deploy
        echo "🚀 Deploying to Netlify..."
        git push origin main
        
        echo ""
        echo "✅ DEPLOYED TO NETLIFY!"
        echo "🌐 https://epictrainerassist.netlify.app/"
        echo ""
        echo "⏰ Site updates in 1-2 minutes"
        echo "📊 Status: https://app.netlify.com/sites/epictrainerassist/deploys"
        
        # Go back to feature branch
        git checkout "$CURRENT_BRANCH"
        ;;
        
    *)
        echo "❌ Invalid option"
        ;;
esac

echo ""
echo "📌 GitHub: https://github.com/ayyubam/epic-trainer-app"
echo "📌 Netlify: https://epictrainerassist.netlify.app/"
