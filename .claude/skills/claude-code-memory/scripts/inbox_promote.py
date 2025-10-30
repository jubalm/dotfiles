#!/usr/bin/env python3
"""
Promote inbox item to active memory.
"""

import os
import sys
import json
from pathlib import Path


def inbox_promote(item_id, target_type, entry_text, root_dir="."):
    """Move inbox item to active memory and archive inbox file."""
    valid_types = ["constraints", "quirks", "decisions", "conventions"]

    if target_type not in valid_types:
        return {
            "status": "error",
            "message": f"Invalid type. Must be one of: {', '.join(valid_types)}",
        }

    inbox_dir = Path(root_dir) / ".claude" / "memory" / "inbox"
    memory_file = Path(root_dir) / ".claude" / "memory" / f"{target_type}.md"

    if not inbox_dir.exists():
        return {
            "status": "error",
            "message": "Inbox directory not found.",
        }

    try:
        # Find inbox file
        inbox_file = None
        if (inbox_dir / f"{item_id}.md").exists():
            inbox_file = inbox_dir / f"{item_id}.md"
        else:
            # Search for matching file
            for f in inbox_dir.glob("*.md"):
                if item_id in f.name:
                    inbox_file = f
                    break

        if not inbox_file:
            return {
                "status": "error",
                "message": f"Inbox item not found: {item_id}",
            }

        # Add to memory
        formatted_entry = f"## {entry_text}\n\n---\n"
        with open(memory_file, "a") as f:
            f.write(formatted_entry)

        # Archive inbox file (rename with .archived)
        archived_file = inbox_file.with_suffix(".md.archived")
        inbox_file.rename(archived_file)

        return {
            "status": "success",
            "message": f"Promoted to {target_type}.md",
            "inbox_item": inbox_file.name,
            "archived_at": str(archived_file),
            "target_file": str(memory_file),
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print(
            json.dumps(
                {
                    "status": "error",
                    "message": "Usage: inbox_promote.py <item_id> <target_type> <entry_text>",
                }
            )
        )
        sys.exit(1)

    item_id = sys.argv[1]
    target_type = sys.argv[2]
    entry_text = " ".join(sys.argv[3:])
    root_dir = os.environ.get("CLAUDE_ROOT", ".")

    result = inbox_promote(item_id, target_type, entry_text, root_dir)
    print(json.dumps(result, indent=2))
