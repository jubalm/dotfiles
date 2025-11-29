# Astro + shadcn/ui Setup Guide

This guide covers Astro-specific setup for shadcn/ui initialization.

## Why Astro Needs Extra Steps

Astro is a static/hybrid site builder. shadcn/ui components require React, so you need to:
1. Install React integration for Astro
2. Install Tailwind CSS for Astro
3. Configure path aliases
4. Initialize shadcn/ui

---

## Setup Steps

### Step 1: Create Astro Project with React

```bash
npx create-astro@latest my-app
# Choose "Use React for UI components" when prompted

cd my-app
```

Or add React to existing Astro project:

```bash
npx astro add react
```

This installs `@astrojs/react` and configures integration.

### Step 2: Install Tailwind CSS

```bash
npx astro add tailwind
```

This:
- Installs Tailwind CSS
- Creates `tailwind.config.mjs`
- Updates `astro.config.mjs`
- Creates `src/globals.css`

### Step 3: Verify CSS File

After Tailwind installation, verify `src/globals.css` contains:

```css
@import "tailwindcss";
```

If it contains other Tailwind directives, replace them with just:
```css
@import "tailwindcss";
```

**Important:** Astro's Tailwind addon creates this, but verify it's set up correctly.

### Step 4: Configure Path Aliases

Update `tsconfig.json`:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

Also update `astro.config.mjs` to add alias resolver:

```javascript
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  integrations: [react(), tailwind()],
  vite: {
    compat: {
      'astro.resolve.alias': true,
    },
    resolve: {
      alias: {
        '@': '/src',
      },
    },
  },
});
```

### Step 5: Initialize shadcn/ui

```bash
npx shadcn@latest init
```

When prompted:
- **Which style would you like to use?** - Choose `new-york` (or your preference)
- **Which color would you like as the base color?** - Choose `neutral` (or your preference)
- **Do you want to use CSS variables for colors?** - Choose `yes`

shadcn init will detect Astro and set up components in `src/components/ui/`.

### Step 6: Use Components in Astro

Components are React components, so they need the `client:` directive to be interactive:

```astro
---
import { Button } from '@/components/ui/button'
---

<Button client:load>Click me</Button>
```

**Client Directives:**
- `client:load` - Load immediately (use for critical interactive components)
- `client:visible` - Load when visible in viewport (best for performance)
- `client:idle` - Load after page load (good for non-critical components)

See [Astro documentation](https://docs.astro.build/en/reference/directives-reference/#client-directives) for details.

---

## Troubleshooting

### "React is not installed" error

**Cause:** React integration missing

**Solution:**
```bash
npx astro add react
```

Then retry shadcn init.

### "Unable to find Tailwind CSS" error

**Cause:** Tailwind not installed or improperly configured

**Solution:**
1. Install Tailwind: `npx astro add tailwind`
2. Verify `src/globals.css` exists
3. Verify `astro.config.mjs` includes tailwind integration
4. Retry shadcn init

### Path alias not working (`@/` imports fail)

**Cause:** Alias not configured in Astro config

**Solution:**
1. Update `tsconfig.json` with paths (see Step 4)
2. Update `astro.config.mjs` with alias resolver (see Step 4)
3. Restart dev server: `npm run dev`

### Components not interactive

**Cause:** Missing `client:` directive

**Solution:**
Add directive to component in `.astro` file:

```astro
<Button client:load>Click me</Button>
```

Each interactive component needs a directive.

---

## What Gets Created

After successful init:

- `src/components/ui/` - Directory for shadcn components
- `src/lib/utils.ts` - Class merging utility
- `components.json` - Configuration file
- **Updated `src/globals.css`** - Adds theme variables
- **Updated `package.json`** - Adds dependencies

## Astro Specifics

### Using shadcn Components in Astro

shadcn components are React components. Use them in:
- `.astro` files with `client:` directives
- `.tsx` or `.jsx` files (which are React components)

```astro
---
// In .astro file
import Button from '@/components/ui/button'
import Card from '@/components/ui/card'
---

<div>
  <Card client:load>
    <Button client:load>Hello</Button>
  </Card>
</div>
```

Or create a wrapper `.tsx` component:

```tsx
// src/components/MyComponent.tsx
import { Button } from '@/components/ui/button'

export default function MyComponent() {
  return <Button>Click me</Button>
}
```

```astro
---
import MyComponent from '@/components/MyComponent'
---

<MyComponent client:load />
```

### Performance Optimization

Use `client:visible` instead of `client:load` for better performance:

```astro
<Button client:visible>Click me</Button>
```

This loads the component only when it enters the viewport.

---

## Quick Reference

```bash
# Add React to Astro
npx astro add react

# Add Tailwind to Astro
npx astro add tailwind

# Initialize shadcn/ui
npx shadcn@latest init

# Start dev server
npm run dev

# Build for production
npm run build
```
