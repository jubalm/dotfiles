# Prompting by Role

## Principle

Prompt the selected model for the role it is performing in this execution, not for a generic assistant persona. The handoff should be decision-complete, bounded, and explicit about evidence and stop conditions.

Model-specific adaptations come after this role contract and only when supported by `model-guidance.md` or current authoritative guidance.

## Planner

A planner receives the objective, constraints, known evidence, authority boundary, and acceptance contract. Require it to return:

- bounded execution steps
- dependencies and ownership
- capability requirements per step
- verification evidence per step
- material assumptions and uncertainties
- escalation conditions

Do not ask the planner to implement unless combining roles clearly reduces overhead without weakening review independence.

## Executor

An executor receives one bounded, decision-complete objective. Include:

- exact owned surface
- relevant context and dependencies
- allowed effects and prohibited scope expansion
- acceptance criteria that apply to its step
- required evidence/report shape
- stop and escalation conditions

Require it to report completed work, evidence, deviations, blockers, and effects already performed. It may recommend a plan change but does not silently broaden scope or redefine acceptance.

## Integrator

An integrator receives outputs from multiple bounded steps plus the original contract. Require it to:

- reconcile interfaces and conflicting assumptions
- preserve accepted behavior outside the change
- identify unresolved integration risk
- produce integration evidence
- avoid inventing new product decisions

Use a stronger or broader-context model when integration itself becomes the load-bearing reasoning task.

## Reviewer

A reviewer receives the immutable acceptance contract, implementation/result, and relevant evidence. It should be instructed to seek disconfirming evidence rather than optimize for agreement with the executor.

Require:

- verdict against the supplied contract
- numbered findings ordered by consequence
- concrete evidence for each finding
- distinction between blocker, non-blocker, uncertainty, and contract gap
- no implementation changes unless review-and-fix was explicitly requested

When correlated failure matters, prefer a reviewer with independent model/context lineage from the executor.

## Scout

A scout answers one bounded unknown. Keep it read-only unless reclassified. Require:

- the question investigated
- evidence surface inspected
- concise findings
- confidence/uncertainty
- recommended next step, if any

A scout does not turn investigation into implementation.

## Handover shape

Use this compact structure when the harness benefits from explicit handoffs:

```yaml
role: <planner|executor|integrator|reviewer|scout>
objective: <bounded outcome>
owned_surface: <files/resources/domain>
context: <only relevant durable context>
constraints:
  - <constraint>
acceptance:
  - <observable criterion>
authority:
  allowed: [<effect>]
  forbidden: [<effect>]
evidence_required:
  - <evidence>
escalate_when:
  - <condition>
report:
  - completed
  - evidence
  - deviations
  - blockers
  - effects
```

## Adaptation rule

Start from the neutral role prompt above. Adapt granularity, explicitness, context packaging, report structure, tool instructions, or reasoning controls only when runtime capabilities or maintained model guidance justify it. If uncertain, keep the prompt neutral and bounded rather than applying provider stereotypes.
