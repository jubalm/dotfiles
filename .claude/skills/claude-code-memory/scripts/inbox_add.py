#!/usr/bin/env python3
"""
Add item to inbox with metadata.
"""

import os
import sys
import json
from pathlib import Path
from datetime import datetime
import re


def slugify(text):
    """Convert text to slugified ID."""
    slug = text.lower()
    slug = re.sub(r"[^\w\s-]", "", slug)
    slug = re.sub(r"[-\s]+", "-", slug)
    return slug.strip("-")


def inbox_add(title, note, context="", priority="medium", inbox_type="observation", root_dir="."):
    """Create inbox item with frontmatter."""
    inbox_dir = Path(root_dir) / ".claude" / "memory" / "inbox"

    if not inbox_dir.exists():
        return {
            "status": "error",
            "message": "Inbox directory not found. Initialize memory first.",
        }

    try:
        item_id = slugify(title)
        filename = f"{item_id}.md"
        filepath = inbox_dir / filename

        # Avoid overwriting
        counter = 1
        base_id = item_id
        while filepath.exists():
            item_id = f"{base_id}-{counter}"
            filename = f"{item_id}.md"
            filepath = inbox_dir / filename
            counter += 1

        # Create frontmatter
        frontmatter = f"""---
id: {item_id}
type: {inbox_type}
title: {title}
priority: {priority}
status: pending
added_by: claude
date: {datetime.now().strftime('%Y-%m-%d')}
---

# {title}

**Note:** {note}

**Context:** {context}

## Discussion

"""

        filepath.write_text(frontmatter)

        return {
            "status": "success",
            "message": f"Added to inbox",
            "id": item_id,
            "file": filename,
            "priority": priority,
            "type": inbox_type,
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(
            json.dumps(
                {
                    "status": "error",
                    "message": "Usage: inbox_add.py <title> <note> [--context <text>] [--priority high|medium|low] [--type observation|intuition|deferred]",
                }
            )
        )
        sys.exit(1)

    title = sys.argv[1]
    note = sys.argv[2]
    context = ""
    priority = "medium"
    inbox_type = "observation"

    # Parse optional args
    i = 3
    while i < len(sys.argv):
        if sys.argv[i] == "--context" and i + 1 < len(sys.argv):
            context = sys.argv[i + 1]
            i += 2
        elif sys.argv[i] == "--priority" and i + 1 < len(sys.argv):
            priority = sys.argv[i + 1]
            i += 2
        elif sys.argv[i] == "--type" and i + 1 < len(sys.argv):
            inbox_type = sys.argv[i + 1]
            i += 2
        else:
            i += 1

    root_dir = os.environ.get("CLAUDE_ROOT", ".")
    result = inbox_add(title, note, context, priority, inbox_type, root_dir)
    print(json.dumps(result, indent=2))
