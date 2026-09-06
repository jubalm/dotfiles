---
name: execute
description: Use when bounded work must be performed directly or through delegated agents; when execution needs preflight, model/tool routing, supervision, adaptation, or evidence-backed completion; or when another skill supplies an objective and acceptance contract to carry out.
---

# Execute

## Overview

Execution turns an authorized, bounded objective into effects and evidence. Delegation is optional: zero workers is valid. Choose the smallest sufficient execution topology while the operator retains scope, synthesis, authorization, and the completion claim.

The caller defines what outcome is required. An execution preflight defines how this instance will happen. Runtime routing decides which model, provider, tool, or adapter should perform each bounded step.

## Directives

- Delegate only when expected token, context, latency, specialization, isolation, or verification benefit exceeds handoff and supervision cost.
- Optimize total token use and coordinator-context pressure.
- Detect runtime capabilities before choosing an adapter or model; availability never forces use.
- Keep product decisions and ungranted external effects with the operator.
- Never absorb unrelated resources or infer lifecycle state owned by `flow`.
- Do not hard-code providers or models to roles when runtime discovery can make a better assignment.
- Separate planning, execution, integration, and review when doing so materially reduces correlated failure or cost.
- Do not redefine acceptance criteria supplied by the caller. If the contract is inadequate or contradictory, surface that instead of silently repairing it.

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

**REQUIRED REFERENCES:** Read `references/model-routing.md` before assigning models. Read `references/execution-preflight.md` before delegated write or consequential execution.

Recommend one best topology, adapter, and routing configuration with a brief rationale. Different roles may use different models. Mention alternatives only when the recommendation is unavailable, materially more expensive, or genuinely ambiguous.

## Execution Preflight

Before meaningful delegated execution, outline the execution shape before performing it. The preflight is an operational contract, not a prose status update.

For each bounded step, state:

- objective and ownership
- required capabilities and relevant context
- proposed adapter/model only after runtime discovery
- expected evidence or verification
- authority boundary and side effects
- escalation or rerouting conditions

The preflight may be revised when new evidence changes scope, risk, context requirements, or capability needs. Do not preserve a stale routing decision merely because execution has started.

Authority defaults:

- Probe or low-risk bounded work: preflight, then proceed.
- Routine write or medium-risk work: preflight, operator evaluation, then proceed unless new authorization is required.
- Consequential work: preflight and retain explicit human authority for actions that require it.

Do not turn preflight into a mandatory human confirmation gate for routine work.

## Consent Gate

- Requested read-only probe: announce a lightweight brief, then proceed.
- Explicit execution request: present the execution plan, then proceed without a second confirmation unless it introduces unexpected scope, cost, sensitive access, writes, or external effects.
- Proactive execution recommendation: present it and wait for approval.
- If a probe needs mutation or sensitive access, stop and reclassify it.

A probe brief names the question, evidence surface, scout/model, report shape, and stop condition. A write or consequential plan names the delegation advantage, adapter, topology, role/model assignments, ownership, isolation, token/context rationale, evidence, review, authority, and escalation conditions.

## Execution and Supervision

Read-only scouts may inspect the operator workspace. During delegated writes, the operator workspace remains read-only and every writer uses an isolated worktree or sandbox. Concurrent writers require separate environments, explicit ownership, frozen interfaces, and named integration responsibility. One writer owns each coupled surface.

Give each role a bounded prompt and require changes, evidence, deviations, and pending items in its report. Adapt delegated prompts to the selected model's known operating characteristics when runtime evidence supports doing so; do not fabricate provider-specific behavior. Preserve the same worker context across corrections when possible; otherwise hand over durable state and a bounded delta. On timeout or ambiguity, inspect native status, output, and effects before intervening.

Planning and execution models may differ. A stronger reasoning model may decompose or integrate while a cheaper or specialist model executes bounded work. Escalate or reroute when evidence shows that the selected model is no longer sufficient.

## Evidence and Completion

Execution must return enough durable evidence for the caller or `verify` to judge the contract independently.

For each delegated step, collect:

- work completed
- evidence produced
- deviations from the preflight
- unresolved questions or blockers
- effects already performed
- recommended rerouting or escalation, if any

For routine work, independently check the changed surface before claiming execution complete. For load-bearing or consequential claims, prefer the separate `verify` skill rather than treating executor self-checks as independent validation.

Stop when current evidence supports the execution contract or a documented blocker requires judgment; never loop indefinitely or narrow scope to manufacture success.

Before claiming completion, verify required checks and one load-bearing result, then confirm diff, workspace, owned-resource cleanup, and external effects. Commit, push, merge, ready, deploy, publish, spend, and similar effects require authority. Technical success never implies approval.

## References

- `references/execution-preflight.md` — execution-plan contract, authority levels, rerouting, and adaptation
- `references/model-routing.md` — runtime model discovery and smallest-sufficient role assignment
- `verify` — independent contract validation when correlated failure or consequence warrants separation
- `herdr` — Herdr-specific launch, lifecycle, evidence, continuation, and cleanup mechanics
