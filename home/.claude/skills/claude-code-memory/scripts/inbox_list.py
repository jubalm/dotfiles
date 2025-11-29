#!/usr/bin/env python3
"""
List inbox items with metadata (no YAML dependency).
"""

import os
import sys
import json
from pathlib import Path


def parse_frontmatter(text):
    """Parse YAML frontmatter manually without yaml module."""
    if not text.startswith("---"):
        return {}
    
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    
    frontmatter_text = parts[1].strip()
    data = {}
    
    for line in frontmatter_text.split("\n"):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        
        if ":" in line:
            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()
            # Remove quotes if present
            if value.startswith('"') and value.endswith('"'):
                value = value[1:-1]
            elif value.startswith("'") and value.endswith("'"):
                value = value[1:-1]
            data[key] = value
    
    return data


def inbox_list(root_dir="."):
    """List all inbox items."""
    inbox_dir = Path(root_dir) / ".claude" / "memory" / "inbox"

    if not inbox_dir.exists():
        return {
            "status": "error",
            "message": "Inbox directory not found.",
        }

    try:
        items = []

        for md_file in sorted(inbox_dir.glob("*.md")):
            if md_file.name == ".gitkeep":
                continue

            content = md_file.read_text()
            frontmatter = parse_frontmatter(content)
            
            if frontmatter:
                items.append({
                    "id": frontmatter.get("id"),
                    "file": md_file.name,
                    "title": frontmatter.get("title"),
                    "type": frontmatter.get("type"),
                    "priority": frontmatter.get("priority"),
                    "status": frontmatter.get("status"),
                    "date": frontmatter.get("date"),
                })

        return {
            "status": "success",
            "count": len(items),
            "items": items,
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    root_dir = os.environ.get("CLAUDE_ROOT", ".")
    result = inbox_list(root_dir)
    print(json.dumps(result, indent=2))
