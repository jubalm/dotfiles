---
name: "shadcn/ui Component Management"
description: "Use this skill when adding or managing shadcn/ui components in an already-initialized project. Covers CLI commands for adding components, component catalog, usage patterns, and dependencies. Assumes shadcn is already set up with components.json created."
---

# shadcn/ui Component Management

This skill covers working with shadcn/ui components after initialization.

**Prerequisites:** Your project must have:
- `components.json` file (created by `shadcn init`)
- `src/lib/utils.ts` file
- Tailwind CSS configured
- shadcn/ui dependencies installed

If you haven't initialized shadcn/ui yet, run `shadcn init` first.

---

## Adding Components

### Single Component

```bash
npx shadcn@latest add button
```

This creates `src/components/ui/button.tsx` with the Button component ready to use.

### Multiple Components

```bash
npx shadcn@latest add button card input label
```

Installs button, card, input, and label components in one command.

### All Components

```bash
npx shadcn@latest add --all
```

Installs every available shadcn component. Not recommended - better to add components as needed.

---

## Using Components

After a component is installed, import and use it:

```typescript
import { Button } from '@/components/ui/button'

export function MyComponent() {
  return (
    <Button onClick={() => alert('Clicked!')}>
      Click me
    </Button>
  )
}
```

### React Usage

Components are standard React components with TypeScript support:

```typescript
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'

export function MyForm() {
  return (
    <div>
      <Input placeholder="Enter text" />
      <Select>
        <SelectTrigger>
          <SelectValue placeholder="Select option" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="option1">Option 1</SelectItem>
          <SelectItem value="option2">Option 2</SelectItem>
        </SelectContent>
      </Select>
    </div>
  )
}
```

### Props and Variants

Components accept props for customization:

```typescript
import { Button } from '@/components/ui/button'

export function ButtonVariants() {
  return (
    <div>
      <Button>Default</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="destructive">Destructive</Button>
      <Button variant="outline">Outline</Button>
      <Button variant="ghost">Ghost</Button>
      <Button disabled>Disabled</Button>
    </div>
  )
}
```

Check each component's source file for available props and variants.

---

## Viewing Components Before Installing

Preview a component before adding it:

```bash
npx shadcn@latest view button
```

Shows the component code in your terminal. Useful to understand what you're installing before committing it to your project.

---

## Component Dependencies

Some components depend on others. When you add a component, shadcn automatically installs its dependencies.

**Common dependencies:**
- Most components depend on `clsx` and `tailwind-merge` (already installed)
- Dialog, AlertDialog depend on Radix UI primitives
- Form depends on react-hook-form
- Select, Combobox depend on cmdk, @radix-ui/react-select

Dependencies are automatically handled - just add the component you want.

---

## Listing Installed Components

View all available components:

```bash
npx shadcn@latest list
```

Shows all components and which are installed in your project.

---

## Searching Components

Find components by name:

```bash
npx shadcn@latest search table
```

Returns components matching "table" (data-table, table, etc.).

---

## Component File Structure

Components are created in `src/components/ui/`:

```
src/components/ui/
├── button.tsx
├── card.tsx
├── input.tsx
├── dialog.tsx
└── ... (other components)
```

Each component:
- Is a self-contained `.tsx` file
- Includes TypeScript types
- Is ready to use immediately
- Can be modified directly

---

## Best Practices

### Add Components Incrementally

Don't add all components at once:

```bash
# ✅ Good - add as needed
npx shadcn@latest add button
npx shadcn@latest add input
npx shadcn@latest add dialog

# ❌ Avoid - adds everything, keeps codebase lean
npx shadcn@latest add --all
```

Incremental addition keeps your codebase focused on what you actually use.

### Import Only What You Use

```typescript
// ✅ Good - tree-shaking works
import { Button } from '@/components/ui/button'

// ❌ Avoid - imports everything
import * as UI from '@/components/ui'
const Button = UI.Button
```

### Organize Component Usage

Group related imports:

```typescript
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
```

---

## Common Components Quick Reference

### Layout & Display
- `card` - Container with border and padding
- `container` - Max-width wrapper
- `separator` - Visual divider
- `scroll-area` - Scrollable container

### Forms & Input
- `button` - Interactive button
- `input` - Text input field
- `label` - Form label
- `checkbox` - Checkbox input
- `radio-group` - Radio button group
- `select` - Dropdown select
- `textarea` - Multi-line text input
- `form` - Form wrapper with validation

### Dialogs & Overlays
- `dialog` - Modal dialog
- `alert-dialog` - Confirmation dialog
- `drawer` - Side drawer/panel
- `popover` - Floating popover
- `sheet` - Slide-out panel
- `tooltip` - Hover tooltip

### Navigation
- `tabs` - Tab navigation
- `pagination` - Page navigation
- `breadcrumb` - Breadcrumb navigation
- `navigation-menu` - Vertical navigation

### Data Display
- `table` - Data table
- `data-table` - Complex data table with sorting/filtering
- `badge` - Status badge
- `progress` - Progress bar
- `skeleton` - Loading skeleton

---

## CLI Command Reference

```bash
# Add component
npx shadcn@latest add button

# Add multiple components
npx shadcn@latest add button card input label

# View component code
npx shadcn@latest view button

# List all components
npx shadcn@latest list

# Search for component
npx shadcn@latest search input

# View all available commands
npx shadcn@latest --help
```

### Package Manager Variations

Commands work with different package managers:

```bash
# npm
npx shadcn@latest add button

# pnpm
pnpm dlx shadcn@latest add button

# yarn
yarn dlx shadcn@latest add button

# bun
bun x shadcn@latest add button
```

---

## Troubleshooting

### Component import fails

**Check:**
1. Component is installed: `npx shadcn@latest list`
2. Path alias works: Try importing from `./src/components/ui/button.tsx` instead of `@/components/ui/button`
3. Path aliases in tsconfig.json and vite.config.ts (for Vite)

### Component looks wrong or isn't rendering

**Check:**
1. Tailwind CSS is configured and working
2. CSS file imported globally
3. No TypeScript errors in IDE

### Want to see component code

```bash
npx shadcn@latest view button
```

Or open `src/components/ui/button.tsx` directly.

### Component doesn't have the props I want

Components are in your source code - **modify them directly** in `src/components/ui/`. They're not a dependency, they're your code.

---

## What's Next?

Once you have components installed, you can:
- Use them in your application
- Customize component styles and variants
- Build complex features with multiple components

For customization and theming, use the `shadcn-customize` skill.
