# Real-World Examples by Domain

What to document (and skip) by project type.

---

## Frontend: React Application

### What to Document

```markdown
# Frontend Architecture

## Client-Server Boundary

**When:** Deciding what logic lives where

**Rule:**
✓ Server components: data fetching, auth checks, secrets
✓ Client components: interactivity, forms, real-time updates
✗ Never fetch secrets in client components
✗ Never do expensive computation on every render

**Constraint:** Add 'use client' only when component needs interactivity

## State Management

**Pattern:** Redux for global state

Single source of truth. Selectors compute derived state (no component-level recompute).
Async: redux-thunk (not sagas, simpler).

```markdown
// Good: Selector prevents recompute
const items = useSelector(state => state.items);

// Bad: Computed inline
const filtered = state.items.filter(...); // recomputes every render
```

**Important:**
- ✗ Never mutate state directly (use immer)
- ✓ Use selectors for all derived state
- Watch for prop drilling (refactor with context)

## Styling

**Standard:** Tailwind CSS + CSS modules for component-specific

Don't document: How to use Tailwind
Do document:

```
Tailwind: Used for utility classes, responsive
CSS modules: For component-specific scoped styles
Never: Inline styles in JS

Theme: Defined in tailwind.config.js
- Colors: Brand primary/secondary + semantics (error, success)
- Spacing: 4px base unit
- Responsive: mobile-first (sm:, md:, lg: prefixes)
```

## Asset Handling

Cache policy: Images cached 1 year (far-future expires), with hash in filename

```
Static assets: /public (never cache, revalidate every request)
Generated images: /public/generated (hash-named, cache 1 year)
User uploads: CDN with 7-day TTL
```

### What NOT to Document

- ❌ "React uses components" (framework fundamental)
- ❌ "How to use useEffect hook" (standard library)
- ❌ "CSS flexbox properties" (language feature)
- ❌ "Tailwind color naming" (framework docs)

---

## Backend: Node.js API

### What to Document

```markdown
# Backend Architecture

## API Design

**Endpoints:**
- GET /items (list, paginated)
- GET /items/:id (single item)
- POST /items (create)
- PATCH /items/:id (update)
- DELETE /items/:id (delete)

Pagination: Default 50, max 500 items per page
Errors: HTTP status + JSON `{error: string, details: object, code: string}`

**Constraint:**
✗ Never return 200 with error in body (misleading)
✗ Never paginate large datasets without sorting
✓ Always validate input before processing

## Database Queries

**Pattern:** Postgres with RLS for multi-tenancy

```sql
-- Good: Respects RLS
SELECT * FROM items WHERE tenant_id = current_tenant_id();

-- Bad: Bypasses RLS
SELECT * FROM items; -- dangerous!
```

Indexes:
- ✓ All foreign keys indexed
- ✓ Common filter columns indexed
- ✗ Never add indexes without measuring query performance

**Connections:** Pooled, 10 per instance max

## Authentication

Token: 1-hour access JWT + 7-day refresh (httpOnly cookie)

```
On login:
  Generate access + refresh tokens
  Send access in response body (for fetch calls)
  Send refresh in secure httpOnly cookie

On logout:
  Access token: Blacklist immediately
  Refresh token: Blacklist, revoke all sessions

Admin override: Requires email + SMS confirmation
```

**Constraints:**
✗ Never store refresh token in localStorage
✗ Never trust access token beyond 1 hour
✓ Use secure httpOnly cookies for sensitive tokens

### What NOT to Document

- ❌ "We use Express.js" (visible in package.json)
- ❌ "HTTP status codes 200, 201, etc." (standard)
- ❌ "How to write SQL queries" (database knowledge)
- ❌ "JWT structure and claims" (library docs)

---

## DevOps: CI/CD Pipeline

### What to Document

```markdown
# Deployment & Infrastructure

## Environments

**Development:** Local + Docker
**Staging:** AWS t3.medium, auto-scaled 1-2
**Production:** AWS t3.large, auto-scaled 2-10

Deployment triggers:
- dev: Push to feature branches → auto-deployed to staging
- prod: Merge to main → manual approval → auto-deployed

## Database Migrations

**Rule:** Immutable, add-only (never delete columns immediately)

```
1. Deploy code supporting both old + new schema
2. Run migration (add columns, create new tables)
3. Monitor logs for errors
4. Deploy code using new schema only
5. In next release: Remove old column references
```

**Constraint:**
✗ Never delete columns in production without 1-week buffer
✗ Never migrate data without backup
✓ Test migrations on production-like data size

## Secrets Management

**Provider:** AWS Secrets Manager

Stored:
- Database credentials
- API keys
- Encryption keys

Accessed: Via IAM roles (never hardcoded, never in code)

**Constraint:**
✗ Never commit secrets to git
✓ Rotate credentials quarterly
✓ Audit all secret access

## Monitoring

**Alerts trigger if:**
- Error rate > 5% (10 minute window)
- Response time > 2s (p95)
- CPU > 80% for 5 minutes
- Database connections > 8 of 10 pooled

**Important:** Alert fatigue is real. Only alert on actionable issues.

### What NOT to Document

- ❌ "We use Docker for containerization" (visible in Dockerfile)
- ❌ "How to write GitHub Actions" (docs available)
- ❌ "AWS EC2 instance types" (AWS docs)
- ❌ "Kubernetes YAML syntax" (k8s docs)

---

## Testing: Strategy & Patterns

### What to Document

```markdown
# Testing Strategy

## Test Pyramid

Unit: 70% (logic, helpers, utilities)
Integration: 20% (API endpoints, database)
E2E: 10% (critical user flows only)

## Unit Tests

**When:** Testing business logic in isolation

```javascript
// Document this - project-specific pattern
describe('calculatePrice', () => {
  it('applies discount for bulk orders', () => {
    const price = calculatePrice(100, { quantity: 50 });
    expect(price).toBe(90); // 10% discount
  });
});
```

Never test: Implementation details (how, only what)

## Integration Tests

**Pattern:** Test API endpoints with real database

```
1. Setup: Create test database, seed data
2. Call: API endpoint with test request
3. Verify: Response body + database state
4. Cleanup: Delete test data
```

Never: Test internal module calls or database queries directly

## Coverage Goals

- Overall: 70% code coverage
- Critical paths: 90% coverage
- Avoided: 100% coverage (diminishing returns)

**Important:**
✗ Never measure coverage on generated code
✗ Never aim for 100% (costs > benefits)
✓ Coverage is useful metric, not requirement

## Mocking Strategy

**Mock externals:** APIs, email, payment providers
**Don't mock:** Database, cache (use in-memory or testcontainers)

Example:
```javascript
// Good: Mock external API
jest.mock('stripe', () => ({
  charges: { create: jest.fn() }
}));

// Bad: Mock database
jest.mock('db'); // defeats purpose of integration test
```

### What NOT to Document

- ❌ "We use Jest for testing" (visible in package.json)
- ❌ "How to write test assertions" (Jest docs)
- ❌ "What mocking libraries exist" (testing knowledge)
- ❌ "Test file naming conventions" (standard)

---

## Monorepo: Shared Packages

### What to Document

```markdown
# Monorepo Structure

## Workspace Organization

```
apps/
  web/          # Next.js frontend
  api/          # Node.js backend
packages/
  ui/           # Shared React components
  utils/        # Shared utilities
  types/        # Shared TypeScript types
```

No circular dependencies: apps/ → packages/, never reverse

## Shared Components (@org/ui)

Available:
- Button, Input, Modal, Card
- Form helpers (useForm, validation)
- Layout primitives (Flex, Grid)

Export from single entry point: `@org/ui`

**Constraint:**
✗ Never import internal components from packages
✓ Use public API only (@org/ui exports)

## Shared Types (@org/types)

Centralized TypeScript definitions for:
- API request/response types
- Database models
- Business domain types

Usage:
```typescript
import type { User, Post } from '@org/types';
```

**Constraint:**
✗ Never duplicate type definitions
✗ Never create package-specific types (use shared)

## Dependency Management

**Root package.json:** Defines versions
**Workspace packages:** Inherit versions (no overrides)

When upgrading dependency:
1. Update in root package.json
2. `npm install` (propagates to all)
3. Test all affected packages
4. Single commit with all changes

**Constraint:**
✗ Never pin different versions of same dependency
✓ Keep all packages on same version

## Publishing

Packages published to npm: @org/ui, @org/types, @org/utils

Versioning: Semantic (major.minor.patch)

Before publishing:
- [ ] All tests passing
- [ ] CHANGELOG updated
- [ ] Version bumped in package.json
- [ ] Manual test in consuming app

## Import Boundaries

```
apps/web/         → can import from @org/ui, @org/types, @org/utils
apps/api/         → can import from @org/types, @org/utils (NOT @org/ui)
packages/ui/      → can import from @org/types, @org/utils (NOT app code)
packages/utils/   → can import from @org/types only
packages/types/   → has no internal dependencies
```

**Constraint:**
✗ Never import web-specific code into api
✗ Never import app code into packages
✓ Follow import boundaries strictly

### What NOT to Document

- ❌ "We use npm workspaces" (visible in package.json)
- ❌ "How to use TypeScript" (language feature)
- ❌ "How to publish to npm" (npm docs)
- ❌ "Monorepo benefits" (general knowledge)

---

## Library: Open-Source Package

### What to Document

```markdown
# Design Principles

## API Stability

Major versions (1.0, 2.0) are breaking. Never change in minor/patch.

### Breaking Changes

Examples of breaking changes (require major version):
- Remove or rename exported function
- Change function signature (parameters, return type)
- Change default behavior

Non-breaking (minor version okay):
- Add new function
- Add new optional parameter with sensible default
- Extend return type with new optional field

**Constraint:**
✗ Never break API in minor/patch versions
✗ Never deprecate without documenting migration path
✓ Provide codemods for large migrations

## Exports

Single entry point: `import { Foo } from 'my-lib'`

Never:
- ✗ Deep imports: `import from 'my-lib/internal/foo'`
- ✗ Conditional exports that vary by environment

## Documentation

Every export must have JSDoc with:
- Description
- @param with types
- @returns with type
- Usage example

```typescript
/**
 * Calculate total cost including tax
 * @param amount - Price before tax
 * @param taxRate - Tax rate as decimal (0.08 for 8%)
 * @returns Total price including tax
 * @example
 * calculateTotal(100, 0.08) // 108
 */
export function calculateTotal(amount: number, taxRate: number): number {
  return amount * (1 + taxRate);
}
```

## Dependencies

Keep minimal. Each dependency adds:
- Bundle size
- Security audit burden
- Maintenance overhead

**Constraint:**
✗ Never add dependency without evaluating cost
✓ Prefer fewer dependencies over convenience features

### What NOT to Document

- ❌ "We follow semantic versioning" (standard for libraries)
- ❌ "TypeScript types improve DX" (general knowledge)
- ❌ "Bundle size matters" (obvious for libs)
- ❌ "How to publish to npm" (npm docs)

---

## Summary: Decision Matrix by Domain

| Domain | Example to Document | Example to Skip |
|--------|---------------------|-----------------|
| Frontend | State pattern choice | Tailwind syntax |
| Backend | Database query pattern | HTTP status codes |
| DevOps | DB migration strategy | Kubernetes YAML |
| Testing | Coverage goals | Jest assertions |
| Monorepo | Import boundaries | npm workspaces |
| Library | API stability rules | TypeScript features |

**Key pattern:** Document WHY and WHEN, let code/docs show HOW.
