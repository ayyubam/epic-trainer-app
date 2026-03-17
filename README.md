# Epic EMR Trainer Assistant

A web app for Epic EMR trainers featuring hospital systems, resources, FAQs, and an AI-powered chat assistant that can search the web for current information.

---

## Repository Structure

```
/
├── index.html                        ← Main app (single file)
├── netlify.toml                      ← Netlify build & deployment config
├── netlify/
│   └── functions/
│       └── ai-chat.js                ← Serverless function (proxies Anthropic API)
└── .github/
    └── workflows/
        └── deploy.yml                ← GitHub Actions auto-deploy workflow
```

---

## One-Time Setup (Do This Once)

### Step 1 — Get an Anthropic API Key

1. Go to [https://console.anthropic.com](https://console.anthropic.com)
2. Sign in or create a free account
3. Go to **API Keys** → **Create Key**
4. Copy the key (starts with `sk-ant-...`) — save it somewhere safe, you won't see it again

---

### Step 2 — Add the API Key to Netlify

1. Go to [https://app.netlify.com](https://app.netlify.com) and open your site
2. Click **Site configuration** → **Environment variables**
3. Click **Add a variable**
4. Set:
   - **Key:** `ANTHROPIC_API_KEY`
   - **Value:** *(paste your key from Step 1)*
5. Click **Save**
6. Go to **Deploys** → **Trigger deploy** → **Deploy site** (so the new variable takes effect)

---

### Step 3 — Add GitHub Secrets (for auto-deploy)

These let GitHub Actions deploy to Netlify automatically on every push.

1. In your GitHub repo, go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** and add these two:

| Secret Name | Where to find it |
|---|---|
| `NETLIFY_AUTH_TOKEN` | Netlify → User settings → Applications → **New access token** |
| `NETLIFY_SITE_ID` | Netlify → Site configuration → **Site ID** (the long string) |

---

### Step 4 — Push to GitHub

Add all files to your repo and push:

```bash
git add .
git commit -m "Add full deployment setup"
git push origin main
```

GitHub Actions will automatically deploy to Netlify. You can watch the progress in the **Actions** tab of your GitHub repo.

---

## How It Works

### AI Chat
- The floating **Ask AI Trainer** button opens an in-page chat panel
- User messages are sent to `/.netlify/functions/ai-chat` (your serverless function)
- The function securely adds your `ANTHROPIC_API_KEY` and calls the Anthropic API
- Web search is enabled — the AI can look up current Epic news and documentation
- **Your API key is never exposed to the browser**

### File Uploads
- Users can upload files via the Resources tab or My Profile → My Uploads
- File metadata is stored in `localStorage` (persists across sessions in the same browser)
- Uploaded files appear in both the Resources tab and the My Uploads profile tab

### Saved Items
- Hospitals, resources, and FAQs can be saved to the user's profile
- AI responses can be saved with the "Save Response" button
- All saved data persists in `localStorage`

---

## Making Changes

Edit `index.html` locally, then:

```bash
git add index.html
git commit -m "Your change description"
git push origin main
```

GitHub Actions deploys automatically within ~30 seconds.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| AI chat says "API key not configured" | Add `ANTHROPIC_API_KEY` in Netlify environment variables (Step 2) |
| GitHub Actions fails | Check that `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` secrets are set (Step 3) |
| Site not updating after push | Check the Actions tab in GitHub for error details |
| AI responses are slow | Normal — web search adds a few seconds. The "Searching and thinking..." indicator shows it's working |
