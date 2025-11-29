---
name: "shadcn/ui Customization & Theming"
description: "Use this skill when customizing shadcn/ui themes, implementing dark mode, modifying component styles, or changing color schemes. Covers CSS variables, design tokens, theme generation, and component.json configuration. Assumes shadcn is already set up with components installed."
---

# shadcn/ui Customization & Theming

This skill covers customizing shadcn/ui components and implementing themes.

**Prerequisites:** Your project must have:
- Completed `shadcn init` setup
- At least one component installed
- `components.json` and `src/lib/utils.ts` created
- Tailwind CSS configured with CSS variables enabled

---

## CSS Variables & Design Tokens

shadcn uses CSS variables to define the design system. After `shadcn init`, your global CSS file contains:

```css
@import "tailwindcss";

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --muted: 221.2 63.6% 97.8%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 221.2 83.2% 53.3%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.3% 65.1%;
    --accent: 221.2 83.2% 53.3%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 221.2 83.2% 53.3%;
  }
}

@layer base {
  * {
    @apply border-border;
  }

  body {
    @apply bg-background text-foreground;
  }
}
```

### Understanding CSS Variables

Each variable uses HSL format (Hue, Saturation, Lightness):

```
--accent: 221.2 83.2% 53.3%;
          ↑     ↑     ↑
       hue  sat   light
```

- **Hue:** 0-360 (color)
- **Saturation:** 0-100% (intensity)
- **Lightness:** 0-100% (brightness)

### Color Tokens

| Token | Purpose |
|-------|---------|
| `--background` | Default background color |
| `--foreground` | Default text color |
| `--card` | Card component background |
| `--card-foreground` | Card text color |
| `--muted` | Muted/disabled state background |
| `--muted-foreground` | Muted text color |
| `--accent` | Primary accent/highlight color |
| `--accent-foreground` | Text on accent backgrounds |
| `--destructive` | Destructive action color (red) |
| `--destructive-foreground` | Text on destructive backgrounds |
| `--border` | Border colors |
| `--input` | Input field background |
| `--ring` | Focus ring color |
| `--radius` | Default border radius |

---

## Customizing Colors

To change a color, update the CSS variable value:

### Change Primary Accent Color

```css
:root {
  --accent: 270 100% 50%;  /* Changed from blue to purple */
}

.dark {
  --accent: 270 100% 60%;  /* Purple for dark mode */
}
```

### Change All Backgrounds to Slightly Darker

```css
:root {
  --background: 0 0% 98%;   /* Was 100%, slightly darker */
  --card: 0 0% 98%;
  --input: 214.3 31.8% 88%; /* Slightly darker input */
}
```

### Monochrome Theme

```css
:root {
  --background: 0 0% 100%;
  --foreground: 0 0% 0%;
  --card: 0 0% 98%;
  --card-foreground: 0 0% 0%;
  --accent: 0 0% 20%;        /* Dark gray accent */
  --border: 0 0% 90%;
}
```

---

## Dark Mode Implementation

After `shadcn init`, dark mode is configured with CSS variables. To toggle dark mode:

### Using the `dark` class

Add the `dark` class to the root element to switch themes:

```typescript
// src/App.tsx or root component
export function App() {
  const [isDark, setIsDark] = useState(false)

  return (
    <div className={isDark ? 'dark' : ''}>
      {/* Your app content */}
      <button onClick={() => setIsDark(!isDark)}>
        {isDark ? 'Light' : 'Dark'} Mode
      </button>
    </div>
  )
}
```

### Using next-themes (Recommended)

For persistent theme preference:

```bash
npm install next-themes
```

**Setup in app entry:**

```tsx
// src/main.tsx or app/layout.tsx
import { ThemeProvider } from 'next-themes'

export default function App() {
  return (
    <ThemeProvider attribute="class" defaultTheme="system">
      {/* Your app */}
    </ThemeProvider>
  )
}
```

**Create theme toggle:**

```tsx
'use client'

import { useTheme } from 'next-themes'

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()

  return (
    <button onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}>
      {theme === 'dark' ? '☀️ Light' : '🌙 Dark'}
    </button>
  )
}
```

---

## Customizing Component Styles

Since shadcn components are in your source code, modify them directly. No need for wrappers or overrides.

### Example: Customize Button

Open `src/components/ui/button.tsx`:

```typescript
const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default:
          "bg-primary text-primary-foreground hover:bg-primary/90",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
        // Add custom variant
        premium: "bg-gradient-to-r from-purple-600 to-blue-600 text-white hover:from-purple-700 hover:to-blue-700",
      },
      // Add custom size
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        xl: "h-14 rounded-lg px-6 text-lg",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)
```

Now use the custom variant:

```tsx
<Button variant="premium">Premium Button</Button>
<Button size="xl">Large Button</Button>
```

### Example: Customize Card

Open `src/components/ui/card.tsx` and add styling:

```typescript
const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      // Add custom shadow or border
      "rounded-lg border border-border/50 bg-card p-6 shadow-lg hover:shadow-xl transition-shadow",
      className
    )}
    {...props}
  />
))
```

---

## Custom Color Palette

Use the official theme generator: https://ui.shadcn.com/themes

1. Visit the theme customizer
2. Adjust colors visually
3. Copy the generated CSS variables
4. Paste into your global CSS

---

## Adding Custom Components

Add your own components alongside shadcn components:

```typescript
// src/components/ui/custom-button.tsx
import { Button } from './button'

export function CustomButton(props: React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return <Button {...props} className={`custom-class ${props.className}`} />
}
```

---

## Responsive Design

shadcn uses Tailwind responsive classes. Customize spacing and sizing:

```css
/* In your global CSS, customize default responsive values */
@layer base {
  :root {
    --radius: 0.5rem;
  }
}
```

In components:

```tsx
<div className="p-4 md:p-6 lg:p-8">
  Responsive padding
</div>
```

---

## Design System Best Practices

### Consistent Spacing

Use Tailwind spacing scale:
```tsx
<div className="space-y-4">  {/* 1rem gap between children */}
  <Card>Item 1</Card>
  <Card>Item 2</Card>
</div>
```

### Consistent Typography

Tailwind predefined sizes:
```tsx
<h1 className="text-4xl font-bold">Heading 1</h1>
<h2 className="text-2xl font-semibold">Heading 2</h2>
<p className="text-base text-muted-foreground">Body text</p>
```

### Consistent Colors

Use design tokens, not hardcoded colors:

```tsx
// ✅ Good - uses design tokens
<div className="bg-background text-foreground border border-border">Content</div>

// ❌ Avoid - hardcoded colors
<div className="bg-white text-black border border-gray-200">Content</div>
```

---

## Configuration Reference

### components.json

Customize how components are installed:

```json
{
  "style": "new-york",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/index.css",
    "baseColor": "neutral",
    "cssVariables": true
  },
  "aliases": {
    "@/components": "./src/components",
    "@/lib/utils": "./src/lib/utils"
  }
}
```

**Key settings:**
- `style` - Visual design system (new-york, default)
- `baseColor` - Primary color palette (neutral, slate, gray, zinc, stone)
- `cssVariables` - Use CSS variables for theming (true recommended)

---

## Common Customizations

### Rounded Corners

```css
:root {
  --radius: 0.25rem;  /* Sharper corners */
}
```

Or:
```css
:root {
  --radius: 1rem;  /* More rounded */
}
```

### Border Width

Add to button customization:
```typescript
const buttonVariants = cva(
  "border-2",  // Thicker borders
  // ... rest of styles
)
```

### Font Family

In Tailwind config or global CSS:
```css
@layer base {
  body {
    @apply font-sans;  /* Uses Tailwind's sans font */
  }
}
```

---

## Troubleshooting

### Styles not applying

**Check:**
1. CSS variables exist in your global CSS file
2. Global CSS is imported in your app entry
3. Tailwind CSS is configured
4. Component uses `className` prop

### Dark mode not toggling

**Check:**
1. Provider is wrapping your app (if using next-themes)
2. `dark` class is applied to root element
3. CSS variables for `.dark` theme are defined

### Custom colors not working

**Check:**
1. Variables use correct HSL format: `hue saturation% lightness%`
2. Variables are updated in both `:root` and `.dark` selectors
3. Components use `var(--your-variable)` or Tailwind classes

---

## Next Steps

Once theming is configured, you can:
- Build pages using styled components
- Implement advanced patterns (forms, tables, etc.)
- Create reusable component wrappers

For advanced patterns and complex features, see the patterns skill.
