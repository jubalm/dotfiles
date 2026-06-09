# Tools Reference

Tools define how the editor responds to user input. Each tool handles a specific interaction mode—selecting shapes, drawing, panning the canvas.

## StateNode Structure

```typescript
import { StateNode, TLPointerEventInfo } from '@tldraw/editor'

class MyTool extends StateNode {
  static override id = 'my-tool'
  static override initial = 'idle'
  static override children() {
    return [Idle, Pointing, Active]
  }
  
  // Called when tool becomes active
  override onEnter() {
    this.editor.setCursor({ type: 'cross', rotation: 0 })
  }
  
  // Called when tool becomes inactive
  override onExit() {
    // Cleanup
  }
}
```

## Static Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | string | Required. Unique identifier |
| `initial` | string | Required if has children. Initial child state id |
| `children()` | function | Returns array of child state constructors |
| `isLockable` | boolean | Whether tool lock applies (default: true) |
| `useCoalescedEvents` | boolean | Batch pointer moves for performance (default: false) |

## Event Handlers

```typescript
class MyTool extends StateNode {
  // Pointer events
  override onPointerDown(info: TLPointerEventInfo) { }
  override onPointerMove(info: TLPointerEventInfo) { }
  override onPointerUp(info: TLPointerEventInfo) { }
  
  // Keyboard events
  override onKeyDown(info: TLKeyDownEventInfo) { }
  override onKeyUp(info: TLKeyUpEventInfo) { }
  
  // Click events (double, triple, quadruple)
  override onDoubleClick(info: TLClickEventInfo) { }
  
  // Animation frame
  override onTick() { }
  
  // Focus events
  override onFocus() { }
  override onBlur() { }
}
```

## Event Info Objects

```typescript
// Pointer event info
interface TLPointerEventInfo {
  target: 'shape' | 'canvas' | 'handle' | 'selection' | 'scribble'
  currentPagePoint: Vec2d  // Canvas coordinates
  currentScreenPoint: Vec2d  // Viewport coordinates
  shiftKey: boolean
  altKey: boolean
  cmdKey: boolean
  ctrlKey: boolean
  accelKey: boolean
}

// Click event info
interface TLClickEventInfo {
  target: 'shape' | 'canvas' | 'handle'
  phase: 'down' | 'up' | 'settle'
  clickCount: number  // 2=double, 3=triple, 4=quadruple
}
```

## State Transitions

```typescript
class SelectTool extends StateNode {
  static override id = 'select'
  static override initial = 'idle'
  static override children() {
    return [Idle, PointingShape, PointingCanvas, Translating, Resizing, Rotating]
  }
}

// Idle child state
class SelectIdle extends StateNode {
  static override id = 'idle'
  
  override onPointerDown(info: TLPointerEventInfo) {
    if (info.target === 'shape') {
      this.parent.transition('pointing_shape', info)
    } else if (info.target === 'canvas') {
      this.parent.transition('pointing_canvas', info)
    }
  }
}

// Pointing child state
class SelectPointingShape extends StateNode {
  static override id = 'pointing_shape'
  
  override onEnter(info: TLPointerEventInfo) {
    // Info from the transition that brought us here
  }
  
  override onPointerMove(info: TLPointerEventInfo) {
    if (this.editor.inputs.isDragging) {
      this.parent.transition('translating', info)
    }
  }
  
  override onPointerUp() {
    this.parent.transition('idle')
  }
}
```

## Transition Patterns

```typescript
// Transition to direct child
this.parent.transition('pointing', info)

// Transition to nested child (dot notation)
this.parent.transition('crop.pointing_handle', info)

// Transition with data (carried to onEnter)
this.parent.transition('active', { shapeId, startPoint })

// Check current state
if (this.id === 'idle') { }

// Access parent's current child
const currentChild = this.currentChild
```

## Tool Lock

Tool lock keeps the tool active after completing an action (for placing multiple items):

```typescript
class StampTool extends StateNode {
  static override id = 'stamp'
  
  override onPointerUp() {
    // Create stamp shape
    this.editor.createShape({ type: 'stamp', ... })
    
    // Check if tool lock is enabled
    if (this.editor.getInstanceState().isToolLocked) {
      // Stay active
      this.parent.transition('idle')
    } else {
      // Return to select tool
      this.editor.setCurrentTool('select')
    }
  }
}

// Toggle tool lock programmatically
editor.updateInstanceState({ isToolLocked: true })
```

## Accessing Editor

```typescript
class MyTool extends StateNode {
  override onPointerDown(info: TLPointerEventInfo) {
    // Read inputs
    const { currentPagePoint } = this.editor.inputs
    const selectedIds = this.editor.getSelectedShapeIds()
    
    // Query shapes
    const shapes = this.editor.getCurrentPageShapes()
    const shape = this.editor.getShape(shapeId)
    
    // Modify shapes
    this.editor.createShape({ type: 'geo', x: 100, y: 100 })
    this.editor.updateShape({ id: shapeId, x: 200 })
    this.editor.deleteShape(shapeId)
    this.editor.select(shapeId)
    
    // Camera
    this.editor.setCamera({ x: 0, y: 0, z: 1 })
    
    // Transitions
    this.editor.setCurrentTool('select')
  }
}
```

## Cursor Management

```typescript
class MyTool extends StateNode {
  override onEnter() {
    this.editor.setCursor({ type: 'cross', rotation: 0 })
  }
  
  override onExit() {
    this.editor.setCursor({ type: 'default', rotation: 0 })
  }
}

// Cursor types: 'default' | 'cross' | 'grabbing' | 'grab' | 'pointer' | 'loading'
```

## Registering Custom Tools

```tsx
import { Tldraw, StateNode } from 'tldraw'
import 'tldraw/tldraw.css'

class HeartTool extends StateNode {
  static override id = 'heart'
  // ... implementation
}

const customTools = [HeartTool, MeasureTool]  // Define outside component

function App() {
  return <Tldraw tools={customTools} />
}
```

## Overriding Default Tools (UI)

```typescript
import { Tldraw, TLUiOverrides } from 'tldraw'

const overrides: TLUiOverrides = {
  tools(editor, tools, helpers) {
    // Remove tool from toolbar
    delete tools.text
    
    // Add custom tool to toolbar
    tools['heart'] = {
      id: 'heart',
      icon: 'heart',
      label: 'Heart Tool',
      kbd: 'h',
      onSelect: () => editor.setCurrentTool('heart'),
    }
    
    return tools
  },
}

function App() {
  return <Tldraw tools={[HeartTool]} overrides={overrides} />
}
```

## Dynamic Tool Registration

```typescript
import { useState } from 'react'
import { Editor, StateNode, Tldraw } from 'tldraw'

function App() {
  const [editor, setEditor] = useState<Editor | null>(null)
  const [isEnabled, setIsEnabled] = useState(false)
  
  const toggleTool = () => {
    if (!editor) return
    if (isEnabled) {
      if (editor.getCurrentToolId() === 'heart') {
        editor.setCurrentTool('select')
      }
      editor.removeTool(HeartTool)
    } else {
      editor.setTool(HeartTool)
    }
    setIsEnabled(!isEnabled)
  }
  
  return (
    <>
      <Tldraw onMount={setEditor} />
      <button onClick={toggleTool}>Toggle Heart Tool</button>
    </>
  )
}
```

## Default Tools

| Tool | ID | Keyboard | Description |
|------|-----|----------|-------------|
| Select | `select` | V | Default selection tool |
| Hand | `hand` | H | Pan/zoom canvas |
| Draw | `draw` | D | Freehand drawing |
| Line | `line` | L | Straight lines |
| Arrow | `arrow` | A | Connector arrows |
| Rectangle | `geo-rectangle` | R | Rectangles |
| Ellipse | `geo-ellipse` | O | Ellipses |
| Triangle | `geo-triangle` | T | Triangles |
| Text | `text` | X | Text boxes |
| Note | `note` | S | Sticky notes |
| Highlight | `highlight` | I | Highlighter |
| Eraser | `eraser` | E | Erase shapes |
| Frame | `frame` | F | Container frames |
| Laser | `laser` | K | Laser pointer |

## Examples

- [Custom tool (sticker)](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/custom-tool)
- [Tool with child states](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/tool-with-child-states)
- [Screenshot tool](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/screenshot-tool)
- [Lasso select tool](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/lasso-select-tool)
- [Add tool to toolbar](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/add-tool-to-toolbar)
- [Remove tool from toolbar](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/ui/remove-tool)
- [Dynamic tools](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/dynamic-tools)
