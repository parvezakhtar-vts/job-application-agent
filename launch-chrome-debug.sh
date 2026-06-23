#!/bin/bash
# Launch Chrome with remote debugging using ipmob profile
# Run this BEFORE using Puppeteer MCP's puppeteer_connect_active_tab tool

PROFILE_SRC="$HOME/Library/Application Support/Google/Chrome/Profile 5"
TMPDIR="/tmp/chrome-puppeteer"
PORT=9222

# Kill existing Chrome
pkill -9 -f "Google Chrome" 2>/dev/null
sleep 2

# Copy ipmob profile to temp dir (avoids SingletonLock conflict)
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
cp -a "$PROFILE_SRC" "$TMPDIR/Default"
cp "$HOME/Library/Application Support/Google/Chrome/Local State" "$TMPDIR/" 2>/dev/null

# Launch Chrome with debugging
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=$PORT \
  --user-data-dir="$TMPDIR" \
  --no-first-run \
  --no-default-browser-check &

sleep 3

# Verify
if curl -s "http://localhost:$PORT/json/version" | grep -q "webSocketDebuggerUrl"; then
  echo "✅ Chrome running with ipmob profile on port $PORT"
else
  echo "❌ Failed to start Chrome with debugging"
  exit 1
fi
