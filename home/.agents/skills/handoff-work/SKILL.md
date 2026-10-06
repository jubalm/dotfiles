---
name: handoff-work
description: Prepare a compact, executable assignment or continuation handoff for a contributor or agent. Use when handing over implementation, investigation, fixes, or resumed work, including cloud-agent prompts and issue-based assignments; adapt context to the recipient's actual access.
---

# Handoff Work

Transfer the intended outcome and the information the recipient cannot safely reconstruct. Keep the assignment usable without assuming another skill has been loaded. Prepare the handoff; do not launch workers or publish it unless the request includes that action.

## Establish the task and baseline

1. Read applicable project guidance and the sources relevant to the requested change. Establish the repository, work item, current branch or revision, intended outcome, and known constraints.
2. Distinguish requested work from completed effects, proposals, and unresolved decisions. Preserve approved acceptance criteria; do not silently narrow success or invent product behavior to fill a material gap.
3. Determine what the recipient can access: repository, issue, evidence, tools, and runtime. If access is unknown, state the assumption or include the necessary context. Do not make an indispensable instruction depend solely on an inaccessible link.
4. Reference a revision when the identity of the inspected or verified artifact matters. For work against a moving branch, identify the inspected baseline and tell the recipient to refresh it before editing; do not present old state as current.

## Construct the smallest sufficient assignment

Normally use three elements, without forcing three sections:

- **Goal:** State the resulting behavior or the question to answer, including why a non-obvious constraint matters.
- **Scope:** Identify affected surfaces, existing policy boundaries, dependencies, and excluded work that prevents plausible scope drift. Prescribe implementation details only when an established contract requires them.
- **Acceptance:** Give observable outcomes, appropriate checks, and the expected return artifact. Require a PR, report, screenshot, or experiment record when the request or project workflow calls for it; do not assume every task requires all of them.

Add context only when necessary: canonical references, selected excerpts, rationale, environment/version constraints, or a material decision that must be resolved before dependent work. Use routine implementation judgment for choices left open by the contract.

Make references precise and usable: repository and path, relevant issue or document, and revision where required. Include a concise excerpt or faithful summary when the recipient lacks access. Do not claim an unavailable source was read. If essential context is unavailable to both parties, name the gap instead of fabricating a complete assignment.

Select checks from current scripts, tests, and supported runtime behavior. Do not prescribe remembered commands or treat green CI as evidence for behavior it never exercises. Keep required checks proportionate to the actual change.

For an investigation or probe, state the question, fidelity required, evidence to collect, and stopping condition. Allow a negative or inconclusive result; do not make building a product the implicit success criterion.

For a continuation, state the work already done, exact artifact or branch, checks performed and pending, unresolved concerns, and the next bounded action. Do not retell the conversation.

## Preserve completion and authority

Distinguish implementation, verification, review, and acceptance. "Done" must include the requested behavior, relevant evidence, and the required handoff artifact. Never turn an agent's completion claim into verified success.

Carry forward the effects authorized by the request and local instructions. Make any necessary boundary clear, especially whether work ends at local edits, a pushed branch, or a PR. Do not grant merge, deployment, or publication authority through a generic template, and do not demand new confirmation for actions already authorized.

Request unresolved material decisions before dependent execution; allow independent work to continue. Avoid catch-all escalation instructions that force the recipient to ask about ordinary implementation choices.

## Check and return

Read the assignment as the recipient: can they identify the target, act within scope, preserve important constraints, and demonstrate completion with the access provided? Remove repeated project explanations when a reliable reference suffices. Include context where references alone would lose intent or make the assignment unusable.

Return the complete, compact handoff and any indispensable missing decision. If an existing assignment already supplies everything, reference it and add only the needed delta. Treat repeatedly elaborate prompts as a reason to examine repository context, not as a reason to omit necessary task detail.
