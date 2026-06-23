# Puppeteer MCP: Connecting to Existing Chrome Profile

## Goal
Use Puppeteer MCP to control the browser with an existing Chrome profile (ipmob / Profile 5) so that login sessions/cookies are preserved.

## Problem
The default Puppeteer MCP (`@modelcontextprotocol/server-puppeteer`) launches a **new** browser instance. This means:
- No existing cookies/sessions
- Cannot login to sites that require 2FA or complex auth flows
- User must re-authenticate every time

## What Was Tried (and failed)

### 1. `executablePath` with system Chrome (✅ partial success)
```json
{
  "executablePath": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "headless": false
}
```
**Result:** Chrome launches, but with a fresh/empty profile — no login state.

### 2. `--user-data-dir` pointing to actual Chrome profile (❌ failed)
```json
{
  "args": ["--user-data-dir=/Users/parvez.akhtar/Library/Application Support/Google/Chrome", "--profile-directory=Profile 5"],
  "executablePath": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
  "headless": false
}
```
**Result:** `Failed to create SingletonLock` — Chrome was already running with that profile. Only one process can use a user-data-dir at a time.

### 3. Killed Chrome, launched with same user-data-dir (❌ failed)
```json
{
  "args": ["--user-data-dir=...", "--profile-directory=Profile 5", "--no-first-run"],
  "executablePath": "...",
  "headless": false
}
```
**Result:** `Timed out after 30000 ms while waiting for the WS endpoint URL to appear in stdout!`  
The standard Puppeteer MCP expects Chrome to output a WebSocket URL to stdout, but Chrome with an existing user-data-dir doesn't do this reliably (extensions, startup pages, etc. interfere).

### 4. `browserURL` option to connect to running Chrome (❌ failed)
```json
{
  "browserURL": "http://localhost:9222"
}
```
**Result:** `Could not find Chrome (ver. 131.0.6778.204)` — the `@modelcontextprotocol/server-puppeteer` MCP doesn't support `browserURL` at all. It always tries to find/launch its own Chrome binary first.

### 5. Launched Chrome with `--remote-debugging-port=9222` from full user-data-dir (❌ failed)
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir="/Users/parvez.akhtar/Library/Application Support/Google/Chrome" \
  --profile-directory="Profile 5"
```
**Result:** Chrome launched but port 9222 was never actually opened. `lsof -i :9222` showed nothing listening. This is a known macOS Chrome issue when using the full real user-data-dir.

### 6. Copied profile to temp dir, launched with debugging (✅ Chrome works, ❌ MCP can't connect)
```bash
cp -a "Profile 5" /tmp/chrome-puppeteer/Default
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chrome-puppeteer \
  --no-first-run
```
**Result:** Chrome launched successfully with debugging port active (`curl localhost:9222/json/version` works). But the Puppeteer MCP still can't connect because it doesn't support `browserURL`/`browserWSEndpoint` connection modes.

## Solution

Replace the default Puppeteer MCP with [`puppeteer-mcp-server`](https://github.com/merajmehrabi/puppeteer-mcp-server) which has a `puppeteer_connect_active_tab` tool.

### Setup Steps

1. **Launch Chrome with remote debugging:**
   ```bash
   # Kill existing Chrome first
   pkill -9 -f "Google Chrome"
   
   # Copy profile to avoid SingletonLock issues
   TMPDIR="/tmp/chrome-puppeteer"
   rm -rf "$TMPDIR"
   mkdir -p "$TMPDIR"
   cp -a "$HOME/Library/Application Support/Google/Chrome/Profile 5" "$TMPDIR/Default"
   cp "$HOME/Library/Application Support/Google/Chrome/Local State" "$TMPDIR/"
   
   # Launch with debugging
   /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
     --remote-debugging-port=9222 \
     --user-data-dir="$TMPDIR" \
     --no-first-run --no-default-browser-check &
   ```

2. **Update `~/.kiro/settings/mcp.json`:**
   ```json
   {
     "mcpServers": {
       "puppeteer": {
         "command": "npx",
         "args": ["-y", "puppeteer-mcp-server"]
       }
     }
   }
   ```

3. **Restart Kiro** and use `puppeteer_connect_active_tab` to attach to the running Chrome.

## Key Insight
The `@modelcontextprotocol/server-puppeteer` only supports `puppeteer.launch()` mode. To connect to an existing browser (`puppeteer.connect()`), you need a different MCP server implementation.

## Caveat
The copied profile approach means cookies are a **snapshot** — new cookies/sessions created in the Puppeteer-controlled Chrome won't sync back to your main Chrome profile.
