# Provider Switching Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add `-p <provider>` flag to `cld` script to switch between different LLM providers via environment variable configuration, plus `cld providers` command to list available providers.

**Architecture:** Extend the existing `cld` bash script to parse a new `-p` flag, load provider configuration from `~/.claude/providers.json`, and pass settings to Claude CLI. Add a `providers` subcommand that lists available providers and guides users to the example config file.

**Tech Stack:** Bash, jq (JSON parsing), Claude CLI `--settings` flag

---

## Task 1: Add example provider template to cld script

**Files:**
- Modify: `bin/cld` (add provider template constant in CONFIGURATION section)

**Step 1: Add EXAMPLE_PROVIDERS constant**

In the CONFIGURATION section (after `PROVIDERS_FILE` line), add:

```bash
# Example provider configurations (used to scaffold ~/.claude/providers.json.example)
read -r -d '' EXAMPLE_PROVIDERS << 'PROVIDERS_EOF' || true
{
  "zai": {
    "env": {
      "ANTHROPIC_AUTH_TOKEN": "your-zai-api-key",
      "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
      "API_TIMEOUT_MS": "3000000",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7"
    }
  },
  "ollama": {
    "env": {
      "ANTHROPIC_AUTH_TOKEN": "ollama",
      "ANTHROPIC_BASE_URL": "http://localhost:11434"
    },
    "model": "kimi-k2.5:cloud"
  }
}
PROVIDERS_EOF
```

**Step 2: Verify syntax**

```bash
bash -n bin/cld
```

Expected: No syntax errors

**Step 3: Commit**

```bash
git add bin/cld
git commit -m "feat: add example provider template to cld script"
```

---

## Task 2: Add provider configuration helper functions to cld

**Files:**
- Modify: `bin/cld` (add helper functions after configuration section)

**Step 1: Add PROVIDERS_FILE constant**

In the CONFIGURATION section (after `MCP_SERVER_DIR` line), add:

```bash
PROVIDERS_FILE="${HOME}/.claude/providers.json"
PROVIDERS_EXAMPLE_FILE="${HOME}/.claude/providers.json.example"
```

**Step 2: Write create_example_providers() helper function**

Add this function before `load_provider()`:

```bash
# Create example providers file if it doesn't exist
create_example_providers() {
    if [[ ! -f "$PROVIDERS_EXAMPLE_FILE" ]]; then
        mkdir -p "$(dirname "$PROVIDERS_EXAMPLE_FILE")"
        echo "$EXAMPLE_PROVIDERS" > "$PROVIDERS_EXAMPLE_FILE"
        chmod 600 "$PROVIDERS_EXAMPLE_FILE"
    fi
}
```

**Step 4: Write load_provider() function**

Add this function after `create_example_providers()`:

```bash
# Load provider configuration from providers.json
load_provider() {
    local provider="$1"

    if [[ ! -f "$PROVIDERS_FILE" ]]; then
        create_example_providers
        echo "Error: Providers file not found at $PROVIDERS_FILE" >&2
        echo "Example created at: $PROVIDERS_EXAMPLE_FILE" >&2
        echo "Edit it with your API keys, then rename to providers.json:" >&2
        echo "  mv $PROVIDERS_EXAMPLE_FILE $PROVIDERS_FILE" >&2
        echo "See docs: https://code.claude.com/docs/en/settings" >&2
        return 1
    fi

    # Validate JSON
    if ! jq . "$PROVIDERS_FILE" > /dev/null 2>&1; then
        echo "Error: Invalid JSON in $PROVIDERS_FILE" >&2
        return 1
    fi

    # Check if provider exists
    if ! jq -e ".[$provider]" "$PROVIDERS_FILE" > /dev/null 2>&1; then
        echo "Error: Provider '$provider' not found in $PROVIDERS_FILE" >&2
        echo "Available providers:" >&2
        jq -r 'keys[]' "$PROVIDERS_FILE" | sed 's/^/  - /' >&2
        return 1
    fi

    # Extract and output the provider config
    jq ".[$provider]" "$PROVIDERS_FILE"
}
```

**Step 5: Write list_providers() function**

Add this function after `load_provider()`:

```bash
# List available providers
list_providers() {
    if [[ ! -f "$PROVIDERS_FILE" ]]; then
        create_example_providers
        echo "No providers configured yet."
        echo ""
        echo "Example file created at: $PROVIDERS_EXAMPLE_FILE"
        echo ""
        echo "To get started:"
        echo "  1. Edit: $PROVIDERS_EXAMPLE_FILE"
        echo "  2. Replace example values with your API keys"
        echo "  3. Rename: mv $PROVIDERS_EXAMPLE_FILE $PROVIDERS_FILE"
        echo ""
        echo "Documentation: https://code.claude.com/docs/en/settings"
        return 0
    fi

    if ! jq . "$PROVIDERS_FILE" > /dev/null 2>&1; then
        echo "Error: Invalid JSON in $PROVIDERS_FILE" >&2
        return 1
    fi

    local providers=($(jq -r 'keys[]' "$PROVIDERS_FILE"))

    if [[ ${#providers[@]} -eq 0 ]]; then
        echo "No providers configured in ~/.claude/providers.json"
        return 0
    fi

    echo "Available providers:"
    echo ""
    for provider in "${providers[@]}"; do
        echo "  - $provider"
    done
}
```

**Step 6: Verify functions exist**

```bash
bash -n bin/cld
```

Expected: No syntax errors

**Step 7: Commit**

```bash
git add bin/cld
git commit -m "feat: add provider helper functions and example template"
```

---

## Task 2: Update argument parser to handle `-p` flag

**Files:**
- Modify: `bin/cld` (update argument parsing section)

**Step 1: Add provider tracking variables**

In the MAIN SCRIPT section, after `declare -a MCP_FILES`, add:

```bash
PROVIDER_NAME=""
PROVIDER_SETTINGS=""
```

**Step 2: Add `-p` case to argument parser**

In the `while [[ $# -gt 0 ]]; do` loop, add this case before the `--` case:

```bash
        -p)
            if [[ -z "$2" ]]; then
                echo "Error: -p requires a provider name" >&2
                show_help >&2
                exit 1
            fi
            PROVIDER_NAME="$2"
            shift 2
            ;;
```

**Step 3: Add `providers` command handling**

In the `while [[ $# -gt 0 ]]; do` loop, add this case before the `-m` case:

```bash
        providers)
            list_providers
            exit 0
            ;;
```

**Step 4: Verify syntax**

```bash
bash -n bin/cld
```

Expected: No syntax errors

**Step 5: Commit**

```bash
git add bin/cld
git commit -m "feat: add -p flag and providers command argument parsing"
```

---

## Task 3: Implement provider loading logic before executing Claude

**Files:**
- Modify: `bin/cld` (update command building section)

**Step 1: Add provider loading before command execution**

Before the "Build the command" section comment, add this code:

```bash
# ============================================================
#                  PROVIDER HANDLING
# ============================================================

# Load provider settings if specified
if [[ -n "$PROVIDER_NAME" ]]; then
    if ! PROVIDER_CONFIG=$(load_provider "$PROVIDER_NAME"); then
        exit 1
    fi

    # Extract env vars and export them
    while IFS= read -r line; do
        export "$line"
    done < <(jq -r '.env | to_entries | .[] | "\(.key)=\(.value)"' <<< "$PROVIDER_CONFIG")

    # Extract settings if present and add to Claude command
    if jq -e '.settings' <<< "$PROVIDER_CONFIG" > /dev/null 2>&1; then
        PROVIDER_SETTINGS=$(jq -c '.settings' <<< "$PROVIDER_CONFIG")
    fi
fi
```

**Step 2: Update command building to include settings**

In the "Build the command" section, after the MCP config lines, add:

```bash
# Add provider settings if present
if [[ -n "$PROVIDER_SETTINGS" ]]; then
    CMD+=(--settings "$PROVIDER_SETTINGS")
fi
```

**Step 3: Verify syntax**

```bash
bash -n bin/cld
```

Expected: No syntax errors

**Step 4: Test provider loading manually**

Create a test providers.json:

```bash
mkdir -p ~/.claude
cat > ~/.claude/providers.json << 'EOF'
{
  "test": {
    "env": {
      "TEST_VAR": "test_value"
    }
  }
}
EOF
```

Test listing:

```bash
bash bin/cld providers
```

Expected: Shows "test" provider with helpful hints

**Step 5: Commit**

```bash
git add bin/cld
git commit -m "feat: implement provider loading and environment variable export"
```

---

## Task 4: Update help text

**Files:**
- Modify: `bin/cld` (update HELP TEXT section)

**Step 1: Update show_help() function**

Replace the USAGE and COMMANDS sections with:

```bash
show_help() {
    cat << 'EOF'
Claude CLI launcher with granular MCP server support and provider switching

USAGE:
    cld [OPTIONS] [-- CLAUDE_ARGS]

FEATURES:
    - LSP (Language Server Protocol) enabled by default for IDE-level code intelligence
    - Provider switching via -p flag to use different LLM backends
    - Supports: Python, TypeScript, Go, Rust, Java, C/C++, C#, PHP, Kotlin, Ruby, HTML/CSS
    - Operations: goToDefinition, findReferences, hover, documentSymbol, getDiagnostics

COMMANDS:
    providers, -p list    List available providers
    ls, list, --list      List available MCP servers
    -h, --help            Show this help message

OPTIONS:
    -p PROVIDER           Load provider configuration (switches LLM backend)
    -m SERVER [SERVER...] Load MCP servers by name or shorthand

SHORTHAND FLAGS (used with -m):
    p               Playwright browser automation
    c               Chrome DevTools
    x               Context7 (Upstash context)
    a               Astro documentation
    f               Figma design tools
```

And add this to the EXAMPLES section:

```bash
    Provider switching:
    cld -p zai                             # Use zai provider
    cld -p local                           # Use local provider
    cld -p zai -m dev                      # zai provider + dev MCPs
    cld -p zai -m p c -- --print "test"    # Provider + MCPs + Claude args
    cld providers                          # List available providers
```

**Step 2: Verify help displays correctly**

```bash
bash bin/cld -h | head -30
```

Expected: Help text shows provider options

**Step 3: Commit**

```bash
git add bin/cld
git commit -m "docs: update help text with provider switching examples"
```

---

## Task 5: Create GitHub issue for `cld mcp` command

**Files:**
- GitHub issue (create via gh CLI)

**Step 1: Create the issue**

```bash
gh issue create --title "feat: add 'cld mcp' command to list available MCP servers" --body "Add a 'cld mcp' subcommand (similar to 'cld providers') that lists available MCP servers with descriptions.

This would complement the new provider switching feature and make discovering MCP servers easier.

Example usage:
\`\`\`bash
cld mcp          # List all available servers
cld mcp list     # Alias for above
\`\`\`"
```

Expected: Issue created successfully

**Step 2: Verify issue exists**

```bash
gh issue list --search "cld mcp" --state open
```

Expected: Shows the newly created issue

**Step 3: Note the issue in git log**

(No commit needed—GitHub issue is separate)

---

## Task 6: Manual integration testing

**Files:**
- No files created; testing only

**Step 1: Test example file auto-creation**

First, ensure no providers.json exists:

```bash
rm -f ~/.claude/providers.json ~/.claude/providers.json.example
```

Then test provider listing to trigger auto-creation:

```bash
bash bin/cld providers
```

Expected: Creates `~/.claude/providers.json.example` with zai and ollama examples, shows setup instructions

**Step 2: Test with providers.json configured**

Create a test providers.json:

```bash
cat > ~/.claude/providers.json << 'EOF'
{
  "test": {
    "env": {
      "TEST_VAR": "test_value"
    }
  }
}
EOF
```

Test listing:

```bash
bash bin/cld providers
```

Expected: Lists "test" provider from configured file

**Step 3: Test provider with MCP combination**

```bash
bash bin/cld -p test -m dev
```

Expected: Launches Claude with test provider env vars + dev MCPs

**Step 4: Test help text**

```bash
bash bin/cld -h | grep -A 5 "Provider switching"
```

Expected: Shows provider examples in help

**Step 5: Test error handling (missing provider)**

```bash
bash bin/cld -p nonexistent 2>&1
```

Expected: Shows error message with available providers

**Step 6: Test syntax check**

```bash
bash -n bin/cld
```

Expected: No syntax errors

**Step 7: Cleanup test files**

```bash
rm -f ~/.claude/providers.json ~/.claude/providers.json.example
```

**Step 8: No commit needed**

(This is manual testing, not a code change)

---

## Summary

**What this builds:**
- `-p <provider>` flag to load provider configurations from `~/.claude/providers.json`
- `cld providers` command to list available providers and guide setup
- Auto-create `~/.claude/providers.json.example` when config doesn't exist (scaffolds from embedded template)
- User edits example, then renames to `providers.json`
- Automatic environment variable export from provider config
- Integration with existing `-m` (MCP) flag for combined usage
- Example providers: zai and ollama (embedded in script)

**Key files:**
- `bin/cld` - Updated with provider switching logic and embedded example template

**Testing:**
- Manual testing of `-p`, `providers`, and combinations with `-m`
- Error handling for missing providers and invalid JSON
- Verify example file auto-creation on first run
