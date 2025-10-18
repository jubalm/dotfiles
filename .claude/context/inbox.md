# Inbox

Staging area for discoveries pending promotion.

**Purpose:** Capture patterns, decisions, insights discovered during work.

**Format:** Date + discovery → ~~strikethrough~~ + "Promoted: YYYY-MM-DD" after move

---

## Promotion Path (Three Tiers)

**Tier 1: Discovery** – Captured here temporarily

**Tier 2: Evaluate**
- Score against decision matrix (see authoring-for-token-efficiency skill)
- Would Claude miss? Project-specific? Prevents bugs? Saves time? Stable?
- 3+ yes → promote

**Tier 3: Placement**
- **Declarative (WHAT/WHY):** Facts, decisions, constraints → context files
  - @context/principles.md (philosophy, design rationale)
  - @context/architecture.md (structure, organization, constraints)
  - @context/patterns.md (non-obvious implementations, how X works)
- **Procedural (HOW):** Workflows, techniques, checklists → domain skills
  - dotfiles-setup (installation, bootstrap)
  - dotfiles-workflows (daily operations, maintenance)
  - dotfiles-git-workflow (commits, branches, alignment)

**Mark as promoted:** ~~strikethrough~~ (Promoted: YYYY-MM-DD)

---

## Discoveries

### 2025-01-18: Skills vs Memory Architecture - Fundamental Distinction

**Discovery:** Skills and Memory are fundamentally different categories, not a hierarchy.

**Skills = Instructions (Imperative, Behavioral)**
- WHAT: Procedures, methods, workflows, directives
- HOW they work: Expand into prompt as instructions when invoked
- Scope: Location attribute (project or user-level)
- Examples: git skill (procedures), workflows skill (operations)
- When: Skill tool invocation, or via Skill() in agent definitions

**Memory = Knowledge (Declarative, Contextual)**
- WHAT: Facts, decisions, constraints, project logic
- HOW they work: Retrieved via routing (@context/file.md in CLAUDE.md)
- Scope: Project-specific or local to .claude/ directory
- Examples: principles.md (why), architecture.md (how it's organized), patterns.md (implementation details)
- When: Query matches routing hints, or Claude reads for context

**Key Insight:** No hierarchy—different categories working together
- Skills provide HOW: "Use Conventional Commits with type(scope): description"
- Memory provides WHAT: "Valid scopes: nvim, zsh, tmux, git, docker"
- Result: Informed execution (skill procedure + memory constraints)

**Architectural Implication:**
- Skills should be generic/portable (user-level ~/.claude/skills/)
- Memory should be project-specific (project-level .claude/context/)
- Skills can reference memory: "Read @context/X to apply project constraints"

**Decision Matrix Score:**
- Would Claude miss? YES (emergent behavior, not documented in constitution)
- Project-specific? PARTIALLY (applies to all Claude Code users)
- Prevents bugs? YES (clarity prevents over-coupling or under-coupling skills/memory)
- Saves time? YES (eliminates confusion about architecture)
- Stable? YES (fundamental, unlikely to change)
→ **4/5 yes = HIGH PRIORITY for promotion**

**Suggested Placement:** @context/architecture.md (add "Skills vs Memory" section)

---

### 2025-01-18: Claude-Code Skill Internal Contradiction & Framework Clarification

**Discovery:** claude-code/SKILL.md contained internal contradictions that obscured the framework:
- Claimed skills are "generic and portable" (only user-level)
- But actually supports both user-level AND project-level skills
- "When to Create a Skill" criteria implied only universal skills
- Decision matrix didn't account for project-level skills

**Root Cause:** Old context files were polluting the skill (dotfiles-specific examples), framework not cleanly separated from implementation details.

**Resolution:** Complete rewrite with two-step decision framework:
1. **Step 1:** Procedure (Skill) vs Fact (Memory) - fundamental distinction
2. **Step 2:** Universal (user-level) vs Project-specific (project-level) - only for skills

**Result:**
- Pattern-based language: "How to..." = Skill, "What is..." = Memory
- Generic examples (no dotfiles-specific content)
- Clear: Scope can be universal OR project-specific, separate from HOW/WHAT distinction

**Decision Matrix Score:**
- Would Claude miss? YES (clarity about scope distinction)
- Project-specific? NO (applies to all Claude Code users)
- Prevents bugs? YES (wrong scope = wasted effort or wrong organization)
- Saves time? YES (immediately clear where to put new knowledge)
- Stable? YES (architectural distinction, unlikely to change)
→ **4/5 yes = HIGH PRIORITY for promotion**

**Suggested Placement:** Overwrite current @context/architecture.md with Skills vs Memory distinction properly framed

---

### 2025-01-18: Subagent Architecture for Knowledge Curation

**Discovery:** Subagent architecture enables powerful curator capability by leveraging:
- Separate context windows (token cost isolated)
- Skills tool usage (progressive disclosure, not hardcoded rules)
- Ask-before-write pattern (human-in-the-loop approval)
- Output validation (agent reads what it writes)
- Negotiable behavior (accepts user prompts mid-execution)

**Key Insight:** Loose prompting + Skills tool > hardcoded rules in agent definition
- Agent doesn't need to know decision matrices
- Agent invokes claude-code skill when classifying
- Skill updates → agent behavior updates automatically
- One source of truth: universal skill framework

**Proposed Single Curator Agent:**
```
Role: Knowledge curator
Process:
1. Read discoveries from conversation/input
2. Use claude-code skill to classify (Skill vs Memory, User vs Project)
3. Propose changes with reasoning
4. Ask for approval (unless bypassed)
5. Write approved changes
6. Read back to validate correctness
7. Be negotiable: accept user corrections to reasoning
```

**Benefits:**
- Contained token cost (separate context, progressive loading)
- Safe by default (asks before writing)
- Self-validating (reads output)
- Collaborative (negotiable, not rigid)
- Unified knowledge (all agents use same skill framework)
- Auto-updating (skill changes propagate)

**Possible Future Specialization:**
- decision-classifier (ultra-lightweight)
- skill-author (authoring guide)
- memory-curator (memory organization)
- promotion-assistant (inbox lifecycle)

**Decision Matrix Score:**
- Would Claude miss? YES (complex interaction pattern not in training)
- Project-specific? PARTIALLY (architecture is universal, implementation per project)
- Prevents bugs? YES (unified framework, no drift in agent behavior)
- Saves time? YES (automates tedious classification/curation)
- Stable? MAYBE (agent capabilities evolving, but core pattern stable)
→ **4/5 yes = HIGH PRIORITY for exploration**

**Suggested Placement:**
- Skill framework: @context/architecture.md (as design pattern)
- Agent definition: New curator agent in ~/.claude/agents/ (user-level)
- Reference: Skills/best-practices.md (how agents should use skills)
