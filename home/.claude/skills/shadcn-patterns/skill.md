---
name: "shadcn/ui Advanced Patterns"
description: "Use this skill for advanced shadcn/ui integration patterns including forms with validation, data tables, performance optimization, testing, and migration from other component libraries. Assumes shadcn is already set up with components installed."
---

# shadcn/ui Advanced Patterns

Advanced patterns for building complex features with shadcn/ui.

**Prerequisites:** Your project must have:
- Completed `shadcn init` setup
- Components installed and working
- Familiarity with React and TypeScript
- Basic understanding of component customization

---

## Forms with Validation

### Setup

```bash
npx shadcn@latest add form input button label
npm install react-hook-form @hookform/resolvers zod
```

### Simple Form Example

```tsx
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import * as z from 'zod'
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from '@/components/ui/form'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'

// Define schema
const formSchema = z.object({
  username: z.string().min(2, 'Username must be at least 2 characters'),
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
})

type FormValues = z.infer<typeof formSchema>

export function MyForm() {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      username: '',
      email: '',
      password: '',
    },
  })

  function onSubmit(values: FormValues) {
    console.log(values)
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
        <FormField
          control={form.control}
          name="username"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Username</FormLabel>
              <FormControl>
                <Input placeholder="john_doe" {...field} />
              </FormControl>
              <FormDescription>Your unique username</FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="john@example.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Password</FormLabel>
              <FormControl>
                <Input type="password" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <Button type="submit">Submit</Button>
      </form>
    </Form>
  )
}
```

---

## Data Tables

### Setup

```bash
npx shadcn@latest add table
npm install @tanstack/react-table
```

### Basic Table Example

```tsx
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

interface User {
  id: string
  name: string
  email: string
  status: 'active' | 'inactive'
}

const users: User[] = [
  { id: '1', name: 'John Doe', email: 'john@example.com', status: 'active' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com', status: 'active' },
  { id: '3', name: 'Bob Johnson', email: 'bob@example.com', status: 'inactive' },
]

export function UsersTable() {
  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Name</TableHead>
          <TableHead>Email</TableHead>
          <TableHead>Status</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {users.map((user) => (
          <TableRow key={user.id}>
            <TableCell>{user.name}</TableCell>
            <TableCell>{user.email}</TableCell>
            <TableCell className="capitalize">{user.status}</TableCell>
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}
```

### Advanced Table with TanStack Table

```tsx
import { flexRender, getCoreRowModel, useReactTable } from '@tanstack/react-table'
import { ColumnDef } from '@tanstack/react-table'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

interface User {
  id: string
  name: string
  email: string
  status: 'active' | 'inactive'
}

const columns: ColumnDef<User>[] = [
  {
    accessorKey: 'name',
    header: 'Name',
  },
  {
    accessorKey: 'email',
    header: 'Email',
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => <span className="capitalize">{row.getValue('status')}</span>,
  },
]

export function AdvancedTable({ data }: { data: User[] }) {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  })

  return (
    <Table>
      <TableHeader>
        {table.getHeaderGroups().map((headerGroup) => (
          <TableRow key={headerGroup.id}>
            {headerGroup.headers.map((header) => (
              <TableHead key={header.id}>
                {header.isPlaceholder ? null : flexRender(header.column.columnDef.header, header.getContext())}
              </TableHead>
            ))}
          </TableRow>
        ))}
      </TableHeader>
      <TableBody>
        {table.getRowModel().rows.map((row) => (
          <TableRow key={row.id}>
            {row.getVisibleCells().map((cell) => (
              <TableCell key={cell.id}>{flexRender(cell.column.columnDef.cell, cell.getContext())}</TableCell>
            ))}
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}
```

---

## Modal Dialogs

### Simple Dialog

```tsx
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'

export function ConfirmDialog() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button>Delete Item</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Confirm Delete</DialogTitle>
          <DialogDescription>This action cannot be undone.</DialogDescription>
        </DialogHeader>
        <div className="flex gap-4">
          <Button variant="destructive">Delete</Button>
          <Button variant="outline">Cancel</Button>
        </div>
      </DialogContent>
    </Dialog>
  )
}
```

---

## Dropdown Menus

### Setup

```bash
npx shadcn@latest add dropdown-menu
```

### Example

```tsx
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuSeparator, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'
import { Button } from '@/components/ui/button'

export function UserMenu() {
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline">Menu</Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent>
        <DropdownMenuItem>Profile</DropdownMenuItem>
        <DropdownMenuItem>Settings</DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem className="text-red-600">Logout</DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
```

---

## Notifications/Toast

### Setup

```bash
npx shadcn@latest add toaster
npm install sonner
```

### Usage

```tsx
import { Toaster, toast } from 'sonner'

export function App() {
  return (
    <>
      <Toaster />
      <button
        onClick={() =>
          toast.success('Action completed successfully!', {
            description: 'Your changes have been saved.',
          })
        }
      >
        Show Toast
      </button>
    </>
  )
}
```

---

## Controlled Components

### Tabs Component

```tsx
import { useState } from 'react'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'

export function TabsExample() {
  const [activeTab, setActiveTab] = useState('tab1')

  return (
    <Tabs value={activeTab} onValueChange={setActiveTab}>
      <TabsList>
        <TabsTrigger value="tab1">Tab 1</TabsTrigger>
        <TabsTrigger value="tab2">Tab 2</TabsTrigger>
      </TabsList>
      <TabsContent value="tab1">Content for tab 1</TabsContent>
      <TabsContent value="tab2">Content for tab 2</TabsContent>
    </Tabs>
  )
}
```

---

## Performance Optimization

### Memoization

```tsx
import { memo } from 'react'

// Prevent re-renders when props haven't changed
const CardItem = memo(function CardItem({ item }: { item: Item }) {
  return <Card>{item.name}</Card>
})
```

### Code Splitting

Import components only when needed:

```tsx
import { lazy, Suspense } from 'react'

const HeavyComponent = lazy(() => import('./HeavyComponent'))

export function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  )
}
```

### Virtual Scrolling for Long Lists

```tsx
import { FixedSizeList as List } from 'react-window'

export function LargeList({ items }: { items: string[] }) {
  return (
    <List height={400} itemCount={items.length} itemSize={35} width="100%">
      {({ index, style }) => <div style={style}>{items[index]}</div>}
    </List>
  )
}
```

---

## Testing Components

### Unit Test Example

```typescript
import { render, screen } from '@testing-library/react'
import { Button } from '@/components/ui/button'

describe('Button', () => {
  it('renders button with text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument()
  })

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click</Button>)
    screen.getByRole('button').click()
    expect(handleClick).toHaveBeenCalled()
  })
})
```

### Form Testing Example

```typescript
import { render, screen, userEvent } from '@testing-library/react'
import { MyForm } from './MyForm'

it('submits form with valid data', async () => {
  const user = userEvent.setup()
  render(<MyForm />)

  await user.type(screen.getByLabelText(/username/i), 'john_doe')
  await user.type(screen.getByLabelText(/email/i), 'john@example.com')
  await user.type(screen.getByLabelText(/password/i), 'password123')
  await user.click(screen.getByRole('button', { name: /submit/i }))

  // Assert form submission happened
})
```

---

## Migration from Other Libraries

### From Material-UI

```tsx
// Material-UI
import { Button as MuiButton } from '@mui/material'

// shadcn/ui
import { Button } from '@/components/ui/button'

// Variants map similarly
<Button variant="contained" />    // MUI → <Button /> (default)
<Button variant="outlined" />     // MUI → <Button variant="outline" />
<Button variant="text" />         // MUI → <Button variant="ghost" />
```

### From Chakra UI

```tsx
// Chakra
import { Button, Box } from '@chakra-ui/react'

// shadcn/ui
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'

// Props are similar
<Button colorScheme="blue" />     // Chakra → <Button /> (use CSS variables instead)
<Box padding={4} />               // Chakra → <div className="p-4" /> (Tailwind)
```

---

## Monorepo Setup

If using shadcn in a monorepo with Turbo:

```bash
# In app package
npx shadcn@latest init

# In shared UI package
npx shadcn@latest init
# Components go in @repo/ui/src/components
```

Share components via package:
```typescript
// In app
import { Button } from '@repo/ui/components'
```

---

## Key Patterns Summary

1. **Forms** - react-hook-form + zod for validation
2. **Tables** - @tanstack/react-table for advanced features
3. **Dialogs** - Dialog + state management
4. **Lists** - Virtual scrolling for performance
5. **Navigation** - Tabs, Pagination, Breadcrumbs
6. **Testing** - @testing-library/react for unit tests
7. **Performance** - Memoization and code splitting
8. **Accessibility** - Components built with Radix for A11y

---

## Resources

- **react-hook-form:** https://react-hook-form.com
- **TanStack Table:** https://tanstack.com/table/latest
- **Testing Library:** https://testing-library.com
- **Sonner (Toast):** https://sonner.emilkowal.ski
- **shadcn/ui Docs:** https://ui.shadcn.com
