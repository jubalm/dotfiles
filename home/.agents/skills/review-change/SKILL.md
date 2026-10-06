---
name: review-change
description: Review a pull request, diff, commit set, or updated change for supported regressions, incomplete behavior, invariant violations, and consequential maintenance costs. Use for code review and re-review after fixes or rebases; report current-revision findings and material verification limits.
---

# Review Change

Assess the proposed change against its intended behavior and project constraints. Report supported merge risks, not review-shaped commentary. Use this procedure independently; when a broader verification workflow is active, keep its contract and verdict format and treat change review as one evidence source.

## Ground the review

1. Establish the intended change from the request, issue, approved requirements, or other project-designated sources. Identify affected contracts and invariants. Distinguish desired behavior from observed implementation; code and tests can share the same defect.
2. Read applicable repository guidance and relevant architecture, schemas, migrations, dependency versions, and existing behavior. Do not assume a specification file exists or overrides every other source.
3. Identify the exact base and current head. Inspect the actual diff and enough surrounding callers and state to trace consequences. Include earlier commits in a commit-set review when they affect the changed behavior.
4. Use previous comments as leads, then verify them against the current head. Close out resolved concerns in the report; do not repeat them as current findings. After a rebase, refresh comparison points and line locations rather than reviewing a cached diff.
5. Surface material contract ambiguity or inaccessible artifacts. Continue checks that are independently meaningful, but do not imply that an incomplete review establishes merge readiness.

## Trace behavior and evidence

Follow changed inputs through state transitions, side effects, persisted data, and failure paths. Select relevant risks: stale-state or race behavior, silent no-ops, retry or cleanup errors, compatibility and migration failures, trust-boundary changes, inconsistent policy, and incomplete requested behavior.

Understand departures from existing architecture before judging them. Allow deliberate replacement or simplification when the intended consequences are clear. Do not invent an architecture during review or treat every established component as permanent.

Check tests and evidence against the actual claims. Run or inspect checks that materially distinguish correct from incorrect behavior; identify missing coverage only when it leaves a specific important claim unsupported. Separate checks run, results merely supplied, and paths inspected without execution. Do not require unrelated test expansion.

## Admit a finding only with support

Require all of the following:

- **Location and trigger:** Identify the current code location and the input, state, or sequence that activates the problem.
- **Mechanism and evidence:** Trace how the change causes it. Support it with a reproducible check or a complete code path; do not require a runtime reproduction when inspection establishes the failure.
- **Credible consequence:** Explain the behavioral, security, data, compatibility, acceptance, or maintenance cost.
- **Correction direction:** Suggest the smallest useful correction or the guarantee to restore, without demanding an ungrounded redesign.

For maintenance findings, identify concrete coupling or an existing obligation made harder to preserve. For example: two admission callers now implement the same policy separately and can make different decisions for the same input; route both through the existing classifier. "This looks duplicated" alone is insufficient.

Discard unsupported hypotheses, preferences, compliments, diff narration, and repeated findings. Use a targeted check to resolve a suspicion when practical. Put unresolved verification gaps in review limits rather than presenting them as confirmed defects. Do not manufacture a finding to fill a category or quota.

## Report with calibrated conclusions

Follow the repository's required reporting format. Otherwise label actual findings **BLOCKING** or **NON-BLOCKING**; omit empty categories.

Use BLOCKING for a supported material regression, contract violation, incomplete required behavior, or a concrete cost that makes merging unreasonable. Use NON-BLOCKING only for actionable improvements with a credible consequence. Avoid style nits unless requested or required by project conventions. Keep impact separate from confidence; low confidence is a reason to investigate or qualify, not to exaggerate severity.

State the reviewed base/head, findings, relevant checks or evidence, and material limits. If artifacts are unavailable or important contracts remain ambiguous, say the review is incomplete. Otherwise report "No material findings" when appropriate, scoped to the revision and checks performed; do not turn that into a claim that every behavior is verified.

Before posting a review or declaring a current verdict, check whether the head moved. If it did, refresh affected evidence and locations or explicitly scope the report to the older revision. Do not carry approval onto unreviewed commits.

Return a report by default. Post comments, apply fixes, or perform lifecycle actions only when included in the request; a clean review alone does not authorize them.
