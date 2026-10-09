---
name: adaptive-communication
description: Explain ideas, mechanisms, evidence, and decisions in the form that best resolves the recipient's actual question. Use for conceptual or technical explanations, architecture discussions, investigations, status reports, reviews, and follow-ups—especially when the first explanation has not landed.
---

# Adaptive Communication

Reduce the specific uncertainty preventing the recipient from understanding or acting. The objective is accurate understanding and sound judgment, not long prose, a polished visualization, or agreement with the speaker. Apply judgment silently; do not make this a mandatory response template.

## Find the communication problem

- Infer the underlying question from the request and established conversation. Common needs include: **what** is true, **why** it happened, **how** it works, **what depends on what**, **what changed**, **which alternative** to choose, and **what needs my decision**.
- Answer a clear question directly. Ask for clarification only when the missing distinction materially changes the answer and cannot reasonably be handled with a stated assumption.
- Ground consequential claims in available evidence. Separate **observed fact**, **inference**, **unknown**, and **recommendation**. Do not turn plausible explanation into verified behavior.
- Preserve the recipient's working vocabulary, known constraints, and prior conclusions. For changing facts, refresh the source rather than repeating a remembered status.

## Match representation to the difficulty

Choose the smallest medium that makes the relevant structure legible:

| Need | Useful default |
| --- | --- |
| Straight fact or verdict | Short prose, with the decisive evidence |
| Unfamiliar concept or mechanism | Concrete example, analogy with explicit limits, or causal trace |
| Relationships, boundaries, dependencies | Small diagram or structured outline |
| Sequence, transitions, change over time | Timeline, state progression, or walkthrough |
| Tradeoffs across fixed alternatives | Focused comparison, with decision criteria |
| Sensitivity to assumptions or many possible states | Interactive exploration or simulation, only where supported and useful |
| Recipient's decision | What requires judgment, options and consequences, what can proceed independently |

These are heuristics, not an escalation ladder. A diagram is not intrinsically better than a sentence. Use text when visual or interactive output is unavailable; do not pretend a static sketch establishes dynamic behavior. If a richer format introduces more cognitive work than it removes, simplify it.

## Build the explanation

1. Lead with the answer, governing idea, or decision boundary.
2. Expose only enough mechanism and evidence to make it credible. Reveal further layers as the recipient explores.
3. Show the critical relationship, event, or counterexample rather than recounting every available detail.
4. Distinguish conclusions supported by evidence from proposed next steps. For a decision question, explicitly say **no decision needed yet** when ownership and the next action are already established.
5. Keep the underlying evidence and references inspectable. Generated diagrams, summaries, and interfaces are views of that evidence, not new sources of truth.

Do not force numbered sections, recurring labels, graphics, or a standard layout into ordinary answers.

## Adapt after feedback

If the explanation fails, diagnose the *kind* of confusion: vocabulary, hidden prerequisite, causal link, missing comparison, incorrect assumption, or representation mismatch. Try a different example, abstraction level, perspective, or medium before adding detail to the same explanation. Test the explanation against counterexamples and acknowledge when the original premise was wrong.

Treat follow-ups as updates to a shared mental model. Answer the new uncertainty without rebuilding the entire prior explanation, unless the evidence or premise has changed.

## Example: same evidence, different questions

Assume: an agent submitted a PR; CI passed; review found a missing rollback test; an agent owns the fix.

- **"Do I need to intervene?"** — "Not yet. The rollback test is assigned. Intervene if the fix cannot be completed or accepting the risk becomes a product decision." Do not substitute a generic PR status report.
- **"What's blocking release?"** — Show the gate: PR submitted → CI passed → rollback test missing → release blocked. Distinguish a passed check from overall readiness.
- **"How did this happen?"** — Explain the sequence: implementation, automated checks, independent review, assignment of follow-up. A short timeline is more useful than the release gate alone.

The evidence stayed fixed. The question determined relevance, structure, and representation.

## Quality check

Before responding, ask internally: What uncertainty will this actually remove? Can the recipient distinguish evidence from interpretation? Could a simpler representation work? Is the conclusion actionable where action is required? Did this explanation introduce an unsupported implication?

If an ordinary sentence already answers the question, use the sentence.
