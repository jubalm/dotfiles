---
name: web-search
description: USE FOR web search. Returns ranked results with snippets, URLs, thumbnails. Supports freshness filters, SafeSearch, Goggles for custom ranking, pagination. Primary search endpoint.
---

# Web Search

Brave Search API. Five endpoints — web, news, images, videos, and rich
callbacks for entity panels (weather, stocks, sports, currency). The API key
is read from the macOS Keychain — never from an env var or hardcode.

## Workflow

1. **Ensure the key is registered.** `$SKILL_DIR` = absolute path to this skill
   directory.
   ```bash
   node "$SKILL_DIR/scripts/get-key.js"
   ```
   - exit 0 → key present, proceed
   - exit !=0 → key missing. Bootstrap once via `references/authenticate.md`
     (signup → key → keychain), then retry. Do **not** fall back to env vars.

2. **Pick the endpoint by query shape:**
   | Query                                          | Endpoint          |
   | ---------------------------------------------- | ----------------- |
   | general web, factual, "how do I…"              | web search        |
   | current events, recent reporting               | news search       |
   | pictures, images                               | image search      |
   | videos (with duration, creator metadata)       | video search      |
   | entity w/ knowledge panel (weather, stock,     | rich callback     |
   | score, currency, dictionary)                   | (two-step)        |

   Rule of thumb: a dedicated endpoint beats `result_filter` on web search when
   the intent is clearly one type (news/images/videos). Reach for rich callbacks
   only for entity/knowledge-panel queries.

3. **Inline the key on every request** via command substitution — never assign,
   print, or log it:
   ```bash
   -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
   ```

4. **Run; parse the result array** for the endpoint:
   - web → `web.results[].{title, url, description, age}`
   - news → `results[]` (news-shaped; recency-ranked)
   - images → `results[]` (thumbnail + original image URL)
   - videos → `results[]` (duration, creator, publisher)

   Behavior knobs (where supported by the endpoint — see references for which):
   - recency-sensitive → `freshness` (`pd`/`pw`/`pm`/`py` or date range)
   - page deeper → `count` + `offset`; widen `q` before deep paging
   - region/language → `country`, `search_lang`
   - entity query → follow `rich.hint.callback_key` to step 5

5. **Entity query (rich callback, two-step):**
   ```bash
   # a) web search with rich callback enabled → returns rich.hint.callback_key
   curl -s "https://api.search.brave.com/res/v1/web/search?q=weather+san+francisco&enable_rich_callback=true" \
     -H "Accept: application/json" \
     -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
   # b) fetch the rich payload with the callback key
   curl -s "https://api.search.brave.com/res/v1/web/rich?callback_key=KEY" \
     -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
   ```

## Minimal examples

```bash
# web search (basic)
curl -s "https://api.search.brave.com/res/v1/web/search?q=python+web+frameworks" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
```

```bash
# web search (parameterized: country, language, freshness, safesearch, count, result_filter)
curl -s "https://api.search.brave.com/res/v1/web/search" \
  -H "Accept: application/json" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")" \
  -G \
  --data-urlencode "q=rust programming tutorials" \
  --data-urlencode "country=US" \
  --data-urlencode "search_lang=en" \
  --data-urlencode "freshness=pm" \
  --data-urlencode "safesearch=moderate" \
  --data-urlencode "count=10"
```

```bash
# news / images / videos — same shape, swap the path
curl -s "https://api.search.brave.com/res/v1/news/search?q=space+launch&freshness=pw" \
  -H "X-Subscription-Token: $(node "$SKILL_DIR/scripts/get-key.js")"
```

Both GET and POST are supported on web/news/videos (POST for long queries or
inline Goggles). Add `Accept-Encoding: gzip` to compress large responses.

## Directives

- **Inline the key via `$(...)` on every request.** Never assign it to a
  variable, echo/print it, write it to a file, or commit it. It exists only in
  the executing process.
- **`$SKILL_DIR` must be an absolute path.** A relative path breaks when the
  request runs from a different working directory.
- **If the key is missing, bootstrap via `references/authenticate.md`.** Do not
  fall back to `${BRAVE_SEARCH_API_KEY}` or hardcode the key.
- **Keep request volume economical.** Widen `q` or raise `count` before
  paginating; don't repeat identical queries in-session; skip the call when you
  already know the answer confidently.
- **Match the endpoint to the intent.** Prefer the dedicated news/images/videos
  endpoint over `web/search` + `result_filter` when the query is clearly one
  type.

> Full parameter tables, response-field references, search operators, Goggles
> syntax, and rich-callback verticals live in `references/`:
> `references/web-search.md`, `references/news-search.md`,
> `references/images-search.md`, `references/videos-search.md`,
> `references/rich-callbacks.md`. Load the relevant one only if a minimal
> example above isn't enough.
