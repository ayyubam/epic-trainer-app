# MANUAL NETLIFY CACHE CLEAR INSTRUCTIONS

## OPTION 1: Trigger deploy with cache clear
1. Go to: https://app.netlify.com/sites/epictrainerassist/deploys
2. Click "Trigger deploy" (top right)
3. Select "Clear cache and deploy site"
4. Wait 2-3 minutes

## OPTION 2: Clear cache via Site Settings
1. Go to: https://app.netlify.com/sites/epictrainerassist/settings/deploys
2. Scroll to "Post processing"
3. Click "Clear cache"
4. Then trigger a new deploy

## OPTION 3: Use deploy hooks
1. Go to: https://app.netlify.com/sites/epictrainerassist/settings/deploys#deploy-hooks
2. Create a new deploy hook
3. Use curl to trigger: curl -X POST [YOUR_HOOK_URL]

## OPTION 4: Manual ZIP deploy (bypasses cache)
1. Create ZIP: zip -r correct_version.zip .
2. Go to: https://app.netlify.com/drop
3. Drag correct_version.zip to deploy
4. This completely bypasses any cache

## QUICK CHECK AFTER DEPLOY:
1. Open https://epictrainerassist.netlify.app/
2. Press Ctrl+Shift+R (hard refresh)
3. Check if AI Assistant button appears
4. Check browser console for errors (F12)
