---
name: verify
description: Use when an implementation, claim, release, or other result must be validated against an explicit contract; when independent QA, CI/test interpretation, adversarial review, regression analysis, or load-bearing evidence is required; or when another skill needs an evidence-backed verdict without changing the work.
---

# Verify

## Overview

Verification establishes whether a supplied contract or claim holds. It answers: **Did the result actually satisfy what was required?**

Verification is independent from execution semantics. Do not implement fixes, redefine success, or silently broaden/narrow scope while verifying. Return evidence and findings so `flow` or the caller can decide what happens next.

## Contract First

Before verifying, identify the contract source and normalize it into observable claims.

A verification contract should state:

- required behavior or outcome
- relevant invariants and non-regression guarantees
- evidence surfaces available
- environment or version being checked
- explicitly accepted deviations, if any
- consequence or criticality of failure

If the contract is missing, contradictory, or not testable, return `contract-gap` rather than inventing acceptance criteria.

## Independence

Choose the level of independence proportional to correlated-failure risk:

- routine/local claim: operator verification may be sufficient
- cross-cutting or user-visible change: prefer an independent review pass
- consequential/security/data-integrity/release claim: use independent evidence and, when available, an independent model or verifier

Independence means the verifier is not relying solely on the executor's conclusion. Executor-produced evidence may be inputs, but load-bearing claims should be checked against primary artifacts or reproducible results when possible.

## Verification Strategy

Select only checks that materially test the contract. Depending on the work, these may include:

- targeted tests
- relevant broader test suites
- CI/check status and logs
- static analysis or type checks
- diff/spec conformance review
- API/schema/compatibility checks
- regression-focused inspection
- security or adversarial analysis
- runtime/manual QA
- deployment health and post-release checks

Do not equate "tests pass" with complete verification when the contract contains claims those tests do not cover.

## Findings

Report actionable findings, not general commentary. Number findings and include:

- severity or consequence
- violated contract claim
- evidence
- affected surface
- smallest useful remediation direction, without implementing it

Distinguish confirmed defects from uncertainty or missing evidence.

## Verdict

Return exactly one semantic verdict:

- `pass` — current evidence supports the contract
- `fail` — one or more contract claims are violated
- `blocked` — verification cannot complete because required evidence/environment/access is unavailable
- `contract-gap` — the supplied acceptance contract is insufficient, contradictory, or materially ambiguous

A `pass` means the checked contract is supported by current evidence; it does not grant merge, deploy, publish, or other external authority.

## Re-checking

After corrections, re-check:

1. every previously failing claim
2. guarantees affected by the correction
3. at least one load-bearing end-to-end result when consequence warrants it

Do not require unrelated revalidation merely because verification is being repeated.

## Report Shape

Use a compact durable report:

```yaml
verdict: <pass|fail|blocked|contract-gap>
contract: <source or normalized contract>
evidence:
  - <load-bearing evidence>
findings:
  - id: V1
    claim: <violated claim>
    severity: <impact>
    evidence: <observable evidence>
    surface: <affected area>
unchecked:
  - <material claim not checked and why>
```

For `pass`, findings should normally be empty. Always disclose material unchecked areas that limit confidence.

## Boundaries

- `verify` establishes truth against a supplied contract.
- `execute` performs or repairs bounded work.
- `flow` decides lifecycle transitions based on the verdict.

Do not turn verification findings directly into mutations unless the caller separately authorizes execution.
