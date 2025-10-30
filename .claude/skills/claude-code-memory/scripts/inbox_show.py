#!/usr/bin/env python3
"""
Display full inbox item content (no YAML dependency).
"""

import os
import sys
import json
from pathlib import Path


def inbox_show(item_id, root_dir="."):
    """Show full inbox item content."""
    inbox_dir = Path(root_dir) / ".claude" / "memory" / "inbox"

    if not inbox_dir.exists():
        return {
            "status": "error",
            "message": "Inbox directory not found.",
        }

    try:
        # Find file by ID or filename
        filepath = None

        if item_id.endswith(".md"):
            filepath = inbox_dir / item_id
        else:
            filepath = inbox_dir / f"{item_id}.md"

        if not filepath.exists():
            return {
                "status": "error",
                "message": f"Inbox item not found: {item_id}",
            }

        content = filepath.read_text()

        return {
            "status": "success",
            "id": item_id,
            "file": filepath.name,
            "content": content,
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(
            json.dumps(
                {
                    "status": "error",
                    "message": "Usage: inbox_show.py <item_id>",
                }
            )
        )
        sys.exit(1)

    arg = sys.argv[1]
    root_dir = os.environ.get("CLAUDE_ROOT", ".")
    
    # Handle both full path and item ID
    if "/" in arg or "\\" in arg:
        # Extract filename from path
        item_id = Path(arg).stem
    else:
        item_id = arg

    result = inbox_show(item_id, root_dir)
    print(json.dumps(result, indent=2))
