# Vite + shadcn/ui Setup Guide

This guide covers Vite-specific setup for shadcn/ui initialization.

## Why Vite Needs Special Handling

Vite modernizes JavaScript tooling with:
- **ES modules natively** (no CommonJS by default)
- **Instant hot module replacement (HMR)**
- **Framework-specific optimizations**
- **Explicit configuration** (features aren't auto-detected like in Next.js)

This means path aliases and Tailwind configuration require explicit setup before running `shadcn init`.

---

## Setup Steps

### Step 1: Verify Vite Project

Ensure you have a Vite + React project:

```bash
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install
```

Or use an existing Vite project.

### Step 2: Install Tailwind CSS and Vite Plugin

```bash
npm install -D tailwindcss @tailwindcss/vite
```

This installs:
- `tailwindcss` - Tailwind CSS engine
- `@tailwindcss/vite` - Vite integration plugin

### Step 3: Configure Vite

Update `vite.config.ts`:

```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      '@': '/src',
    },
  },
})
```

**Key points:**
- `react()` plugin handles JSX and HMR
- `tailwindcss()` plugin processes Tailwind imports
- `resolve.alias` maps `@` to `/src` for imports
- Plugin order matters: react before tailwindcss

### Step 4: Configure TypeScript Path Aliases

Update **root** `tsconfig.json`:

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

If your project uses `tsconfig.app.json` (common in scaffolded Vite projects), also update it:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"]
}
```

**Why both configs?**
- Root `tsconfig.json` - Validated by shadcn init
- App-specific `tsconfig.app.json` - Used by TypeScript for app compilation
- When root config has project references, both are needed

### Step 5: Prepare Global CSS File

Create or update your global CSS file (typically `src/index.css` or `src/globals.css`):

```css
@import "tailwindcss";
```

**⚠️ CRITICAL:**
- Add ONLY this line
- Do NOT add CSS variables yet
- Do NOT add @layer blocks
- Do NOT add any customizations

The `shadcn init` command will automatically add theme configuration.

Ensure this CSS file is imported in `src/main.tsx`:

```typescript
import React from 'react'
import ReactDOM from 'react-dom/client'
import './index.css'  // ← Import your CSS
import App from './App.tsx'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
```

### Step 6: Initialize shadcn/ui

```bash
npx shadcn@latest init -d
```

The `-d` flag uses defaults:
- Style: `new-york`
- Base color: `neutral`
- CSS variables: `true`

Or run interactively to choose options:
```bash
npx shadcn@latest init
```

---

## Vite Module System Details

### ES Modules vs CommonJS

Vite uses ES modules, which means:

```typescript
// ✅ Vite style (works)
import path from 'path'
alias: {
  '@': '/src',
}

// ❌ CommonJS style (doesn't work in Vite)
const path = require('path')
const __dirname = path.dirname(__filename)
// __dirname doesn't exist in ES modules
```

### Path Alias Strategy

Use simple string paths in Vite:

```typescript
// ✅ Best for Vite
resolve: {
  alias: {
    '@': '/src',
  },
}

// ❌ Avoid complex approaches
const path = require('path')
const resolve = p => path.resolve(__dirname, p)
```

Simple string aliases are:
- Reliable across environments
- ES-module native
- Work with TypeScript and bundlers

---

## Hot Module Replacement (HMR)

Vite's HMR provides instant feedback during development:

1. Edit a component
2. File is saved
3. Vite detects change
4. Module hot-updates in browser
5. Component re-renders instantly (no page reload)

shadcn components work perfectly with HMR - edit and see changes immediately.

**Optimizing HMR:**
```typescript
// If dev server is on different host:
export default defineConfig({
  server: {
    hmr: {
      protocol: 'ws',
      host: 'localhost',
      port: 5173,
    },
  },
})
```

---

## Build Optimization

### Tree-Shaking

Only import what you use:

```typescript
// ✅ Only Button is bundled
import { Button } from '@/components/ui/button'

// ❌ All components included (avoid)
import * as UI from '@/components/ui'
```

### Code Splitting

Split dependencies into separate chunks:

```typescript
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          // shadcn dependencies
          shadcn: ['clsx', 'tailwind-merge', 'class-variance-authority'],
        },
      },
    },
  },
})
```

---

## Troubleshooting

### Path alias "@" not resolving

**Cause:** Alias not configured in vite.config.ts

**Solution:**
```typescript
export default defineConfig({
  resolve: {
    alias: {
      '@': '/src',  // ← Add this
    },
  },
})
```

Then restart dev server.

### TypeScript doesn't recognize "@" imports

**Cause:** Path aliases not in tsconfig.json

**Solution:**
1. Add to root `tsconfig.json`:
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
2. If you have `tsconfig.app.json`, add same paths there
3. Restart TypeScript server in IDE

### CSS not loading or styles missing

**Cause:** Tailwind not configured or CSS not imported

**Solution:**
1. Verify `@tailwindcss/vite` is installed
2. Verify `tailwindcss()` is in vite plugins
3. Verify `src/index.css` has `@import "tailwindcss"`
4. Verify CSS is imported in `src/main.tsx`
5. Restart dev server: `npm run dev`

### HMR not working

**Cause:** Module refresh failing

**Solution:**
```bash
# Clear Vite cache
rm -rf node_modules/.vite

# Restart dev server
npm run dev
```

---

## Comparison: Dev vs Production

| Aspect | Dev | Production |
|--------|-----|-----------|
| Build time | ~200-500ms | ~1-3s |
| Bundle size | Not minified | Minified + tree-shaken |
| CSS | Real-time injection | Bundled into CSS |
| Styles | All Tailwind utilities | Only used utilities |

Test production builds locally:
```bash
npm run build
npm run preview
```

---

## Quick Reference

```bash
# Install Tailwind and plugin
npm install -D tailwindcss @tailwindcss/vite

# Initialize shadcn
npx shadcn@latest init

# Start dev with HMR
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Key Takeaways

1. **ES Modules** - Use simple string paths for aliases
2. **Path Aliases** - Configure in both vite.config.ts AND tsconfig.json
3. **Tailwind Import** - Must be `@import "tailwindcss"` at top of CSS
4. **Plugin Order** - react() before tailwindcss()
5. **CSS Import** - Must be imported in src/main.tsx
6. **HMR** - Instant feedback, very useful for development

Once configured, shadcn/ui works seamlessly with Vite's excellent DX.
