#!/usr/bin/env python3
"""
Add entry to memory file with token efficiency warnings.
"""

import os
import sys
import json
from pathlib import Path
from datetime import datetime


def count_tokens_estimate(text):
    """Rough token estimate: ~1 token per 4 chars."""
    return max(1, len(text) // 4)


def add_entry(memory_type, entry_text, root_dir="."):
    """Add entry to appropriate memory file."""
    valid_types = ["constraints", "quirks", "decisions", "conventions"]

    if memory_type not in valid_types:
        return {
            "status": "error",
            "message": f"Invalid type. Must be one of: {', '.join(valid_types)}",
        }

    root = Path(root_dir)
    memory_file = root / ".claude" / "memory" / f"{memory_type}.md"

    if not memory_file.exists():
        return {
            "status": "error",
            "message": f"Memory file not found: {memory_file}",
        }

    try:
        # Estimate tokens
        tokens = count_tokens_estimate(entry_text)
        warning = None
        if tokens > 30:
            warning = f"Entry is ~{tokens} tokens (target: <30)"

        # Format entry with separator
        formatted_entry = f"## {entry_text}\n\n---\n"

        # Append to file
        with open(memory_file, "a") as f:
            f.write(formatted_entry)

        return {
            "status": "success",
            "message": f"Added to {memory_type}.md",
            "type": memory_type,
            "tokens": tokens,
            "warning": warning,
            "file": str(memory_file),
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(json.dumps({"status": "error", "message": "Usage: add_entry.py <type> <entry>"}))
        sys.exit(1)

    memory_type = sys.argv[1]
    entry_text = " ".join(sys.argv[2:])
    root_dir = os.environ.get("CLAUDE_ROOT", ".")

    result = add_entry(memory_type, entry_text, root_dir)
    print(json.dumps(result, indent=2))
