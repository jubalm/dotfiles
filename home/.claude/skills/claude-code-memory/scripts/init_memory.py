#!/usr/bin/env python3
"""
Initialize Claude Code memory system structure.
Creates .claude/memory/ directories and CLAUDE.md with proper imports.
"""

import os
import sys
import json
from pathlib import Path


def init_memory(root_dir="."):
    """Initialize memory system at root_dir."""
    root = Path(root_dir)
    claude_dir = root / ".claude"
    memory_dir = claude_dir / "memory"
    inbox_dir = memory_dir / "inbox"

    try:
        # Create directories
        claude_dir.mkdir(exist_ok=True)
        memory_dir.mkdir(exist_ok=True)
        inbox_dir.mkdir(exist_ok=True)

        # Create empty memory files with headers
        memory_files = {
            "constraints.md": "# Constraints\n\nBusiness and technical limitations.\n\n",
            "quirks.md": "# Quirks\n\nNon-standard behaviors and workarounds.\n\n",
            "decisions.md": "# Decisions\n\nArchitectural choices with rationale.\n\n",
            "conventions.md": "# Conventions\n\nTeam standards and project-specific practices.\n\n",
        }

        for filename, header in memory_files.items():
            filepath = memory_dir / filename
            if not filepath.exists():
                filepath.write_text(header)

        # Create CLAUDE.md with imports
        claude_md = claude_dir / "CLAUDE.md"
        claude_md_content = """# Project Memory

@memory/constraints.md
@memory/quirks.md
@memory/decisions.md
@memory/conventions.md

Note: inbox/ exists but is on-demand only - mention "inbox" to load items.
"""
        claude_md.write_text(claude_md_content)

        # Create .gitkeep in inbox to preserve directory
        (inbox_dir / ".gitkeep").touch()

        return {
            "status": "success",
            "message": "Memory system initialized",
            "paths": {
                "claude_dir": str(claude_dir),
                "memory_dir": str(memory_dir),
                "inbox_dir": str(inbox_dir),
            },
            "files_created": list(memory_files.keys()) + ["CLAUDE.md", ".gitkeep"],
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


if __name__ == "__main__":
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    result = init_memory(root)
    print(json.dumps(result, indent=2))
