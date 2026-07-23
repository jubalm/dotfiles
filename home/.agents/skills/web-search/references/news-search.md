# News Search — Reference

Full reference for `GET/POST https://api.search.brave.com/res/v1/news/search`.
Dedicated news endpoint — prefer this over `web/search` + `result_filter=news`
when you specifically want news articles, since it returns a richer,
news-shaped result set and supports news-specific ranking.

Load this only when working a news query and `SKILL.md` → Workflow isn't enough.

Authentication: `X-Subscription-Token` header, sourced via the keychain reader
(`$(node "$SKILL_DIR/scripts/get-key.js")`).

## Endpoint

```http
GET  https://api.search.brave.com/res/v1/news/search
POST https://api.search.brave.com/res/v1/news/search
```

## Parameters

| Parameter | Type | Required | Default | Description |
|--|--|--|--|--|
| `q` | string | **Yes** | - | Search query (1-400 chars, max 50 words) |
| `country` | string | No | `US` | Result country (2-letter code or `ALL`) |
| `search_lang` | string | No | `en` | Language preference (2+ char language code) |
| `ui_lang` | string | No | `en-US` | UI language (e.g., "en-US") |
| `count` | int | No | `20` | Results per page (**1-50**) |
| `offset` | int | No | `0` | Page offset (**0-9**); paginate with `count` |
| `safesearch` | string | No | `strict` | `off` / `moderate` (filter explicit) / `strict` (explicit + suggestive) |
| `freshness` | string | No | - | `pd`/`pw`/`pm`/`py` or `YYYY-MM-DDtoYYYY-MM-DD` |
| `spellcheck` | bool | No | `true` | If true, the altered query is always used |
| `extra_snippets` | bool | No | - | Up to 5 additional excerpts per result |
| `goggles` | string \| string[] | No | - | Custom re-ranking; URL or inline, up to 3 |
| `include_fetch_metadata` | bool | No | `false` | Include `fetched_content_timestamp` |
| `operators` | bool | No | `true` | Apply search operators |

> `freshness` is especially relevant for news — default to `pd` or `pw` for
> current events. See `web-search.md` → Freshness values for the full table.

## Example

```bash
curl -s "https://api.search.brave.com/res/v1/news/search" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")" \
  -G \
  --data-urlencode "q=space launch" \
  --data-urlencode "freshness=pw" \
  --data-urlencode "count=10"
```

## When to use this vs. web search

- **Use news search** when the intent is current events, recent reporting, or
  press coverage. The result set is news-shaped and ranked for recency.
- **Use web search** (`references/web-search.md`) for general factual or
  evergreen queries; it returns web pages broadly and can include a `news`
  subset via `result_filter=news` if you want both in one call.
