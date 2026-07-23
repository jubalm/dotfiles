# Video Search — Reference

Full reference for `GET/POST https://api.search.brave.com/res/v1/videos/search`.
Dedicated video endpoint — returns video results with duration, creator,
publisher, and thumbnail metadata. Prefer this over web search when the user
wants videos.

Load this only when working a video query and `SKILL.md` → Workflow isn't enough.

Authentication: `X-Subscription-Token` header, sourced via the keychain reader
(`$(node "$SKILL_DIR/scripts/get-key.js")`).

## Endpoint

```http
GET  https://api.search.brave.com/res/v1/videos/search
POST https://api.search.brave.com/res/v1/videos/search
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
| `safesearch` | string | No | `moderate` | `off` / `moderate` (filters explicit, allows adult domains) / `strict` |
| `freshness` | string | No | - | `pd`/`pw`/`pm`/`py` or `YYYY-MM-DDtoYYYY-MM-DD` |
| `spellcheck` | bool | No | `true` | If true, the altered query is always used |
| `include_fetch_metadata` | bool | No | `false` | Include `fetched_content_timestamp` |
| `operators` | bool | No | `true` | Apply search operators |

> Note: video search has no `goggles` or `extra_snippets` param (unlike
> web/news). `safesearch` defaults to `moderate` (vs. `strict` on news/images).

## Example

```bash
curl -s "https://api.search.brave.com/res/v1/videos/search" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")" \
  -G \
  --data-urlencode "q=rust async programming" \
  --data-urlencode "count=10"
```

## When to use this vs. web search

- **Use video search** when the user wants videos — duration, creator,
  publisher, thumbnail metadata shape the result.
- **Use web search** for pages/text; its `result_filter=videos` subset is a
  lighter view than this dedicated endpoint.
