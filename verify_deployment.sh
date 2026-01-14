#!/bin/bash
echo "=== VERIFYING DEPLOYMENT ==="
echo "Testing: https://epictrainerassist.netlify.app/"
echo ""

# Check if AI Assistant is present (key feature)
if curl -s https://epictrainerassist.netlify.app/ | grep -q "AI Assistant"; then
    echo "✅ AI Assistant present"
else
    echo "❌ AI Assistant MISSING - wrong version deployed"
fi

# Check if upload buttons are present
if curl -s https://epictrainerassist.netlify.app/ | grep -q "Upload Hospital Data"; then
    echo "✅ Upload buttons present"
else
    echo "❌ Upload buttons MISSING"
fi

# Check HTTP headers for cache
echo ""
echo "=== CHECKING CACHE HEADERS ==="
curl -I https://epictrainerassist.netlify.app/ | grep -i "cache-control\|pragma"

echo ""
echo "=== RECOMMENDED ACTIONS ==="
echo "If wrong version still showing:"
echo "1. Clear browser cache (Ctrl+Shift+R)"
echo "2. Use incognito window"
echo "3. Wait 5 minutes for CDN"
echo "4. Use manual ZIP deploy"
