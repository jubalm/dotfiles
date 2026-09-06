# Model Profiles

This directory is for maintained, per-model execution notes used by `execute` after runtime discovery confirms that a model is actually available.

Do not treat profiles here as an inventory. The harness's current model catalog is authoritative.

## Add a profile when

A model has decision-useful, evidence-backed behavior that cannot be expressed cleanly in the generic capability routing rules, such as:

- reliable role strengths or limits
- reasoning-effort behavior
- context or tool constraints
- prompt-shape adaptations
- modality-specific behavior
- repeated local observations that materially affect routing

Do not add profiles just to enumerate available models.

## Required shape

Each profile should state:

- exact model identity or alias scope
- provider
- evidence source
- observation/guidance date or relevant runtime version
- confidence
- capability notes by role
- prompting adaptations
- known constraints
- freshness/revalidation trigger

Use `../references/model-guidance.md` as the policy contract.

## Freshness rule

A profile is advisory and perishable. Runtime evidence and current official guidance override it. If the alias may have been retargeted, the provider changed model behavior, or the harness changed supported controls/tools, revalidate before using the profile for a consequential route.
