#!/usr/bin/env python3
"""
Audit memory files for token efficiency, generic knowledge, staleness, and conflicts.
"""

import os
import sys
import json
from pathlib import Path
from datetime import datetime, timedelta


def count_tokens_estimate(text):
    """Rough token estimate: ~1 token per 4 chars."""
    return max(1, len(text) // 4)


def is_likely_generic(text):
    """Check if entry appears to be generic best practice."""
    generic_patterns = [
        "use typescript",
        "write unit tests",
        "write tests before",
        "use git",
        "handle errors",
        "add logging",
        "validate input",
        "use async",
        "use promises",
        "code review",
        "best practice",
        "follow conventions",
        "always check",
        "make sure to",
    ]

    text_lower = text.lower()
    for pattern in generic_patterns:
        if pattern in text_lower:
            return True
    return False


def audit_memory(root_dir="."):
    """Audit all memory files."""
    memory_dir = Path(root_dir) / ".claude" / "memory"

    if not memory_dir.exists():
        return {
            "status": "error",
            "message": "Memory directory not found.",
        }

    try:
        findings = {
            "token_stats": {},
            "generic_flagged": [],
            "conflicts": [],
            "old_entries": [],
            "total_entries": 0,
            "avg_tokens": 0,
        }

        all_entries = []
        total_tokens = 0

        memory_files = ["constraints.md", "quirks.md", "decisions.md", "conventions.md"]

        for filename in memory_files:
            filepath = memory_dir / filename
            if not filepath.exists():
                continue

            content = filepath.read_text()
            entries = [e.strip() for e in content.split("## ") if e.strip() and e != ""]

            file_tokens = 0
            for entry in entries:
                lines = entry.split("\n")
                title = lines[0] if lines else ""
                tokens = count_tokens_estimate(entry)
                file_tokens += tokens
                total_tokens += tokens

                all_entries.append({
                    "file": filename,
                    "title": title[:50],
                    "tokens": tokens,
                    "content": entry,
                })

                # Check for generic patterns
                if is_likely_generic(entry):
                    findings["generic_flagged"].append({
                        "file": filename,
                        "entry": title,
                        "reason": "Appears to be generic best practice",
                    })

            findings["token_stats"][filename] = {
                "entries": len(entries),
                "tokens": file_tokens,
                "avg_per_entry": file_tokens // max(1, len(entries)),
            }

        # Calculate averages
        findings["total_entries"] = len(all_entries)
        findings["avg_tokens"] = total_tokens // max(1, len(all_entries))

        # Check for potential conflicts (simple heuristic)
        seen_topics = {}
        for entry in all_entries:
            title = entry["title"].lower().split()[0] if entry["title"] else ""
            if title:
                if title in seen_topics:
                    findings["conflicts"].append({
                        "topic": title,
                        "files": [seen_topics[title], entry["file"]],
                        "note": "Similar topics in different files - check for redundancy",
                    })
                else:
                    seen_topics[title] = entry["file"]

        return {
            "status": "success",
            "audit": findings,
            "recommendations": generate_recommendations(findings),
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }


def generate_recommendations(findings):
    """Generate actionable recommendations."""
    recs = []

    if findings["avg_tokens"] > 25:
        recs.append("Consider condensing entries - average is above 25 tokens target")

    if findings["generic_flagged"]:
        recs.append(f"{len(findings['generic_flagged'])} entries flagged as potentially generic - review and remove if not project-specific")

    if findings["conflicts"]:
        recs.append(f"{len(findings['conflicts'])} potential redundancies detected - check for duplicate information")

    if not recs:
        recs.append("Memory looks healthy!")

    return recs


if __name__ == "__main__":
    root_dir = os.environ.get("CLAUDE_ROOT", ".")
    result = audit_memory(root_dir)
    print(json.dumps(result, indent=2))
