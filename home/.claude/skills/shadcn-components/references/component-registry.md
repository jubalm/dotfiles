# shadcn/ui Component Registry

Quick reference for all available shadcn/ui components, their purposes, and common usage.

---

## Layout Components

### Card
Container component with border and padding.

```bash
npx shadcn@latest add card
```

Usage:
```tsx
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"

export function CardExample() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Card Title</CardTitle>
        <CardDescription>Card Description</CardDescription>
      </CardHeader>
      <CardContent>Card content here</CardContent>
    </Card>
  )
}
```

### Container
Responsive max-width wrapper.

```bash
npx shadcn@latest add container
```

### Separator
Visual divider line.

```bash
npx shadcn@latest add separator
```

Usage:
```tsx
import { Separator } from "@/components/ui/separator"

<Separator />
```

### Scroll Area
Scrollable container with custom scrollbar.

```bash
npx shadcn@latest add scroll-area
```

---

## Form Components

### Button
Interactive button component.

```bash
npx shadcn@latest add button
```

Variants: `default`, `secondary`, `destructive`, `outline`, `ghost`, `link`

Usage:
```tsx
import { Button } from "@/components/ui/button"

<Button>Click me</Button>
<Button variant="secondary">Secondary</Button>
<Button disabled>Disabled</Button>
```

### Input
Text input field.

```bash
npx shadcn@latest add input
```

Usage:
```tsx
import { Input } from "@/components/ui/input"

<Input placeholder="Enter text..." />
<Input type="email" placeholder="Email..." />
```

### Label
Form label for inputs.

```bash
npx shadcn@latest add label
```

Usage:
```tsx
import { Label } from "@/components/ui/label"

<Label htmlFor="email">Email</Label>
<Input id="email" />
```

### Checkbox
Single checkbox input.

```bash
npx shadcn@latest add checkbox
```

Usage:
```tsx
import { Checkbox } from "@/components/ui/checkbox"

<Checkbox id="terms" />
<Label htmlFor="terms">I agree to terms</Label>
```

### Radio Group
Multiple choice radio buttons.

```bash
npx shadcn@latest add radio-group
```

Usage:
```tsx
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"

<RadioGroup defaultValue="option1">
  <RadioGroupItem value="option1" id="option1" />
  <Label htmlFor="option1">Option 1</Label>
  <RadioGroupItem value="option2" id="option2" />
  <Label htmlFor="option2">Option 2</Label>
</RadioGroup>
```

### Select
Dropdown select component.

```bash
npx shadcn@latest add select
```

Usage:
```tsx
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

<Select>
  <SelectTrigger>
    <SelectValue placeholder="Select option" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="option1">Option 1</SelectItem>
    <SelectItem value="option2">Option 2</SelectItem>
  </SelectContent>
</Select>
```

### Textarea
Multi-line text input.

```bash
npx shadcn@latest add textarea
```

Usage:
```tsx
import { Textarea } from "@/components/ui/textarea"

<Textarea placeholder="Enter your message..." />
```

### Form (with react-hook-form)
Form wrapper with validation support.

```bash
npx shadcn@latest add form
npm install react-hook-form @hookform/resolvers zod
```

---

## Dialog & Overlay Components

### Dialog
Modal dialog that overlays content.

```bash
npx shadcn@latest add dialog
```

Usage:
```tsx
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"

<Dialog>
  <DialogTrigger>Open Dialog</DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Dialog Title</DialogTitle>
      <DialogDescription>Dialog Description</DialogDescription>
    </DialogHeader>
    Dialog content here
  </DialogContent>
</Dialog>
```

### Alert Dialog
Confirmation dialog for important actions.

```bash
npx shadcn@latest add alert-dialog
```

Usage:
```tsx
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog"

<AlertDialog>
  <AlertDialogTrigger>Delete</AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Are you sure?</AlertDialogTitle>
    </AlertDialogHeader>
    <AlertDialogCancel>Cancel</AlertDialogCancel>
    <AlertDialogAction>Delete</AlertDialogAction>
  </AlertDialogContent>
</AlertDialog>
```

### Sheet
Side drawer/panel component.

```bash
npx shadcn@latest add sheet
```

### Drawer
Alternative drawer implementation.

```bash
npx shadcn@latest add drawer
```

### Popover
Floating popover component.

```bash
npx shadcn@latest add popover
```

### Tooltip
Hover tooltip.

```bash
npx shadcn@latest add tooltip
```

Usage:
```tsx
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"

<TooltipProvider>
  <Tooltip>
    <TooltipTrigger>Hover me</TooltipTrigger>
    <TooltipContent>Tooltip text</TooltipContent>
  </Tooltip>
</TooltipProvider>
```

---

## Navigation Components

### Tabs
Tab navigation.

```bash
npx shadcn@latest add tabs
```

Usage:
```tsx
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

<Tabs defaultValue="tab1">
  <TabsList>
    <TabsTrigger value="tab1">Tab 1</TabsTrigger>
    <TabsTrigger value="tab2">Tab 2</TabsTrigger>
  </TabsList>
  <TabsContent value="tab1">Content 1</TabsContent>
  <TabsContent value="tab2">Content 2</TabsContent>
</Tabs>
```

### Pagination
Page navigation.

```bash
npx shadcn@latest add pagination
```

### Breadcrumb
Breadcrumb navigation.

```bash
npx shadcn@latest add breadcrumb
```

### Navigation Menu
Vertical/horizontal navigation menu.

```bash
npx shadcn@latest add navigation-menu
```

---

## Data Display Components

### Table
Basic data table.

```bash
npx shadcn@latest add table
```

Usage:
```tsx
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"

<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Header 1</TableHead>
      <TableHead>Header 2</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    <TableRow>
      <TableCell>Data 1</TableCell>
      <TableCell>Data 2</TableCell>
    </TableRow>
  </TableBody>
</Table>
```

### Data Table
Advanced data table with sorting, filtering, pagination.

```bash
npx shadcn@latest add data-table
npm install @tanstack/react-table
```

### Badge
Status badge.

```bash
npx shadcn@latest add badge
```

Usage:
```tsx
import { Badge } from "@/components/ui/badge"

<Badge>New</Badge>
<Badge variant="secondary">Secondary</Badge>
```

### Progress
Progress bar.

```bash
npx shadcn@latest add progress
```

Usage:
```tsx
import { Progress } from "@/components/ui/progress"

<Progress value={33} />
```

### Skeleton
Loading skeleton placeholder.

```bash
npx shadcn@latest add skeleton
```

Usage:
```tsx
import { Skeleton } from "@/components/ui/skeleton"

<Skeleton className="h-12 w-12 rounded-full" />
```

---

## Feedback Components

### Alert
Alert message box.

```bash
npx shadcn@latest add alert
```

Usage:
```tsx
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"

<Alert>
  <AlertTitle>Title</AlertTitle>
  <AlertDescription>Description</AlertDescription>
</Alert>
```

### Toaster
Toast notification system.

```bash
npx shadcn@latest add toaster
npm install sonner
```

---

## Input Components (Specialized)

### Combobox
Searchable dropdown.

```bash
npx shadcn@latest add combobox
npm install cmdk
```

### Command/Command Menu
Command palette/menu.

```bash
npx shadcn@latest add command
npm install cmdk
```

### Slider
Numeric range slider.

```bash
npx shadcn@latest add slider
```

### Switch
Toggle switch.

```bash
npx shadcn@latest add switch
```

Usage:
```tsx
import { Switch } from "@/components/ui/switch"

<Switch />
```

---

## Installation Patterns

### Layout with Cards
```bash
npx shadcn@latest add card separator
```

### Basic Form
```bash
npx shadcn@latest add input label button
```

### Advanced Form
```bash
npx shadcn@latest add form input label button textarea
```

### Data Display
```bash
npx shadcn@latest add table badge progress
```

### Complete UI Kit (selective)
```bash
npx shadcn@latest add button input label checkbox radio-group select textarea card dialog tabs pagination badge progress
```

---

## Component Dependencies

shadcn automatically handles dependencies. Common ones:

- **Most components:** `clsx`, `tailwind-merge`, `class-variance-authority`
- **Form, Slider:** `@radix-ui/react-*` primitives
- **Select, Combobox:** `cmdk`
- **Data Table:** `@tanstack/react-table`
- **Toast:** `sonner`

Just add the component you want - dependencies install automatically.

---

## Quick Commands

```bash
# View available components
npx shadcn@latest list

# Search for component
npx shadcn@latest search table

# Preview component code before installing
npx shadcn@latest view button

# Add component
npx shadcn@latest add button

# Add multiple components
npx shadcn@latest add button card input

# View help
npx shadcn@latest --help
```

---

## More Information

For detailed documentation and component previews, visit: https://ui.shadcn.com/docs/components
