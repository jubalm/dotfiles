# Execution Preflight

## Purpose

The execution preflight is a compact operational contract created before meaningful delegated execution. It separates workflow intent from the concrete execution strategy chosen for the current task.

It answers three questions:

1. What bounded work must happen?
2. What capabilities and evidence does each step require?
3. What should cause the operator to revise, reroute, or escalate the plan?

The preflight is not a mandatory approval ritual. It exists to make execution inspectable and adaptable before work fans out.

## Contract

A preflight should contain only information that changes execution decisions.

```yaml
goal: <bounded desired outcome>

steps:
  - id: <stable step id>
    objective: <decision-complete objective>
    owner: <operator or delegated role>
    requires:
      reasoning: <routine|cross-cutting|consequential>
      tools: [<required tools or modalities>]
      context: <relevant evidence or context constraints>
    route:
      adapter: <selected runtime adapter>
      model: <selected runtime model>
      rationale: <why this is the smallest sufficient route>
    verify:
      evidence: <observable completion evidence>
      reviewer: <operator|independent role|none>
    authority:
      class: <probe|write|consequential>
      allowed_effects: [<bounded effects>]
    escalate_when:
      - <observable condition>
```

Do not populate `route` from memory before runtime model and adapter discovery. Capability requirements come first; routing comes second.

## Granularity

Use the smallest number of steps that preserves meaningful ownership and verification boundaries.

Do not split work merely to justify more agents. Keep tightly coupled implementation under one owner unless isolation produces a clear benefit. Separate steps when they differ materially in required capabilities, authority, evidence, or independence needs.

## Authority

### Probe / low risk

Read-only investigation or bounded low-risk work may proceed after a lightweight preflight. The operator remains responsible for synthesis and the completion claim.

### Routine write / medium risk

The operator evaluates the preflight before execution. If the user already authorized the requested write scope, no additional human confirmation is required unless the plan introduces new scope, cost, sensitive access, or external effects.

### Consequential

Security-sensitive changes, credentials, spending, deployment, publication, destructive actions, and shared external effects retain explicit authority boundaries. A technically valid plan does not grant authority to perform the effect.

## Adaptation Loop

Treat the preflight as revisable state, not a frozen plan.

After each load-bearing discovery or result:

1. compare actual evidence with the planned assumptions
2. update capability, context, or risk requirements if needed
3. reroute only the affected step or downstream dependency
4. preserve completed evidence and durable state
5. re-check guarantees affected by the change

Prefer local plan repair over restarting the whole workflow.

## Rerouting Triggers

Re-evaluate a route when any of these become true:

- the task crosses an architectural boundary not represented in the plan
- the selected executor lacks necessary context, tools, or modality support
- repeated corrections indicate the capability threshold was underestimated
- the implementation changes a public interface, schema, deployment order, or compatibility guarantee
- reviewer evidence conflicts with executor evidence
- security, privacy, data-integrity, or destructive consequences emerge
- execution cost or context pressure grows enough that a different topology is clearly better

Escalation means increasing capability, independence, or authority review only as needed. It does not necessarily mean choosing a more expensive model.

## Planning Versus Execution

The planner, executor, integrator, and reviewer may use different models. Assign each independently from its capability requirements.

A common efficient shape is:

```text
request
  -> operator/planner creates preflight
  -> bounded executor performs implementation
  -> operator or independent verifier checks evidence
  -> operator integrates and claims completion
```

For simple work these roles may collapse to one model. For consequential work, preserve independence where correlated failure would undermine the result.

## Reports

Every delegated step should return:

- work completed
- evidence collected
- deviations from the preflight
- unresolved questions or blockers
- effects already performed
- recommended rerouting or escalation, if any

The operator decides whether those recommendations change the plan.
