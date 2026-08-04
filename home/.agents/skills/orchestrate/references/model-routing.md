# Model Routing

## Principle

Choose the smallest sufficient model configuration from the models actually available in the current harness. Optimize both total token cost and coordinator-context use. Do not infer availability, pricing, limits, or capabilities from model names already present in conversation context.

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

1. Define the minimum capability each role requires.
2. Use cheaper capacity for bounded execution when it will not create supervision or rework cost.
3. Allocate stronger reasoning to consequential planning, integration, adversarial review, and escalation when justified.
4. Keep the topology small; a separate model is not required for every role.
5. Use an independent model or reviewer when correlated failure would undermine a load-bearing claim.
6. Select the lowest sufficient reasoning effort: low or medium for routine work, high for demonstrated complexity, and maximum only when evidence warrants it.
7. Present one recommended routing configuration with a short rationale, not a menu of combinations.

## Known Conditional Mapping

Apply this ladder only when runtime discovery confirms these aliases and their current capabilities:

| Model | Suitable role |
|---|---|
| Luna | Bounded implementation, tests, and well-specified fixes |
| Terra | Cross-cutting implementation, difficult debugging, integration, and nuanced review |
| Sol | Consequential architecture, security-sensitive validation, conflicting evidence, and final escalation |

These are optional routing defaults, not an authoritative inventory. Runtime evidence wins.
