# Discovery Checklist: Is Your Skill Discoverable?

A skill only exists if Claude discovers it. Use this checklist to verify your skill works in practice.

---

## Pre-Launch Testing

### Description Clarity

- [ ] **Description starts with verb + action**
  - Good: "Write conventional commits", "Analyze SQL queries"
  - Bad: "Helper for commits", "SQL assistant"

- [ ] **Description includes specific capabilities**
  - Good: "Extract text/tables, fill forms, merge PDFs"
  - Bad: "Process PDFs"

- [ ] **Description includes "when to use" triggers**
  - Good: "Use when making commits, need semantic format"
  - Bad: "Use when needed"

- [ ] **Description includes key trigger words**
  - Good: "conventional commits", "type(scope)", "semantic"
  - Bad: Generic terms only

- [ ] **Description under 200 characters** (for discoverability)
  - Longer descriptions are fine but may reduce discovery

### Content Quality

- [ ] **SKILL.md is clear and minimal** (<500 lines)
  - Removes all inferrable content
  - Focuses on procedure, not general knowledge

- [ ] **Includes concrete example**
  - User input → Skill output shown
  - Not abstract, but realistic scenario

- [ ] **Example is actually minimal**
  - Can user understand it in 30 seconds?
  - Or is it too complex?

- [ ] **Links to reference materials**
  - Users can dig deeper if needed
  - Doesn't force advanced content upfront

### Scope Appropriateness

- [ ] **User-level skill**: Works across multiple projects
  - OR clearly documented project-level reason

- [ ] **Scope matches location**
  - User-level in `~/.claude/skills/`
  - Project-level in `.claude/skills/`

---

## Discovery Testing

### Explicit Invocation Test

Invoke the skill directly using description keywords. Does it load?

**Test prompt:**
```
Use the [skill name description] skill to...
```

Or:

```
I need to [key verb from description]. Can you use the [skill name]?
```

- [ ] Skill loads when invoked explicitly
- [ ] Skill content is relevant to request
- [ ] Skill helps solve the problem

**Failure modes:**
- Skill doesn't load → Check description and location
- Wrong skill loads → Description too similar to other skills
- Skill loads but isn't helpful → Content needs refinement

### Implied Invocation Test

Does Claude discover it without mentioning it?

**Test prompt 1 (simple case):**
```
[Request that matches skill's purpose, without mentioning skill]
```

Example:
- If skill: "Git Commit Helper"
- Test: "I've staged my changes. What should the commit message be?"

- [ ] Claude mentions or uses the skill proactively?
- [ ] Or Claude answers without using skill?

**Test prompt 2 (complex case):**
```
[Multi-step request where skill is relevant]
```

- [ ] Does Claude offer to use skill?
- [ ] Or solves without it?

**Interpretation:**
- Skill used proactively → ✓ Discoverable
- Skill not mentioned but not needed → ✓ OK (maybe not needed)
- Skill not mentioned but would help → ⚠️ Description needs work
- Wrong skill invoked → ✗ Description conflict

### Phrasing Variation Test

Try different phrasings. Does discovery work consistently?

**Test variations:**

For "Write conventional commit messages" skill:

```
1. "I need a commit message"
2. "Help with semantic commits"
3. "How do I use conventional commits?"
4. "What should this commit be called?"
5. "conventional commits with type/scope?"
```

- [ ] Consistent discovery across variations?
- [ ] Some variations work, others don't?
- [ ] No variations work?

**Results guide refinement:**
- All work: ✓ Good description
- Some work: ⚠️ Description could be broader
- None work: ✗ Description too vague or too specific

---

## Post-Launch Iteration

### Usage Pattern Observation

After deploying skill, observe actual usage:

- [ ] Is Claude using it appropriately?
  - When does it invoke?
  - When does it skip?

- [ ] Are users mentioning it explicitly?
  - Users requesting it by name?
  - Or never mention it?

- [ ] Are there scenarios where it should help but doesn't?
  - Missed opportunities?
  - Description needs expansion?

### Refinement Triggers

Update skill description/content if:

- [ ] **Underused**: Claude doesn't discover it when it should
  - Action: Expand description with more trigger words
  - Action: Simplify content to be more appealing

- [ ] **Overused**: Claude invokes it for things outside scope
  - Action: Narrow description
  - Action: Add "When NOT to use" section

- [ ] **Ineffective**: Users request it but it doesn't help
  - Action: Improve examples
  - Action: Refine procedure steps
  - Action: Test with different model

- [ ] **Confuses other skills**: Description too similar
  - Action: Add distinguishing keywords
  - Action: Clarify scope differences

### Iteration Process

1. Observe usage for 1-2 weeks
2. Identify 2-3 improvement opportunities
3. Update description or content
4. Test discovery again
5. Deploy updated version
6. Repeat

---

## Red Flags

🚩 **Skill is not working if:**

- Description is longer than 1-2 sentences
- SKILL.md is longer than 600 lines
- Content has obvious inferrable knowledge
- Example takes more than 1 minute to understand
- User needs to read reference files to use skill
- No one mentions or uses the skill
- Claude uses skill for unrelated tasks
- Multiple similar skills exist (merge or clarify)

---

## Success Indicators

✓ **Skill is working if:**

- Claude discovers it with relevant keywords
- Users mention it by name
- Example is clear and minimal
- Reference files rarely needed
- Claude uses it proactively when appropriate
- Content helps users accomplish goal
- Description is crisp (1-2 sentences)
- Other skills don't compete with it

---

## Quick Checklist

Before launch:

- [ ] Description includes verb + specifics + trigger words
- [ ] SKILL.md < 500 lines
- [ ] Example is concrete and minimal
- [ ] Skill loads when invoked explicitly
- [ ] Scope (user vs project) is correct
- [ ] Related skills don't duplicate purpose

After launch:

- [ ] Observe discovery patterns
- [ ] Refine based on usage
- [ ] Iterate every 1-2 weeks
- [ ] Track success indicators
