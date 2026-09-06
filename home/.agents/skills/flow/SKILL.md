---
name: flow
description: Use when engineering work must be placed in lifecycle context; when deciding what happens next across RFC/spec, planning, implementation, verification, acceptance, merge, release, or rework; or when reconstructing project state from durable repository artifacts.
---

# Flow

## Overview

Flow owns durable engineering progression. It answers: **What state is this work in, and what should happen next?**

It does not own execution mechanics or independent validation. Use `execute` to perform bounded work and `verify` to establish whether an acceptance contract holds.

Canonical loop:

```text
FLOW
  decides the next state and contract
      ↓
EXECUTE
  performs bounded work
      ↓
VERIFY
  returns evidence and verdict
      ↓
FLOW
  advances, retries, replans, or escalates
```

## Principles

- Reconstruct state from durable evidence; do not infer lifecycle state from conversation tone or agent confidence.
- Keep lifecycle policy separate from execution topology and model choice.
- Define acceptance before implementation whenever practical.
- Advance only when the evidence required by the transition exists.
- Reopen specification or planning when implementation evidence invalidates an assumption; do not force progress through a stale plan.
- Treat merge, deployment, publication, rollback, and destructive transitions as authority-bearing actions rather than automatic consequences of technical success.
- Prefer the smallest lifecycle ceremony that preserves architectural clarity, reviewability, and rollback safety.

## State Model

Use these states as semantic anchors, not mandatory repository labels:

```text
INTAKE
  ↓
ASSESS
  ├─ bounded/local ─────────────→ PLAN
  └─ architectural/ambiguous/risky → SPEC
                                  ↓
                                PLAN
                                  ↓
                              IMPLEMENT
                                  ↓
                               VERIFY
                                  ↓
                              RECONCILE
                         ├─ implementation gap → IMPLEMENT
                         ├─ plan invalidated    → PLAN
                         ├─ spec invalidated    → SPEC
                         └─ contract satisfied  → ACCEPT
                                                   ↓
                                                 MERGE
                                                   ↓
                                                RELEASE
                                                   ↓
                                            POST-RELEASE CHECK
```

A repository may use RFCs, ADRs, issues, milestones, project fields, PRs, or release records to represent these states. Respect local conventions rather than inventing parallel tracking systems.

## Intake and Assessment

At intake, identify:

- desired outcome
- affected product/technical surface
- consequence of failure
- architectural or interface impact
- unresolved product decisions
- dependencies and rollout constraints
- evidence required to know the work is complete

Use a specification/RFC when the work materially changes architecture, public interfaces, schemas, compatibility guarantees, security posture, operational behavior, or contains unresolved decisions whose answers affect implementation shape.

Do not require an RFC for small, local, reversible, well-understood changes merely because one could be written.

## Planning

Turn an accepted objective or specification into bounded executable work with explicit acceptance criteria.

A plan should identify:

- work items and dependencies
- ownership or integration boundaries
- acceptance evidence per meaningful unit
- sequencing constraints
- migration, compatibility, or rollout needs
- conditions that invalidate the plan

Invoke `execute` when a bounded unit is ready to perform. Supply the objective, scope, constraints, authority, and acceptance contract; let `execute` choose topology, models, providers, and tools.

## Verification and Reconciliation

Invoke `verify` when independent evidence is required. Verification should receive the contract and relevant result/evidence without permission to redefine success.

Reconcile the verdict:

- `pass` → advance if all transition requirements are satisfied
- `fail` → return actionable findings to implementation or planning
- `blocked` → resolve missing evidence, environment, authority, or decision
- `contract-gap` → repair the specification/acceptance contract before continuing

When findings reveal architectural assumptions were wrong, move back to SPEC or PLAN rather than treating every failure as an implementation bug.

## Acceptance and Merge Readiness

Acceptance is a lifecycle decision, not merely a green test run.

Before ACCEPT, require the evidence appropriate to the work, which may include:

- implementation matches the accepted specification or bounded objective
- required tests and CI pass
- independent QA/review findings are resolved or explicitly accepted
- compatibility/migration guarantees hold
- unresolved deviations are documented
- required operational or rollback evidence exists

Merge readiness means the work has satisfied its acceptance contract and merge authority exists. It does not itself grant permission to merge.

## Release

Release policy should follow repository/project conventions. Before release, establish:

- what artifact/version/commit is being released
- deployment or migration ordering
- rollout and observation strategy
- rollback or recovery path
- post-release checks
- explicit authority for deployment/publication

After release, run the required post-release verification. If it fails, follow the documented rollback/recovery path or re-enter planning/implementation as appropriate.

## State Reconstruction

When entering existing work, inspect durable artifacts before deciding the next action. Prefer, in order of local relevance:

- active RFC/spec/ADR and its status
- issue/milestone/project state
- implementation branch or PR
- review findings
- CI/test status
- merge state
- release/deployment records
- documented follow-ups

Summarize reconstructed state compactly:

```yaml
work_item: <durable identifier>
phase: <semantic lifecycle state>
contract: <source of acceptance criteria>
implementation: <branch/pr/commit if any>
verification: <current verdict/evidence>
blockers: [<material blockers>]
next_action: <single next lifecycle action>
```

If evidence conflicts, state the conflict and resolve it before advancing.

## Boundaries

- `flow` decides **what happens next** and owns lifecycle transitions.
- `execute` decides **how bounded work gets done**.
- `verify` decides **whether supplied claims/contracts hold**.

Do not absorb model-routing or delegation policy into this skill. Do not ask `execute` to decide lifecycle acceptance, and do not ask `verify` to implement its own findings unless a later `flow` decision authorizes execution.
