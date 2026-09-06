# Model Routing

## Principle

Choose the smallest sufficient model configuration from the models actually available in the current harness. Optimize both total token cost and coordinator-context use. Do not infer availability, pricing, limits, or capabilities from model names already present in conversation context.

Routing is capability-driven and provider-agnostic. A provider name, family, or familiar alias is never itself a reason to select a model.

Use `model-guidance.md` and any applicable profile under `../models/` only as advisory evidence after runtime discovery confirms the model is available. Runtime evidence wins.

## Runtime Inventory

Use the harness's authoritative model listing or configuration surface. Normalize relevant candidates before assigning roles:

| Field | Decision use |
|---|---|
| Model and provider | Exact selectable identity |
| Capability tier | Routine, cross-cutting, or consequential reasoning |
| Relative cost | Expected total usage, not price per token alone |
| Context limit | Fit for the evidence and handover |
| Reasoning controls | Available effort levels and their cost |
| Tool and modality support | Fit for code, images, browsing, or structured work |
| Role strengths | Planning, bounded execution, integration, review, or validation |
| Source and confidence | Runtime evidence and unresolved uncertainty |

If required metadata is unavailable, state the uncertainty and use a defensible known option or ask the user. Never fabricate a catalog fact.

## Selection

For each preflight step:

1. Define the minimum capabilities the role requires before naming a model.
2. Filter to runtime-available candidates with the necessary tools, modalities, context, and authority fit.
3. Consult maintained model guidance only for candidates that remain viable after runtime filtering.
4. Use cheaper capacity for bounded execution when it will not create supervision or rework cost.
5. Allocate stronger reasoning to consequential planning, integration, adversarial review, and escalation when justified.
6. Keep the topology small; a separate model is not required for every role.
7. Use an independent model or reviewer when correlated failure would undermine a load-bearing claim.
8. Select the lowest sufficient reasoning effort: low or medium for routine work, high for demonstrated complexity, and maximum only when evidence warrants it.
9. Present one recommended routing configuration with a short rationale, not a menu of combinations.

Planning and execution do not need to use the same model. Prefer specialist or cheaper executors for well-bounded work when a stronger planner can provide a decision-complete handoff.

## Prompt Adaptation

Model selection and prompting are coupled. Start from the neutral role contract in `prompting.md`, then shape the handoff around runtime-supported or maintained evidence-backed characteristics rather than generic stereotypes.

Useful adaptations include:

- tighter scope and explicit acceptance criteria for weaker or cheaper executors
- more durable context and explicit dependency boundaries when context limits are tight
- structured evidence requirements for models used in review or validation
- reduced decomposition overhead for models that can reliably integrate larger cross-cutting tasks
- modality- or tool-specific instructions only when the selected model actually supports them

Do not encode provider folklore as policy. If a prompt adaptation is not supported by current evidence or maintained model guidance, prefer a neutral bounded prompt.

## Rerouting and Escalation

A routing decision is provisional. Re-evaluate it when execution reveals:

- broader architectural scope than planned
- unexpected cross-module or cross-service coupling
- context overflow or missing evidence
- repeated implementation or reasoning failure
- conflicting reviewer evidence
- security, deployment, compatibility, or data-integrity consequences
- a need for a modality or tool the selected model does not support

When rerouting, preserve durable state: original objective, completed work, evidence, deviations, unresolved questions, and the smallest useful delta for the next model. Do not restart from scratch unless prior state is untrustworthy.

## Known Conditional Mapping

Apply this ladder only when runtime discovery confirms these aliases and their current capabilities:

| Model | Suitable role |
|---|---|
| Luna | Bounded implementation, tests, and well-specified fixes |
| Terra | Cross-cutting implementation, difficult debugging, integration, and nuanced review |
| Sol | Consequential architecture, security-sensitive validation, conflicting evidence, and final escalation |

These are optional routing defaults, not an authoritative inventory. Runtime evidence wins. Models from other providers or local/specialist runtimes should compete on the same capability requirements when available.
