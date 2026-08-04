---
name: orchestrate
description: Use when a user asks to orchestrate, coordinate, dispatch, or delegate work; requests subagents, multi-agent, or supervised execution; or when consequential work may benefit from independent execution or review.
---

# Orchestrate

## Overview

Orchestration is an operator-local decision: choose the smallest sufficient topology while the operator retains scope, synthesis, authorization, and the completion claim. Zero workers is valid. Nexus, Flue, and remote workflow delegation are outside this skill's current scope.

## Directives

- Delegate only when the expected token, context, latency, specialization, or verification benefit exceeds handoff and supervision cost.
- Optimize both total token use and coordinator-context pressure.
- Detect capabilities before choosing an adapter or model; availability never forces use.
- Keep product decisions and ungranted external effects with the operator.
- Never absorb unrelated resources or infer lifecycle state.

## Evaluation

Use judgment, not numeric thresholds:

1. What concrete advantage does delegation provide?
2. Is the assignment bounded and decision-complete for its role?
3. Can ownership, authority, evidence, and a stop condition be stated?
4. Does the advantage exceed coordination and review overhead?

If no advantage is defensible, work directly. A scout may investigate one bounded unknown.

| Class | Boundary |
|---|---|
| Probe | Read-only; no secrets, writes, or external effects |
| Write | Filesystem or repository mutation |
| Consequential | Security, credentials, spending, deployment, publication, destructive action, or shared effects |

## Discovery and Strategy

Before launching anything, inventory the local harness's adapters, isolation and continuation capabilities, and actual model catalog. Prefer native delegation when sufficient. When `HERDR_ENV=1`, surface Herdr as an available visible-pane adapter rather than automatically preferring it. If Herdr is selected, use the `herdr` skill for mechanics.

**REQUIRED REFERENCE:** Read `references/model-routing.md` before assigning models.

Recommend one best topology, adapter, and model-routing configuration with a brief rationale. Different roles may use different models. Mention alternatives only when the recommendation is unavailable, materially more expensive, or genuinely ambiguous.

## Consent Gate

- Requested read-only probe: announce a lightweight brief, then proceed.
- Explicit orchestration request: present the orchestration plan, then proceed without a second confirmation unless it introduces unexpected scope, cost, sensitive access, writes, or external effects.
- Proactive orchestration recommendation: present it and wait for approval.
- If a probe needs mutation or sensitive access, stop and reclassify it.

A probe brief names the question, evidence surface, scout/model, report shape, and stop condition. A write or consequential plan names the delegation advantage, adapter, topology, role/model assignments, ownership, isolation, token/context rationale, evidence, review, authority, and escalation conditions.

## Execution and Supervision

Read-only scouts may inspect the operator workspace. During delegated writes, the operator workspace remains read-only and every writer uses an isolated worktree or sandbox. Concurrent writers require separate environments, explicit ownership, frozen interfaces, and named integration responsibility. One writer owns each coupled surface.

Give each role a bounded prompt and require changes, evidence, deviations, and pending items in its report. Preserve the same worker context across corrections when possible; otherwise hand over durable state and a bounded delta. On timeout or ambiguity, inspect native status, output, and effects before intervening.

## Review and Completion

- Probe: the operator evaluates the evidence.
- Routine write: the operator independently verifies the work.
- Consequential work: use an independent reviewer or verifier.

Return numbered findings to the writer and re-check affected guarantees after corrections. Stop when current evidence supports the contract or a documented blocker requires judgment; never loop indefinitely or narrow scope to manufacture success.

Before claiming completion, verify required checks and one load-bearing result, then confirm diff, workspace, owned-resource cleanup, and external effects. Commit, push, merge, ready, deploy, publish, spend, and similar effects require authority. Technical success never implies approval.

## References

- `references/model-routing.md` — runtime model discovery and smallest-sufficient role assignment
- `herdr` — Herdr-specific launch, lifecycle, evidence, continuation, and cleanup mechanics
