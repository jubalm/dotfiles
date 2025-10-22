# Real-World Examples by Domain

Quick reference: actual Memory snippets per domain. Copy-paste ready.

---

## Frontend: React Application

**Client-Server Boundary**
✓ Server: data fetching, auth checks, secrets
✓ Client: interactivity, forms, real-time updates
✗ Never fetch secrets in client components
✗ Never do expensive computation on every render
✗ Never add 'use client' unnecessarily (increases bundle)

**State Management**
Redux: Single source of truth.
Selectors → computed state (prevents recompute). Async: redux-thunk.
✗ Never mutate state directly (use immer)
✓ Refactor prop drilling with context

**Styling**
Tailwind: Utility classes, responsive. CSS modules: Component-scoped styles.
✗ Never inline styles in JS
Theme: Colors (brand + semantics), 4px spacing base, mobile-first (sm:/md:/lg:)

**Caching**
Images: 1 year (hash-named files, far-future expires)
Static assets (/public): Revalidate every request
Generated images (/public/generated): Hash-named, 1yr cache
User uploads: CDN, 7d TTL

---

## Backend: Node.js API

**API Design**
Endpoints: GET /items (paginated), GET /items/:id, POST /items, PATCH /items/:id, DELETE /items/:id
Pagination: Default 50, max 500. ✗ Never paginate without sorting.
Errors: HTTP status + JSON {error, code, details}
✗ Never return 200 with error in body

**Database**
Postgres + RLS for multi-tenancy.
✓ Filter all queries by tenant_id (respects RLS)
✗ Never SELECT * without tenant check
Indexes: All FKs, common filters. ✗ Never index without measuring performance.
Connections: Pooled, 10 per instance max.

**Authentication**
Token: 1h access JWT (body) + 7d refresh (httpOnly cookie)
Login: Generate both → access in body (fetch) → refresh in secure cookie
Logout: Blacklist access immediately → revoke refresh + all sessions
Admin override: Email + SMS confirmation required
✗ Never store refresh in localStorage
✗ Never trust access >1h
✓ Validate every request

---

## DevOps: CI/CD Pipeline

**Environments & Deployment**
Dev: Local + Docker. Auto-deploy feature branches → staging.
Staging: AWS t3.medium, auto-scaled 1-2
Prod: AWS t3.large, auto-scaled 2-10. Manual approval → auto-deploy.

**Database Migrations**
Immutable, add-only pattern:
1. Deploy code supporting old + new schema
2. Run migration (add columns, create tables)
3. Monitor logs
4. Deploy code using new schema only
5. (Next release) Remove old references

✗ Never delete columns without 1-week buffer
✗ Never migrate without backup
✓ Test on production-like data size

**Secrets**
Provider: AWS Secrets Manager
✓ Store: DB credentials, API keys, encryption keys
✓ Access: Via IAM roles (never hardcoded, never in code)
✗ Never commit secrets to git
✓ Rotate quarterly

**Monitoring**
Alert on: Error rate >5% (10min window), Response time >2s (p95), CPU >80% (5min), DB connections >8/10.
✗ Never alert on non-actionable metrics (alert fatigue)

---

## Testing: Strategy & Patterns

**Test Pyramid**
Unit: 70% (logic, helpers, utilities)
Integration: 20% (API endpoints, real database)
E2E: 10% (critical user flows)

**Unit Tests**
Test: Business logic in isolation
✗ Never test implementation details (test behavior, not how)

**Integration Tests**
Pattern: Real API + real database
1. Setup: Create test database, seed data
2. Call: API endpoint with test request
3. Verify: Response + database state
4. Cleanup: Delete test data

✗ Never test internal module calls or queries directly

**Coverage**
Target: 70% overall, 90% critical paths
✗ Never measure generated code
✗ Never aim for 100% (diminishing returns)
✓ Use as metric, not requirement

**Mocking**
✓ Mock: External APIs, email, payment providers
✗ Mock: Database, cache (use in-memory or testcontainers)

---

## Monorepo: Shared Packages

**Structure**
```
apps/web, apps/api
packages/ui, packages/utils, packages/types
```
✗ Never circular dependencies (apps/ → packages/ only)

**Components (@org/ui)**
✓ Public API: Button, Input, Modal, Card, Form helpers, Layout primitives
✗ Never import internal components
✗ Never deep imports from packages

**Types (@org/types)**
Centralized: API req/res, DB models, domain types
✗ Never duplicate definitions
✗ Never create package-specific types (use shared)

**Dependencies**
Root package.json: Single source of versions
Workspace packages: Inherit, no overrides
When upgrading: Update root → npm install → test all → single commit
✗ Never pin different versions of same dependency

**Publishing**
Packages: @org/ui, @org/types, @org/utils
Versioning: Semantic (major.minor.patch)
Pre-publish: ✓ Tests pass, ✓ CHANGELOG updated, ✓ Version bumped, ✓ Manual tested

**Import Boundaries**
```
apps/web       → @org/ui, @org/types, @org/utils
apps/api       → @org/types, @org/utils (NOT @org/ui)
packages/ui    → @org/types, @org/utils (NOT app code)
packages/utils → @org/types (NOT ui)
packages/types → no deps
```
✗ Never violate boundaries

---

## Library: Open-Source Package

**API Stability**
Major versions (1.0, 2.0): Breaking allowed
Minor/Patch: Never break

Breaking changes:
- Remove/rename exported function
- Change signature (params, return type)
- Change default behavior

Non-breaking (minor okay):
- Add new function
- Add new optional param (sensible default)
- Extend return type with new optional field

✗ Never deprecate without migration path
✓ Provide codemods for large migrations

**Exports**
✓ Single entry point: `import { Foo } from 'my-lib'`
✗ Never deep imports: `import from 'my-lib/internal/foo'`
✗ Never conditional exports by environment

**Documentation**
Every export: JSDoc with description, @param, @returns, @example

**Dependencies**
Minimize. Each adds:
- Bundle size
- Security audit burden
- Maintenance overhead

✗ Never add dependency without evaluating cost
✓ Prefer fewer dependencies

---

## Quick Reference

**What to document (high-value deltas):**
- Decisions: Why X over Y
- Constraints: NEVER rules preventing bugs
- Patterns: Custom implementations
- Product logic: Unique business rules

**What to skip (Claude already knows):**
- Framework patterns (React hooks, Django models)
- Library capabilities (API docs)
- File structure (ls/grep shows this)
- Tech stack (package.json)
- Language syntax (standard libraries)
