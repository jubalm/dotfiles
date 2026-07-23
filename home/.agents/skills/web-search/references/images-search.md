# Image Search — Reference

Full reference for `GET https://api.search.brave.com/res/v1/images/search`.
Dedicated image endpoint — returns image results with source URLs and
thumbnails. Prefer this over web search when the user wants pictures.

Load this only when working an image query and `SKILL.md` → Workflow isn't enough.

Authentication: `X-Subscription-Token` header, sourced via the keychain reader
(`$(node "$SKILL_DIR/scripts/get-key.js")`).

## Endpoint

```http
GET https://api.search.brave.com/res/v1/images/search
```

## Parameters

| Parameter | Type | Required | Default | Description |
|--|--|--|--|--|
| `q` | string | **Yes** | - | Search query (1-400 chars, max 50 words) |
| `country` | string | No | `US` | Result country (2-letter code or `ALL`) |
| `search_lang` | string | No | `en` | Language preference (2+ char language code) |
| `safesearch` | string | No | `strict` | `off` (no filtering) / `strict` (drops adult content) |
| `count` | int | No | `50` | Results per page (**1-200**) |
| `spellcheck` | bool | No | `true` | If true, the altered query is always used |

> Note the wider limits vs. web/news: `count` up to **200**, `safesearch`
> only has `off`/`strict` (no `moderate`). There is no `offset`/pagination,
> `freshness`, or `goggles` on this endpoint.

## Example

```bash
curl -s "https://api.search.brave.com/res/v1/images/search" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")" \
  -G \
  --data-urlencode "q=redwood trees" \
  --data-urlencode "count=20"
```

## When to use this vs. web search

- **Use image search** when the user wants pictures — thumbnails, original
  image URLs, source pages.
- **Use web search** for pages/text; its `result_filter=videos`/`news` subsets
  don't cover standalone image results.
