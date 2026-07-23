# Rich Callbacks — Reference

Rich callbacks fetch structured third-party data for **entity queries** —
weather, stocks, sports scores, currency, dictionary, package tracking, etc.
It's a **two-step** flow: search with the callback enabled, then fetch the
rich payload using the returned callback key.

Load this only when working an entity query and `SKILL.md` → Workflow step 5
isn't enough.

## The two-step flow

### Step 1 — search with rich callback enabled

```bash
curl -s "https://api.search.brave.com/res/v1/web/search?q=weather+san+francisco&enable_rich_callback=true" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
```

The response includes a `rich.hint` object when a rich result is available:

```json
"rich": {
  "type": "rich",
  "hint": {
    "vertical": "weather",
    "callback_key": "abc123..."
  }
}
```

If `rich.hint` is absent, the query has no rich data — fall back to normal
`web.results`.

### Step 2 — fetch the rich payload

```http
GET https://api.search.brave.com/res/v1/web/rich?callback_key=<callback_key>
```

```bash
curl -s "https://api.search.brave.com/res/v1/web/rich?callback_key=abc123..." \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
```

## Rich callback endpoint

| Parameter | Type | Required | Description |
|--|--|--|--|
| `callback_key` | string | Yes | Callback key from the web search `rich.hint.callback_key` field |

## Supported rich verticals

Calculator, Definitions, Unit Conversion, Unix Timestamp, Package Tracker,
Stock, Currency, Cryptocurrency, Weather, American Football, Baseball,
Basketball, Cricket, Football/Soccer, Ice Hockey, Web3, Translator.

## When to use

Reach for rich callbacks when the query is an **entity with a knowledge panel**:

| Query shape                         | Vertical              |
| ----------------------------------- | --------------------- |
| weather + place                     | Weather               |
| ticker symbol, "AAPL price"         | Stock                 |
| "USD to EUR", currency conversion   | Currency              |
| "49ers score", match results        | Sports verticals      |
| "define …", word meaning            | Definitions           |
| unit/math/timestamp conversions     | Calculator / Conversion |
| package tracking number             | Package Tracker       |

For general informational queries, plain `web/search` is the right call.
