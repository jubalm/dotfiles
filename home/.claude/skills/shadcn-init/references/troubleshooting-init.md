# shadcn/ui Initialization Troubleshooting

Detailed solutions for common issues during shadcn/ui setup and initialization.

---

## "No import alias found" Error

**Error Message:**
```
✗ Unable to locate a package.json file starting at .

✗ No import alias configured
```

**Root Cause:** shadcn init validates the root `tsconfig.json` and finds no path aliases.

**Solution:**

1. **Check root `tsconfig.json` exists** in your project root:
   ```bash
   ls -la tsconfig.json
   ```

2. **Add path aliases** to root `tsconfig.json`:
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

3. **For Vite projects**, also verify `vite.config.ts` has:
   ```typescript
   resolve: {
     alias: {
       '@': '/src',
     },
   }
   ```

4. **If you have `tsconfig.app.json`** (app-specific config), also add paths there:
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

5. **Delete components.json if it exists:**
   ```bash
   rm components.json
   ```

6. **Run init again:**
   ```bash
   npx shadcn@latest init -d
   ```

**Why it matters:** shadcn init validates the root config, and the app uses aliases from there and any child configs (tsconfig.app.json).

---

## "Unable to find Tailwind CSS" Error

**Error Message:**
```
✗ Unable to find Tailwind CSS

Make sure Tailwind CSS is installed and configured correctly.
```

**Root Cause:** Either Tailwind isn't installed, or the global CSS file is missing the required import.

**Solution:**

### For All Frameworks:

1. **Verify Tailwind is installed:**
   ```bash
   npm list tailwindcss
   ```

   If not installed, install it:
   ```bash
   npm install -D tailwindcss @tailwindcss/vite
   ```

2. **Check your global CSS file** for `@import "tailwindcss"`:
   ```bash
   # Find CSS files
   grep -r "@import.*tailwindcss" src/
   ```

   Expected output shows a line like:
   ```css
   @import "tailwindcss";
   ```

   If not found, check what's in your CSS files:
   ```bash
   cat src/index.css
   # or
   cat src/globals.css
   ```

3. **If import is missing**, add it to your global CSS file:
   ```css
   @import "tailwindcss";
   ```

   **ONLY this line** - nothing else.

4. **Verify CSS is imported in your app entry**:
   - For Vite: Check `src/main.tsx` has `import './index.css'`
   - For Next.js: Check `app/layout.tsx` or `pages/_app.tsx` imports the CSS
   - For Astro: Check `astro.config.mjs` has tailwind integration

5. **Restart dev server:**
   ```bash
   npm run dev
   ```

6. **Run init again:**
   ```bash
   npx shadcn@latest init -d
   ```

**Common CSS file locations:**
- Vite: `src/index.css`, `src/globals.css`
- Next.js: `app/globals.css`, `styles/globals.css`
- Astro: `src/globals.css`

---

## "Unable to detect framework" Error

**Error Message:**
```
✗ Unable to detect your framework
```

**Root Cause:** shadcn's framework detection failed (rare - usually means framework not installed).

**Solution:**

1. **Verify your framework is installed:**
   ```bash
   npm list react react-dom
   npm list next
   npm list astro
   ```

   Output should show a version number, not "npm warn".

2. **If framework is missing**, install it:
   ```bash
   # For Vite + React
   npm install react react-dom

   # For Next.js
   npm install next

   # For Astro
   npm install astro
   ```

3. **Delete `components.json` if it exists:**
   ```bash
   rm components.json
   ```

4. **Run init interactively** to see more info:
   ```bash
   npx shadcn@latest init
   ```

   When prompted "Which framework are you using?", manually select your framework.

5. **If manual selection works**, update `components.json` if needed

---

## "Unable to find a package.json file" Error

**Error Message:**
```
✗ Unable to locate a package.json file starting at .
```

**Root Cause:** Running init from wrong directory, or `package.json` doesn't exist.

**Solution:**

1. **Verify you're in project root:**
   ```bash
   pwd
   ls package.json
   ```

   Should show the path to your package.json.

2. **If not in project root**, navigate there:
   ```bash
   cd /path/to/your/project
   npx shadcn@latest init -d
   ```

3. **If `package.json` doesn't exist**, create a project first:
   ```bash
   # Vite
   npm create vite@latest my-app -- --template react-ts
   cd my-app

   # Next.js
   npx create-next-app@latest my-app
   cd my-app

   # Astro
   npx create-astro@latest my-app
   cd my-app
   ```

---

## Components Not Found After Init

**Symptom:** Init succeeds, but `components.json` exists but components can't be imported

**Root Cause:** Components haven't been added yet, or path aliases don't work.

**Solution:**

1. **Verify components.json exists:**
   ```bash
   ls components.json
   cat components.json
   ```

2. **Check the `components` directory path in components.json:**
   ```bash
   cat components.json | grep -A 5 "components"
   ```

   Should show something like:
   ```json
   "componentsDir": "./src/components/ui"
   ```

3. **Verify path aliases work** - test an import:
   ```typescript
   // In a TypeScript file, test this import
   import { cn } from '@/lib/utils'
   ```

   If this import fails, path aliases aren't configured correctly. Review the "No import alias found" section above.

4. **Restart TypeScript server** in your IDE if using one
   - VS Code: Cmd+Shift+P > "TypeScript: Restart TS Server"

5. **Add a component** to verify setup works:
   ```bash
   npx shadcn@latest add button
   ```

   Should create `src/components/ui/button.tsx`

---

## CSS Not Loading / Styles Missing

**Symptom:** Components render but have no styles applied

**Root Cause:** Tailwind not processing CSS correctly

**Solution:**

1. **Verify Tailwind is installed:**
   ```bash
   npm list tailwindcss @tailwindcss/vite
   ```

2. **For Vite**, verify vite.config.ts has tailwindcss plugin:
   ```typescript
   import tailwindcss from '@tailwindcss/vite'

   export default defineConfig({
     plugins: [react(), tailwindcss()],  // ← tailwindcss() must be here
   })
   ```

3. **Verify CSS file has Tailwind import:**
   ```bash
   head src/index.css
   ```

   Should show:
   ```css
   @import "tailwindcss";
   ```

4. **Verify CSS is imported in app entry:**
   - Vite: `src/main.tsx` should have `import './index.css'`
   - Next.js: layout should import CSS
   - Astro: Check astro.config.mjs has tailwind integration

5. **Clear caches and restart:**
   ```bash
   rm -rf node_modules/.vite  # Vite cache
   rm -rf .next               # Next.js cache
   npm run dev
   ```

6. **Check browser DevTools** - inspect an element:
   - Should see Tailwind classes in inline styles or <style> tag
   - If seeing no styles, CSS isn't loading

---

## "Validation failed" During Init

**Error Message:**
```
✗ Validation failed

Error details about what failed
```

**Solution:**

Read the specific error message carefully - it usually indicates:

1. **Missing Tailwind** - Install it
2. **Missing path aliases** - Add to tsconfig.json
3. **Missing CSS import** - Add to global CSS file
4. **Missing framework** - Install it

Look for the specific error in the message and follow solutions above.

---

## Next.js Specific Issues

### "Unable to find the next app directory" (App Router)

**Cause:** `app/` directory doesn't exist

**Solution:**
Verify you have `app/` directory:
```bash
ls app/
# Should show layout.tsx or page.tsx
```

If using Pages Router, it's normal - init detects this automatically.

### Components not loading in Pages Router

**Cause:** Not all paths configured

**Solution:**
Update `tailwind.config.js`:
```javascript
export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
}
```

---

## Vite Specific Issues

### "Import aliases not working" in vite.config.ts

**Cause:** vite.config.ts alias doesn't match tsconfig.json

**Solution:**
Ensure both match:

**vite.config.ts:**
```typescript
resolve: {
  alias: {
    '@': '/src',
  },
}
```

**tsconfig.json:**
```json
{
  "paths": {
    "@/*": ["./src/*"]
  }
}
```

Notice: vite uses `/src`, tsconfig uses `./src/*` - both are correct.

### TypeScript errors but build works

**Cause:** TypeScript language server out of sync

**Solution:**
```bash
# Restart TypeScript server in IDE
# VS Code: Cmd+Shift+P > "TypeScript: Restart TS Server"

# Or restart IDE entirely
```

---

## Astro Specific Issues

### "React is not installed" error during init

**Cause:** Astro React integration missing

**Solution:**
```bash
npx astro add react
npx shadcn@latest init
```

### Components not rendering

**Cause:** Missing `client:` directive

**Solution:**
shadcn components need `client:` directive in `.astro` files:

```astro
---
import { Button } from '@/components/ui/button'
---

<Button client:load>Click me</Button>
```

---

## Still Having Issues?

If none of these solutions work:

1. **Check error message carefully** - it usually says what's wrong
2. **Verify all prerequisites** - review pre-init checklist
3. **Delete components.json** - sometimes it gets corrupted
4. **Try from scratch**:
   ```bash
   rm components.json
   npx shadcn@latest init
   ```
5. **Check official docs** - https://ui.shadcn.com/docs

Remember: init validates your setup. Errors point to what's missing or misconfigured.
