---
name: project-context
description: Bootstrap or repair durable repository context. Use when preparing a repository for contributors, improving README or agent guidance, reconciling stale or duplicated documentation, or incorporating approved decisions and experiment results into canonical sources.
---

# Project Context

Make the repository understandable to a competent new contributor with the smallest justified context change. Work within the requested scope; allow existing context to be sufficient. Use this procedure independently of other skills or an umbrella document.

## Inspect before editing

1. Read applicable repository instructions and its existing entry point. Inspect relevant code, schemas, migrations, tests, build commands, and approved issues or decisions. Follow local references instead of assuming a file named `SPEC.md` exists or governs everything.
2. Identify the project purpose, maturity, vocabulary, important boundaries, validation path, and expected completion handoff. Read only the sources needed to resolve actual gaps.
3. Separate intended behavior, implemented behavior, and verified behavior. Label proposals, assumptions, and unknowns. Do not turn a conversational suggestion into an approved contract or a passing test into proof of every claim.
4. Identify authority for each disputed subject. Use declared schemas for interface contracts, migrations for implemented database shape, and approved requirements for desired outcomes where applicable. Treat code and tests as evidence that can also contain bugs; avoid a universal source hierarchy.
5. Resolve conflicts only when the request and sources establish the answer. Otherwise preserve the distinction and surface the missing decision without blocking unrelated context repairs.

## Make the minimum durable repair

- Improve the existing entry point before introducing another document. Orient the reader to purpose, stage, use or run commands, and the sources that govern deeper questions.
- Put stable semantics and non-obvious constraints in their existing canonical source. Document ownership, failure behavior, trust boundaries, and state transitions only where they matter to safe changes.
- Define domain terms operationally once. Link to that definition elsewhere.
- Keep project-local agent guidance about execution: relevant reading, scope, validation, and handoff. Reference architecture instead of copying it into another manual.
- Add a specification only when a coherent contract needs one and existing sources cannot carry it clearly. Add evidence records only when the result will be reused. Do not create a mandatory README/SPEC/AGENTS/EVIDENCE skeleton.
- For experiments, preserve the question, fidelity needed to answer it, observed result, environment or dependency version, evidence, and interpretation. Include UI, authentication, persistence, or integration when the question requires them; exclude unrelated product work.
- Separate backlog and execution state from stable semantics using the project's existing issue or planning conventions. Preserve unresolved decisions rather than disguising them as current behavior.

## Write and prune

Use direct, current-tense statements for established facts. Mark desired but unimplemented behavior explicitly. Preserve rationale when a future contributor is likely to question or accidentally undo a constraint; record reconsideration conditions when useful.

Prefer one rule, its reason, and a concrete example to broad advice. For example: "All callers use the existing eligibility classifier so the CLI and UI cannot produce different decisions."

Reference accessible canonical sources instead of duplicating their explanations. Keep enough context for the intended reader to follow the reference. Inspect pinned dependencies, local types, and source before applying current vendor documentation to an older version; link narrow authoritative documentation where useful.

Remove or consolidate content only after establishing that it is duplicated or superseded. Age, apparent inactivity, and an absent owner alone do not prove obsolescence. Preserve still-relevant rationale and unresolved questions; update inbound references when moving or deleting content.

Give durable documents a clear role and an obvious update trigger where needed; do not introduce a separate ownership registry. Keep repository writing compact and human-legible. Treat recurring reconstruction work or long handoffs as signals to investigate missing context, not automatic proof that more documentation is necessary.

## Check and report

Read the changed context as a new contributor. Check that purpose, stage, authority, constraints, validation, and handoff can be found without reconstructing chat history. Resolve local links and validate commands against current scripts or configuration; distinguish inspected commands from commands actually run.

Report concrete changes, why they were needed, checks performed, and unresolved material conflicts. If the existing sources are sufficient or recent work changes no durable truth, report that conclusion without creating files. Do not implement unrelated features or advance lifecycle state as a side effect of repairing context.
