# UI Reference

The `@tldraw/tldraw` package provides a complete React UI with menus, toolbars, panels, and dialogs.

## Component Slot Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Top Panel                             │
├────────────┬──────────────────────────┬─────────────────┤
│   Left     │         Canvas           │     Right       │
│   Panel    │                          │     Panel       │
├────────────┴──────────────────────────┴─────────────────┤
│                   Bottom Panel                           │
└─────────────────────────────────────────────────────────┘
```

## TLUiOverrides

```typescript
import { Tldraw, TLUiOverrides } from 'tldraw'

const overrides: TLUiOverrides = {
  // Modify actions
  actions(editor, actions, helpers) {
    actions['duplicate'].kbd = 'cmd+shift+d,ctrl+shift+d'
    return actions
  },
  
  // Modify tools
  tools(editor, tools, helpers) {
    delete tools.text  // Remove text tool
    tools['heart'] = {
      id: 'heart',
      icon: 'heart',
      label: 'Heart Tool',
      kbd: 'h',
      onSelect: () => editor.setCurrentTool('heart'),
    }
    return tools
  },
  
  // Modify menus
  menu(editor, menu) {
    // Add/remove menu items
    return menu
  },
  
  // Modify toolbar
  toolbar(editor, toolbar) {
    // Add/remove toolbar items
    return toolbar
  },
}

function App() {
  return <Tldraw overrides={overrides} />
}
```

## Actions System

### Accessing Actions

```typescript
import { useActions } from 'tldraw'

function MyComponent() {
  const actions = useActions()
  
  return (
    <button onClick={() => actions['undo'].onSelect('toolbar')}>
      Undo
    </button>
  )
}
```

### Creating Custom Actions

```typescript
const overrides: TLUiOverrides = {
  actions(editor, actions, helpers) {
    actions['show-selection-count'] = {
      id: 'show-selection-count',
      label: 'action.show-selection-count',
      kbd: 'shift+c',
      icon: 'info-circle',
      onSelect(source) {
        const count = editor.getSelectedShapeIds().length
        helpers.addToast({ title: `${count} shapes selected` })
      },
    }
    return actions
  },
}
```

### Action Properties

```typescript
interface TLUiActionItem {
  id: string
  label?: string | { [key: string]: string }  // Translation key or context map
  icon?: string | React.ReactElement
  kbd?: string  // 'cmd+g,ctrl+g' for platform alternatives
  readonlyOk?: boolean    // Works in readonly mode
  checkbox?: boolean      // Toggle with checkmark
  isRequiredA11yAction?: boolean  // Works even with shortcuts disabled
  onSelect(source: TLUiEventSource): void
}
```

### Event Sources

```typescript
// Source values for analytics
'source' can be:
- 'kbd'          // Keyboard shortcut
- 'menu'         // Menu click
- 'context-menu' // Right-click menu
- 'toolbar'      // Toolbar button
- 'quick-actions' // Quick actions panel
- 'zoom-menu'    // Zoom menu
- 'share-panel'  // Share panel
- 'style-panel'  // Style panel
```

### Helper Utilities

```typescript
const overrides: TLUiOverrides = {
  actions(editor, actions, helpers) {
    actions['my-action'] = {
      id: 'my-action',
      label: 'action.my-action',
      onSelect(source) {
        // Toasts
        helpers.addToast({ title: 'Hello', description: 'World' })
        helpers.removeToast(toastId)
        helpers.clearToasts()
        
        // Dialogs
        helpers.addDialog({ type: 'dialog-name', ... })
        helpers.removeDialog(dialogId)
        helpers.clearDialogs()
        
        // Translation
        const label = helpers.msg('action.my-action.label')
        
        // Mobile check
        const isMobile = helpers.isMobile
        
        // File operations
        helpers.insertMedia()  // Open file picker
        helpers.replaceImage()  // Replace selected image
        helpers.replaceVideo()
        
        // Clipboard
        helpers.cut()
        helpers.copy()
        helpers.paste()
        helpers.copyAs('svg' | 'png')
        helpers.exportAs('svg' | 'png' | 'json')
        
        // Print
        helpers.printSelectionOrPages()
        
        // Embeds
        const embed = helpers.getEmbedDefinition(url)
      },
    }
    return actions
  },
}
```

## Menu Components

```typescript
import { TldrawUiMenuGroup, TldrawUiMenuActionItem, TldrawUiMenuActionCheckboxItem } from 'tldraw'

function CustomMenu() {
  return (
    <TldrawUiMenuGroup id="edit">
      <TldrawUiMenuActionItem actionId="undo" />
      <TldrawUiMenuActionItem actionId="redo" />
      <TldrawUiMenuActionItem actionId="duplicate" />
      {/* Toggle action with checkbox */}
      <TldrawUiMenuActionCheckboxItem actionId="toggle-grid" />
    </TldrawUiMenuGroup>
  )
}
```

## Context-Sensitive Labels

```typescript
actions['export-as-svg'] = {
  id: 'export-as-svg',
  label: {
    default: 'action.export-as-svg',
    menu: 'action.export-as-svg.short',
    'context-menu': 'action.export-as-svg.short',
  },
}
```

## Toolbar Customization

### Remove Tool from Toolbar

```typescript
const overrides: TLUiOverrides = {
  tools(editor, tools, helpers) {
    delete tools.text
    delete tools.eraser
    delete tools.frame
    return tools
  },
}
```

### Add Tool to Toolbar

```typescript
// 1. Define custom tool
class HeartTool extends StateNode {
  static override id = 'heart'
}

// 2. Add to UI
const overrides: TLUiOverrides = {
  tools(editor, tools, helpers) {
    tools['heart'] = {
      id: 'heart',
      icon: 'heart',
      label: 'Heart',
      kbd: 'h',
      onSelect: () => editor.setCurrentTool('heart'),
    }
    return tools
  },
}

// 3. Override Toolbar component
function App() {
  return (
    <Tldraw 
      tools={[HeartTool]} 
      overrides={overrides}
      components={{
        Toolbar: (props) => (
          <TldrawUiToolbar {...props}>
            <TldrawUiToolItem toolId="heart" />
          </TldrawUiToolbar>
        ),
      }}
    />
  )
}
```

## Panels

### Top Panel

```typescript
function CustomTopPanel() {
  return (
    <TldrawUiPanel id="top">
      <div>Collaboration UI, search, etc.</div>
    </TldrawUiPanel>
  )
}
```

### Style Panel Customization

```typescript
const overrides: TLUiOverrides = {
  stylePanel(editor, panel, helpers) {
    // Add custom style controls
    return panel
  },
}
```

## Dialogs and Toasts

### Showing Toasts

```typescript
// From action handler
helpers.addToast({
  title: 'Success',
  description: 'Shape created',
  action: { label: 'Undo', onClick: () => editor.undo() },
})

// From component
import { useToasts } from 'tldraw'

function MyComponent() {
  const { addToast } = useToasts()
  
  return (
    <button onClick={() => addToast({ title: 'Hello!' })}>
      Show Toast
    </button>
  )
}
```

### Showing Dialogs

```typescript
helpers.addDialog({
  type: 'edit-link',
  url: 'https://example.com',
})
```

## Hide UI Components

### Hide Entire UI

```typescript
<Tldraw hideUi />
```

### Hide Specific Components

```typescript
<Tldraw 
  components={{
    Toolbar: () => null,
    StylePanel: () => null,
    MainMenu: () => null,
  }}
/>
```

## Vertical Toolbar

```typescript
<Tldraw 
  components={{
    Toolbar: (props) => (
      <TldrawUiToolbar {...props} orientation="vertical" />
    ),
  }}
/>
```

## Focus Mode

```typescript
// Toggle programmatically
editor.updateInstanceState({ isFocusMode: true })

// Check focus mode
const isFocus = editor.getInstanceState().isFocusMode
```

## Dark Mode

```typescript
// Infer from system
<Tldraw inferDarkMode />

// Toggle programmatically
const [isDark, setIsDark] = useState(false)
<Tldraw darkMode={isDark} />
```

## Accessibility

### Enhanced Accessibility Mode

```typescript
// Enable visible labels in UI
editor.user.updateUserPreferences({
  enhancedA11yMode: true,
})

// Component
<TldrawUiToggleEnhancedA11yModeItem />
```

### Reduce Motion

```typescript
import { usePrefersReducedMotion } from 'tldraw'

function AnimatedComponent() {
  const prefersReducedMotion = usePrefersReducedMotion()
  
  if (prefersReducedMotion) {
    return <StaticVersion />
  }
  
  return <AnimatedVersion />
}
```

### Keyboard Shortcuts

```typescript
// Disable all shortcuts (for assistive tech users)
editor.user.updateUserPreferences({
  areKeyboardShortcutsEnabled: false,
})
```

## Custom Translations

```typescript
const translations = {
  'action.duplicate': 'Kopieren',
  'action.delete': 'Löschen',
  'tool.select': 'Auswählen',
}

<Tldraw 
  overrides={{
    msg(key) {
      return translations[key] || key
    },
  }}
/>
```

## Examples

- [Action overrides](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/action-overrides)
- [Keyboard shortcuts](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/keyboard-shortcuts)
- [Custom menus](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/custom-menus)
- [Add tool to toolbar](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/add-tool-to-toolbar)
- [Remove tool from toolbar](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/remove-tool)
- [Hide UI](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/hide-ui)
- [Screen reader accessibility](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/screen-reader-accessibility)
- [Toasts and dialogs](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/toasts-and-dialogs)
