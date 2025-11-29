# Complete Theming Guide for shadcn/ui

Deep dive into theming and color customization.

---

## HSL Color Format

shadcn uses HSL (Hue, Saturation, Lightness) for all colors:

```
hue saturation% lightness%
0-360  0-100%   0-100%
```

### Hue (0-360°)
- **0°:** Red
- **60°:** Yellow
- **120°:** Green
- **180°:** Cyan
- **240°:** Blue
- **300°:** Magenta
- **360°:** Red again

### Saturation (0-100%)
- **0%:** Grayscale (no color)
- **100%:** Full color intensity

### Lightness (0-100%)
- **0%:** Black
- **50%:** Normal color
- **100%:** White

### Examples
```
221.2 84% 4.9%    → Dark blue (high saturation, low lightness)
0 0% 100%         → Pure white
0 0% 0%           → Pure black
60 100% 50%       → Bright yellow
```

---

## Complete Color Token Reference

### Layout Colors

```css
:root {
  /* Light background - main page background */
  --background: 0 0% 100%;

  /* Dark text on light background */
  --foreground: 222.2 84% 4.9%;
}

.dark {
  /* Dark background for dark mode */
  --background: 222.2 84% 4.9%;

  /* Light text on dark background */
  --foreground: 210 40% 98%;
}
```

### Component Colors

```css
:root {
  /* Card/container background */
  --card: 0 0% 100%;

  /* Text on card */
  --card-foreground: 222.2 84% 4.9%;

  /* Popover/dropdown background */
  --popover: 0 0% 100%;

  /* Text in popover */
  --popover-foreground: 222.2 84% 4.9%;
}

.dark {
  --card: 222.2 84% 4.9%;
  --card-foreground: 210 40% 98%;
  --popover: 222.2 84% 4.9%;
  --popover-foreground: 210 40% 98%;
}
```

### State Colors

```css
:root {
  /* Disabled/placeholder text */
  --muted: 221.2 63.6% 97.8%;

  /* Muted text color */
  --muted-foreground: 215.4 16.3% 46.9%;

  /* Primary interaction color */
  --accent: 221.2 83.2% 53.3%;

  /* Text on accent backgrounds */
  --accent-foreground: 210 40% 98%;

  /* Delete/danger actions */
  --destructive: 0 84.2% 60.2%;

  /* Text on destructive backgrounds */
  --destructive-foreground: 210 40% 98%;
}

.dark {
  --muted: 217.2 32.6% 17.5%;
  --muted-foreground: 215 20.3% 65.1%;
  --accent: 221.2 83.2% 53.3%;
  --accent-foreground: 222.2 47.4% 11.2%;
  --destructive: 0 62.8% 30.6%;
  --destructive-foreground: 210 40% 98%;
}
```

### UI Element Colors

```css
:root {
  /* Borders */
  --border: 214.3 31.8% 91.4%;

  /* Input field backgrounds */
  --input: 214.3 31.8% 91.4%;

  /* Focus ring outline */
  --ring: 221.2 83.2% 53.3%;

  /* Default border radius */
  --radius: 0.5rem;
}

.dark {
  --border: 217.2 32.6% 17.5%;
  --input: 217.2 32.6% 17.5%;
  --ring: 221.2 83.2% 53.3%;
}
```

---

## Generating Custom Color Schemes

### Method 1: Official Theme Generator

Visit: https://ui.shadcn.com/themes

1. Click customize
2. Adjust colors visually
3. Copy CSS
4. Paste into your CSS file

### Method 2: Manual Customization

#### Step 1: Pick Your Base Color

Choose primary accent hue (0-360):
- Blue: 221
- Green: 142
- Purple: 281
- Red: 0
- Orange: 33

#### Step 2: Create Light Mode Colors

For light mode, use high saturation and medium lightness:

```css
:root {
  /* Your base color (e.g., blue) */
  --accent: 221 100% 50%;

  /* Light backgrounds */
  --background: 0 0% 100%;
  --card: 0 0% 98%;
  --input: 0 0% 96%;

  /* Dark text on light */
  --foreground: 0 0% 15%;
  --muted-foreground: 0 0% 45%;
}
```

#### Step 3: Create Dark Mode Colors

For dark mode, use medium saturation and lower lightness:

```css
.dark {
  /* Same accent hue, adjusted for dark */
  --accent: 221 100% 60%;

  /* Dark backgrounds */
  --background: 217 33% 17%;
  --card: 217 33% 22%;
  --input: 217 33% 20%;

  /* Light text on dark */
  --foreground: 210 40% 95%;
  --muted-foreground: 215 20% 65%;
}
```

---

## Popular Color Schemes

### Blue (Default)

```css
:root {
  --accent: 221.2 83.2% 53.3%;
}

.dark {
  --accent: 221.2 83.2% 53.3%;
}
```

### Green

```css
:root {
  --accent: 142.1 76.2% 36.3%;
}

.dark {
  --accent: 142.1 76.2% 46.3%;
}
```

### Purple

```css
:root {
  --accent: 281.4 85.3% 61.4%;
}

.dark {
  --accent: 281.4 85.3% 71.4%;
}
```

### Red/Pink

```css
:root {
  --accent: 0 84.2% 60.2%;
}

.dark {
  --accent: 0 84.2% 70.2%;
}
```

### Warm/Orange

```css
:root {
  --accent: 33 100% 50%;
}

.dark {
  --accent: 33 100% 60%;
}
```

---

## Advanced Theming Patterns

### Gradient Backgrounds

```css
@layer base {
  body {
    /* Subtle gradient background */
    background: linear-gradient(135deg, var(--background) 0%, hsl(221, 10%, 98%) 100%);
  }
}
```

### Semantic Color Tokens

Add project-specific tokens:

```css
:root {
  /* Info state */
  --info: 199 89% 48%;
  --info-foreground: 210 40% 98%;

  /* Success state */
  --success: 142 76% 36%;
  --success-foreground: 210 40% 98%;

  /* Warning state */
  --warning: 38 92% 50%;
  --warning-foreground: 210 40% 98%;

  /* Error state */
  --error: 0 84% 60%;
  --error-foreground: 210 40% 98%;
}
```

Then use in Tailwind:
```tsx
<div className="bg-[hsl(var(--info))] text-[hsl(var(--info-foreground))]">
  Info message
</div>
```

### Custom Color Gradients

```css
:root {
  /* Multi-color gradient */
  --gradient-start: 221 100% 50%;
  --gradient-end: 281 100% 50%;
}
```

Use in components:
```tsx
<div
  style={{
    background: `linear-gradient(135deg, hsl(var(--gradient-start)), hsl(var(--gradient-end)))`
  }}
>
  Gradient background
</div>
```

---

## Accessibility Considerations

### Contrast Ratios

Ensure sufficient contrast (WCAG AA):
- **Normal text:** 4.5:1 minimum
- **Large text:** 3:1 minimum

```css
/* Good contrast - dark text on light background */
:root {
  --foreground: 0 0% 0%;      /* Black - very high contrast */
  --background: 0 0% 100%;    /* White */
}

/* Light text on dark */
.dark {
  --foreground: 0 0% 100%;    /* White - very high contrast */
  --background: 0 0% 0%;      /* Black */
}
```

### Color-Blind Friendly

Avoid relying only on color. Use icons and patterns too:

```tsx
<div className="flex items-center gap-2">
  <span className="text-green-600">✓</span>
  <span>Success</span>
</div>
```

---

## Testing Your Theme

### Light/Dark Toggle

Test both modes work correctly:

```tsx
export function ThemeTest() {
  return (
    <div className="grid grid-cols-2 gap-4">
      <div className="bg-background text-foreground p-4">Light: Default</div>
      <div className="dark bg-background text-foreground p-4">Dark: Override</div>

      <div className="bg-card p-4">Light: Card</div>
      <div className="dark bg-card p-4">Dark: Card</div>

      <div className="bg-accent text-accent-foreground p-4">Light: Accent</div>
      <div className="dark bg-accent text-accent-foreground p-4">Dark: Accent</div>
    </div>
  )
}
```

### Browser DevTools

1. Open DevTools → Inspect element
2. Check computed styles for CSS variables
3. Toggle dark class and verify colors change
4. Test dark mode: Settings → Rendering → Emulate CSS media feature prefers-color-scheme

---

## Performance Tips

### CSS Variables Overhead

CSS variables have minimal performance impact but avoid:
- Excessive nested variable references
- Animations on color variables (expensive)

### Optimized

```css
/* Good - single variable */
:root {
  --accent: 221 83% 53%;
}

background-color: hsl(var(--accent));

/* Avoid - nested references */
:root {
  --hue: 221;
  --saturation: 83%;
  --lightness: 53%;
}

background-color: hsl(var(--hue), var(--saturation), var(--lightness));
```

---

## Tools & Resources

- **Official Theme Generator:** https://ui.shadcn.com/themes
- **HSL Color Picker:** https://www.colorhexa.com/
- **Contrast Checker:** https://webaim.org/resources/contrastchecker/
- **Tailwind CSS:** https://tailwindcss.com
- **Radix Colors:** https://www.radix-ui.com/colors
