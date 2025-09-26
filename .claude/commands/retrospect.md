---
description: "Natural language experiential learning from session analysis"
allowed-tools: ["Task", "Read", "Write", "Edit", "MultiEdit", "Grep", "Glob", "Bash"]
---

# Retrospect: Experiential Learning System

Analyze current session for learning patterns and generate curated memory suggestions.

**Input Analysis**: "$ARGUMENTS"

## Topic & Scope Intelligence

**Natural Language Topic Detection**:
- Empty/general terms → Full session analysis
- Technical terms (server, build, debug, deploy) → Technical pattern focus
- Personal terms (my, preference, approach, style) → Personal pattern focus  
- Project terms (team, shared, everyone, deployment) → Project pattern focus

**Automatic Agent Selection**:
- Personal indicators → Launch Personal Memory Agent only
- Project indicators → Launch Project Memory Agent only  
- Mixed/unclear → Launch both agents in parallel
- Technical problems → Likely project-relevant unless explicitly personal

## Dual-Agent Processing System

### Personal Memory Agent
**Target**: ~/.claude/CLAUDE.md (cross-project personal patterns)
**Focus Areas**:
- Individual collaboration preferences and communication patterns
- Personal debugging methodologies and problem-solving approaches  
- Claude performance improvements specific to user working style
- Cross-project personal development patterns and shortcuts

**Session Analysis**:
- Scan for user preferences: "I prefer", "better when you", "my approach"
- Identify Claude improvement opportunities: "you missed", "should have", "always forget"
- Extract personal workflow patterns and individual debugging strategies
- Capture effective collaboration approaches specific to this user

### Project Memory Agent  
**Target**: CLAUDE.md (team-shared project knowledge)
**Focus Areas**:
- Project-specific technical issues and resolution patterns
- Team-relevant debugging procedures and common problems
- Shared development workflows and project conventions
- Technical knowledge that benefits multiple team members

**Session Analysis**:
- Scan for project problems: technical failures, build issues, deployment problems
- Identify team-relevant solutions and prevention strategies
- Extract project-specific patterns, configurations, and workflows
- Capture knowledge that affects multiple developers or project success

## Session Content Analysis

**Pattern Recognition**:
- Problem identification: Error messages, stuck processes, failed operations
- Solution tracking: Successful interventions, working approaches, resolution steps
- Outcome verification: Confirmed fixes, successful completions, problem resolution
- Context extraction: Tools used, files involved, technical environment

**Learning Extraction**:
- Cause-effect relationships: Problem triggers → Solution approaches → Outcomes
- Prevention opportunities: How to avoid similar issues proactively
- Process improvements: Better approaches for similar future scenarios
- Knowledge gaps: Areas where better preparation could help

## Existing Memory Integration

**Memory Scanning**:
- Read current CLAUDE.md and ~/.claude/CLAUDE.md content
- Identify existing entries related to session learnings
- Map current knowledge structure and identify gaps

**Smart Integration Operations**:
- **ENHANCE**: Add new insights to existing relevant entries
- **MERGE**: Consolidate similar or overlapping knowledge areas
- **RESOLVE**: Address conflicting information with session evidence
- **CROSS-LINK**: Connect related knowledge areas for better navigation
- **REPLACE**: Update outdated information with session-validated approaches

**Conflict Detection**:
- Compare session learnings against existing memory entries
- Identify contradictory approaches or solutions
- Flag outdated information that contradicts recent successful approaches
- Present conflicts for human decision and resolution

## Intelligent Processing Flow

1. **Topic Analysis**: Parse natural language topic and determine focus area and scope
2. **Agent Selection**: Choose appropriate agent(s) based on topic analysis and content indicators
3. **Session Scanning**: Extract relevant content from conversation history based on topic focus
4. **Memory Analysis**: Read and analyze existing memory files for integration opportunities  
5. **Pattern Extraction**: Identify learning opportunities, problems-solutions, and process improvements
6. **Integration Planning**: Plan how to integrate new learnings with existing knowledge
7. **Suggestion Generation**: Create curated, actionable suggestions for human review
8. **Sequential Presentation**: Present suggestions one-by-one with learning context and rationale
9. **Native Tool Execution**: Immediately execute Edit/Write tools after each explanation to leverage Claude Code's built-in confirmation system

## Output Format

**Sequential Suggestion Presentation**:
Each memory suggestion follows this workflow:

1. **Learning Context**: Brief description of what was learned from session
2. **Rationale**: Why this specific change enhances memory/knowledge  
3. **Target Location**: Exact file and section being modified
4. **Immediate Tool Execution**: Execute Edit/Write tool directly after explanation

**Example Format**:
```markdown
## Suggestion N: [ACTION] [Description]

**Learning Context**: [What was learned from the session]
**Rationale**: [Why this change improves team/personal knowledge]
**Target**: [file_path:line_range or section]

[Edit/Write tool executes immediately - Claude Code's native confirmation handles approval]
```

**Native Tool Confirmation Workflow**:
- Present each suggestion with learning context, rationale, and target location
- Execute Edit/Write tool immediately after explanation
- Let Claude Code's built-in confirmation system handle user approval/rejection
- Continue sequentially through all suggestions
- Provide summary of applied changes at the end

Execute this comprehensive analysis using the specified topic focus (if provided) and present curated learning suggestions using native tool confirmations for seamless user experience.