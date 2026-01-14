#!/bin/bash

# Quick Deploy to Netlify

echo "🚀 Quick Deploy - Epic EMR Trainer Assistant"
echo "============================================"

# Check if we have the HTML file
if [ ! -f "epic_emr_trainer_assistant.html" ]; then
    echo "❌ ERROR: epic_emr_trainer_assistant.html not found!"
    echo "Please run the HTML creation script first."
    exit 1
fi

# Copy the HTML file to index.html
echo "📄 Copying HTML file to index.html..."
cp epic_emr_trainer_assistant.html index.html

# Create minimal netlify.toml
echo "⚙️  Creating Netlify configuration..."
cat > netlify.toml << 'TOML'
[build]
  publish = "."

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
TOML

# Check if Netlify CLI is installed
if ! command -v netlify &> /dev/null; then
    echo "📥 Installing Netlify CLI..."
    npm install -g netlify-cli
fi

echo ""
echo "============================================"
echo "🌐 READY TO DEPLOY!"
echo "============================================"
echo ""
echo "Choose deployment method:"
echo ""
echo "1. Deploy with Netlify CLI (Recommended)"
echo "   Command: netlify deploy --prod"
echo ""
echo "2. Manual deploy via Netlify Dashboard"
echo "   Steps:"
echo "   1. Go to https://app.netlify.com"
echo "   2. Drag & drop this folder"
echo "   3. Your site will be deployed!"
echo ""
echo "3. Connect to GitHub for auto-deploy"
echo "   Steps:"
echo "   1. Create GitHub repository"
echo "   2. Push your code:"
echo "      git init"
echo "      git add ."
echo "      git commit -m 'Deploy Epic Trainer'"
echo "      git branch -M main"
echo "      git remote add origin YOUR_REPO_URL"
echo "      git push -u origin main"
echo "   3. Connect repo in Netlify dashboard"
echo ""
echo "============================================"
echo "🎯 Your site will be live at:"
echo "   https://your-site-name.netlify.app"
echo "============================================"

# Ask if user wants to deploy now
read -p "Deploy now with Netlify CLI? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "🚀 Starting deployment..."
    netlify deploy --prod
else
    echo "📋 Deployment setup complete!"
    echo "Run 'netlify deploy --prod' when ready."
fi
