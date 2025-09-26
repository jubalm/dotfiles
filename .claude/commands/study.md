---
allowed-tools: Bash(python3 ~/.claude/docs-manager/doc_manager.py:*), Read
description: Fetch and organize documentation for future reference
argument-hint: <url> | @<file-with-urls>
---

# Goal
Build a single file context that Claude can consume for local documentaion references.

## Tool: Documentation Manager (DM)
Command: `python3 ~/.claude/docs-manager/doc_manager.py`
### NEVER: Fetch the link in $ARGUMENTS, use the tool 

Raw help output:
```
usage: doc_manager.py [-h]
                      {add,set,update,use,remove,list,view,cleanup,memory} ...

Documentation Manager

positional arguments:
  {add,set,update,use,remove,list,view,cleanup,memory}
                        Available commands
    add                 Download and add a new document
    set                 Set name and description for a document
    update              Update documents
    use                 Show versions or switch version
    remove              Remove document or version
    list                List all tracked documents
    view                Show detailed information about a document
    cleanup             Remove old versions
    memory              Generate Claude-compatible memory references

options:
  -h, --help            show this help message and exit
```

Usage examples:
```
python3 ~/.claude/docs-manager/doc_manager.py add <url>
python3 ~/.claude/docs-manager/doc_manager.py set <id> -n <name> -d <desc>
python3 ~/.claude/docs-manager/doc_manager.py memory --output ~/.claude/docs/references.md
```

## Strategy
Utilize the Documentation Manager script to create reference files automatically downloaded by the tool by providing it links. The generated reference docs that the tool is able to produce will be used as a collective context.

## Task
  - [ ] Scan $ARGUMENTS whether it's a link or contains links to download and add using DM's `add` function
  - [ ] Provide meaningful names and descriptions for added links
  - [ ] Generate reference docs using DM's `memory` function

