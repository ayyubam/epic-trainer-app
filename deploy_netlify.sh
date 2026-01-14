#!/bin/bash

# Epic EMR Trainer Assistant - Netlify Deployment Script

echo "🚀 DEPLOYING EPIC EMR TRAINER ASSISTANT TO NETLIFY"
echo "=================================================="

# Create necessary files for Netlify
echo "📁 Creating Netlify configuration files..."

# Create netlify.toml
cat > netlify.toml << 'NETLIFY'
[build]
  publish = "."
  command = "echo 'Deploying Epic EMR Trainer Assistant...'"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Cache-Control = "public, max-age=3600"
NETLIFY

# Create package.json if it doesn't exist
if [ ! -f "package.json" ]; then
  cat > package.json << 'PKGJSON'
{
  "name": "epic-emr-trainer-assistant",
  "version": "1.0.0",
  "description": "Epic EMR Trainer Assistant - Comprehensive training platform",
  "main": "index.html",
  "scripts": {
    "start": "echo 'Open index.html in browser'",
    "deploy": "netlify deploy --prod"
  },
  "keywords": ["epic", "emr", "training", "healthcare"],
  "author": "Epic Trainer Team",
  "license": "MIT"
}
PKGJSON
fi

# Create README.md
cat > README.md << 'README'
# Epic EMR Trainer Assistant

A comprehensive training platform for Epic EHR systems with AI assistant, training simulator, and go-live support tools.

## Features
- 🏥 Hospital database with 50+ US hospitals
- 🤖 AI Assistant for Epic implementation questions
- 🎓 Training Simulator for hands-on practice
- 👥 Staffing Calculator for go-live planning
- 📊 Analytics Dashboard for training metrics
- 🔐 User authentication & premium features
- 💾 File upload/download/view capabilities

## Live Demo
[https://epictrainerassist.netlify.app](https://epictrainerassist.netlify.app)

## Demo Login
- Email: `demo@epictrainer.org`
- Password: `epicdemo123`

## Technologies
- HTML5, CSS3, JavaScript
- Font Awesome Icons
- LocalStorage for data persistence
- Netlify for hosting

## Deployment
This site is automatically deployed to Netlify when changes are pushed to the main branch.
README

echo "✅ Configuration files created"

# Check if index.html exists
if [ ! -f "index.html" ]; then
  echo "❌ ERROR: index.html not found!"
  echo "Creating a basic index.html file..."
  
  # Create a simple index.html if it doesn't exist
  cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Epic EMR Trainer Assistant</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            padding: 50px; 
            background: #f5f0fa;
        }
        h1 { color: #4B286D; }
        .container { 
            background: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Epic EMR Trainer Assistant</h1>
        <p>Please copy your HTML content to this file.</p>
        <p>Run: <code>cp epic_emr_trainer_assistant.html index.html</code></p>
    </div>
</body>
</html>
HTML
  echo "📄 Basic index.html created. Please copy your HTML file to index.html"
else
  echo "✅ index.html found and ready for deployment"
fi

# Initialize git if not already
if [ ! -d ".git" ]; then
  echo "📦 Initializing git repository..."
  git init
  git add .
  git commit -m "Initial commit: Epic EMR Trainer Assistant"
fi

# Check for Netlify CLI
echo "🔍 Checking for Netlify CLI..."
if ! command -v netlify &> /dev/null; then
  echo "📥 Installing Netlify CLI..."
  npm install -g netlify-cli
fi

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
node_modules/
.env
.DS_Store
*.log
netlify/functions/
GITIGNORE

echo ""
echo "=================================================="
echo "📝 DEPLOYMENT OPTIONS:"
echo "=================================================="
echo ""
echo "Option 1: Deploy to Netlify using CLI"
echo "   Run: netlify deploy --prod"
echo ""
echo "Option 2: Connect to GitHub and auto-deploy"
echo "   1. Push to GitHub:"
echo "      git remote add origin YOUR_REPO_URL"
echo "      git push -u origin main"
echo "   2. Connect at: https://app.netlify.com"
echo ""
echo "Option 3: Drag & drop folder to Netlify"
echo "   Visit: https://app.netlify.com/drop"
echo ""
echo "=================================================="
echo "🌐 Your site will be available at:"
echo "   https://epictrainerassist.netlify.app"
echo "   (or your custom Netlify subdomain)"
echo "=================================================="
echo ""
echo "To deploy immediately, run:"
echo "   netlify deploy --prod"
echo ""
echo "🎉 Deployment setup complete!"
