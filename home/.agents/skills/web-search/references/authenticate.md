# Authenticate — Brave Search API

Full bootstrap: create a Brave account, subscribe to the Search plan, generate an API key, register it in the macOS Keychain, and verify. Run this **only** when `scripts/get-key.js` exits non-zero (the key is missing).

The key never lives in a file, env var, or git. It is stored once in the Keychain and read back via `scripts/get-key.js` on every request.

## Prerequisites

- macOS (the Keychain store is macOS-only). On Linux/WSL, store the key in your platform's secret store and adapt `get-key.js`.
- `node` on `PATH` (the reader is Node).
- A browser to complete signup.

## Step 1 — Create an account & subscribe

1. Go to **https://api.search.brave.com** → **Register**. Create a Brave API account.
2. Open the dashboard: **https://api-dashboard.search.brave.com/app/subscriptions/subscribe**
3. Subscribe to the **Search** plan (Free tier is sufficient for skill usage; it includes web search with rate limits).

If the dashboard shows an existing **Search** subscription, skip ahead.

## Step 2 — Generate an API key

1. Go to **https://api-dashboard.search.brave.com/app/keys**
2. **Create new key** → copy the value immediately. Brave shows it **once**; there is no "show key" later.

> If you lose it, revoke and create a new one. Old keys stop working on revoke.

## Step 3 — Register the key in the Keychain

Store the key as a generic-password item. Default service `brave-search`, account `$USER`:

```bash
security add-generic-password -a "$USER" -s brave-search -w "PASTE_YOUR_KEY_HERE"
```

Confirm the prompt does not print the value back. The `-w` flag stores the secret; nothing is echoed.

### Stored it differently?

`get-key.js` reads service/account from env vars if you used non-defaults:

```bash
security add-generic-password -a "<your-acct>" -s "<your-service>" -w "PASTE_YOUR_KEY_HERE"
```

Then always invoke the reader with the same overrides:

```bash
BRAVE_KEYCHAIN_ACCOUNT="<your-acct>" BRAVE_KEYCHAIN_SERVICE="<your-service>" \
  node "$SKILL_DIR/scripts/get-key.js"
```

### Re-registering (key rotated / wrong value stored)

Delete first, then re-add:

```bash
security delete-generic-password -a "$USER" -s brave-search
security add-generic-password -a "$USER" -s brave-search -w "NEW_KEY"
```

## Step 4 — Verify

```bash
node "$SKILL_DIR/scripts/get-key.js" >/dev/null && echo "key registered ✓"
```

Then a live call against the API:

```bash
curl -s "https://api.search.brave.com/res/v1/web/search?q=test&count=1" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
```

Expect a JSON body with `"type": "search"` and a `web.results` array. A `422` / `"x-subscription-token" ... "missing"` means the substitution yielded nothing — re-run Step 3. A `401`/`403` means the key is wrong, revoked, or on the wrong plan — re-run Step 2.

## Troubleshooting

| Symptom | Cause | Fix |
|--|--|--|
| `get-key.js` exits 1, "no keychain item found" | Step 3 not run, or service/account mismatch | Run Step 3; if non-defaults, pass `BRAVE_KEYCHAIN_ACCOUNT`/`BRAVE_KEYCHAIN_SERVICE` |
| `get-key.js` exits 2, "$USER is unset" | Shell has no `$USER` | `export BRAVE_KEYCHAIN_ACCOUNT=<acct>` |
| Keychain prompts for permission on every call | Item in a keychain the agent can't silently read | Re-add to the login keychain: `security add-generic-password -a "$USER" -s brave-search -w "..."` |
| API returns `401`/`403` | Key wrong/revoked, or not on Search plan | Step 2 (regenerate) + check subscription in Step 1 |
| API returns `429` | Free-tier rate limit hit | Wait, or upgrade plan in dashboard |

## Security notes

- The key is written **only** to the Keychain. Never `echo`, `printf`, assign to a shell variable, or commit it.
- `get-key.js` emits the value to stdout **only** so it can be captured by command substitution directly into the request header.
- Rotate by revoking in the dashboard (Step 2) + re-registering (Step 3, "Re-registering").
