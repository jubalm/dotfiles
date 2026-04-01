# Claude CLI Wrapper (`cld`)

## Purpose

Bash wrapper that provides sane defaults for `claude` CLI.

## What It Does

- Sets `ENABLE_LSP_TOOL=1` (Claude CLI enables LSP)
- Sets `CLAUDE_CODE_NO_FLICKER=1` (disables terminal flicker)
- Always passes `--allow-dangerously-skip-permissions`
- Merges multiple MCP server configs into one `--mcp-config`
- Loads provider env vars from `~/.claude/providers.json`
- Deep-merges `~/.claude/settings.local.json` with provider config

## Config Types

**MCP Server Config** (`~/.claude/servers/*.json`):
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

**Bundles** merge multiple servers (e.g., `dev.json` = chrome-devtools + context7).

**Settings Config** (`~/.claude/settings.local.json`):
- Claude CLI native settings: permissions, model, statusline
- Follows official schema
- Deep-merged with provider config (local takes precedence)

**Provider Config** (`~/.claude/providers.json`):
- Custom format for API endpoint switching
- Structure: `{ "name": { "env": {...}, "model": "..." } }`
- Env vars exported, rest merged into settings

## Implementation

`bin/cld` bash script:
1. Parses `-m` (MCP servers), `-p` (provider)
2. Resolves shorthands (p→playwright, c→chrome-devtools, etc.)
3. Merges JSON configs with `jq`
4. Exports provider env vars
5. Writes temp files, executes `claude`

## Shorthand Flags

p=playwright, c=chrome-devtools, x=context7, a=astro-docs, f=figma
