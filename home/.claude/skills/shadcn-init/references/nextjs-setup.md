# Next.js + shadcn/ui Setup Guide

This guide covers Next.js-specific setup for shadcn/ui initialization.

## Why Next.js is Simpler

Next.js has built-in Tailwind CSS support and auto-detects framework setup, so shadcn init requires minimal pre-configuration compared to Vite or Astro.

---

## Setup Steps

### Step 1: Verify Next.js Project

Ensure you have a Next.js project with React:

```bash
npx create-next-app@latest my-app --typescript --tailwind
cd my-app
```

Or use an existing Next.js project.

### Step 2: Install Tailwind CSS (if needed)

If your project doesn't have Tailwind CSS:

```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

### Step 3: Configure Tailwind

Update `tailwind.config.js` to include template paths:

**For App Router (Next.js 13+):**
```javascript
export default {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

**For Pages Router:**
```javascript
export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

### Step 4: Add Tailwind Directives to CSS

Create or update your global CSS file (e.g., `app/globals.css` or `styles/globals.css`):

```css
@import "tailwindcss";
```

That's it - just the import line. Nothing else.

### Step 5: Import CSS in Your App

**For App Router:**
Import in `app/layout.tsx`:

```typescript
import type { Metadata } from "next";
import "./globals.css"

export const metadata: Metadata = {
  title: "My App",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
```

**For Pages Router:**
Import in `pages/_app.tsx`:

```typescript
import '../styles/globals.css'
import type { AppProps } from 'next/app'

export default function App({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}
```

### Step 6: Run shadcn Init

```bash
npx shadcn@latest init -d
```

Or interactively:
```bash
npx shadcn@latest init
```

Next.js auto-detects your setup and configuration.

---

## Troubleshooting

### Tailwind styles not appearing

**Cause:** CSS file not imported in layout

**Solution:**
- **App Router:** Verify `app/globals.css` is imported in `app/layout.tsx`
- **Pages Router:** Verify styles CSS is imported in `pages/_app.tsx`
- Restart dev server: `npm run dev`

### Components not found at `@/components/ui/...`

**Cause:** Path aliases not configured

**Next.js auto-configures `@` alias** when you run init, but verify `jsconfig.json` or `tsconfig.json` has:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./*"]
    }
  }
}
```

### Init fails with TypeScript errors

**Solution:**
1. Ensure `typescript` is installed: `npm install typescript`
2. Delete `components.json` if it exists
3. Run init again: `npx shadcn@latest init`

---

## What Gets Created

After successful init:

- `components/ui/` - Directory for shadcn components
- `lib/utils.ts` - Class merging utility (`cn()` function)
- `components.json` - Configuration file
- **Updated `app/globals.css` or `styles/globals.css`** - Adds theme variables
- **Updated `package.json`** - Adds dependencies (clsx, tailwind-merge, class-variance-authority)

## App Router vs Pages Router

**App Router (Recommended, Next.js 13+):**
- Components in `app/` directory
- Server components by default
- Better performance and DX
- shadcn auto-detects and configures

**Pages Router (Legacy):**
- Components in `pages/` directory
- Client-side rendering
- Still fully supported
- shadcn auto-detects and configures

Both work identically with shadcn.

---

## Quick Command Reference

```bash
# Check Next.js version
npm list next

# Install Tailwind (if needed)
npm install -D tailwindcss postcss autoprefixer

# Initialize shadcn (requires pre-config above)
npx shadcn@latest init

# View available options during init
npx shadcn@latest init --help
```
