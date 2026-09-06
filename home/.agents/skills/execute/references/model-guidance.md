# Model Guidance

## Purpose

This reference is the maintained knowledge layer for model-specific execution guidance. It complements runtime discovery; it never overrides the harness's authoritative model catalog, tool support, context limits, availability, or current provider behavior.

Use it only after the task's capability requirements are known.

## Evidence priority

Prefer model guidance in this order:

1. current runtime metadata and harness behavior
2. current official provider guidance available to the operator
3. maintained repository notes with a clear source/date
4. observed local behavior from recent executions
5. neutral capability-based prompting when evidence is weak

Never infer capability from branding, family names, or remembered launch positioning alone.

## Model profile contract

When maintaining a model profile, record only decision-useful information:

```yaml
model: <runtime-selectable identity or alias>
provider: <provider>
observed_at: <date or runtime version>
source: <runtime|official-guidance|local-observation>
confidence: <high|medium|low>

capabilities:
  planning: <routine|cross-cutting|consequential>
  implementation: <routine|cross-cutting|consequential>
  review: <routine|cross-cutting|consequential>
  multimodal: <supported|unsupported|unknown>
  tool_use: <notes>
  context: <known constraint or unknown>

prompting:
  strengths: [<evidence-backed adaptations>]
  constraints: [<evidence-backed limitations>]
  avoid: [<known failure-inducing patterns>]
```

Profiles are advisory. Runtime evidence wins whenever there is disagreement.

## Capability families

Route by the work, not by provider:

- **Planner** — decomposition, ambiguity resolution, dependency analysis, risk judgment, acceptance framing.
- **Executor** — bounded implementation, transformation, investigation, test authoring, operational steps.
- **Integrator** — cross-cutting synthesis, conflict resolution, migration ordering, interface reconciliation.
- **Reviewer** — adversarial analysis, regression search, spec compliance, evidence conflict resolution.
- **Specialist** — modality, language, framework, tool, local/privacy, or domain-specific advantage.

A single model may serve multiple families when the topology remains simpler and sufficiently reliable.

## Prompt adaptation

Model-specific prompting should change only what materially improves execution. Typical adaptation axes:

- task granularity and amount of decomposition
- explicitness of acceptance criteria
- amount and durability of supplied context
- output/report structure
- tool-use instructions
- reasoning effort or deliberation controls
- degree of autonomy versus checkpoints
- reviewer independence requirements

Do not maintain folklore such as "provider X always needs terse prompts". Record a behavior only when current guidance or repeated local evidence supports it.

## Freshness

Treat maintained profiles as perishable. A model update, alias retarget, provider release, harness change, or tool-support change can invalidate prior guidance. When a consequential routing decision depends on a stale or uncertain note, re-check an authoritative current source before relying on it.
