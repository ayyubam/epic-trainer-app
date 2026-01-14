# CHECK NETLIFY DEPLOYMENT LOGS

## 1. View current deployment:
https://app.netlify.com/sites/epictrainerassist/deploys

## 2. Check for errors:
1. Click on the latest deploy
2. Click "Deploy log"
3. Look for errors in red

## Common Netlify issues:
1. **Build timeout** - Increase in netlify.toml
2. **Missing files** - Check publish directory
3. **Cache issues** - Clear cache and redeploy
4. **CDN propagation** - Wait 5-10 minutes

## Force CDN refresh:
1. Add query string: https://epictrainerassist.netlify.app/?v=2
2. Different browser or incognito
3. Use VPN to check from different location

## Verify correct version is served:
curl -s https://epictrainerassist.netlify.app/ | grep -c "AI Assistant"
# Should return at least 1
