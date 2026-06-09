# Bindings Reference

Bindings create persistent relationships between shapes. When an arrow points to a rectangle, a binding stores that connection so the arrow stays attached when the rectangle moves.

## Binding Record Structure

```typescript
interface TLBaseBinding<Type, Props> {
  id: TLBindingId
  typeName: 'binding'
  type: Type
  fromId: TLShapeId  // Source shape
  toId: TLShapeId    // Target shape
  props: Props
  meta: JsonObject
}

// Arrow binding example
const arrowBinding: TLArrowBinding = {
  id: 'bind:arrow1',
  type: 'arrow',
  fromId: 'shape:arrow1',
  toId: 'shape:rectangle1',
  props: {
    terminal: 'end',
    normalizedAnchor: { x: 0.5, y: 0.5 },
    isPrecise: false,
    isExact: false,
    snap: 'none',
  },
}
```

## BindingUtil Structure

```typescript
import { BindingUtil } from '@tldraw/editor'

class MyBindingUtil extends BindingUtil<MyBinding> {
  static override type = 'my-binding'
  
  // Required: default props
  override getDefaultProps(): MyBinding['props'] {
    return { offset: { x: 0, y: 0 } }
  }
}
```

## BindingUtil Lifecycle Hooks

### Creation Hooks

```typescript
class MyBindingUtil extends BindingUtil<MyBinding> {
  // Before binding is created - can modify or return false to cancel
  override onBeforeCreate(binding: MyBinding): MyBinding | false {
    return binding
  }
  
  // After binding is created
  override onAfterCreate(binding: MyBinding) {
    // Side effects after creation
  }
}
```

### Change Hooks

```typescript
class MyBindingUtil extends BindingUtil<MyBinding> {
  // Before binding props change - can modify or return false
  override onBeforeChange(binding: MyBinding, changes: Partial<MyBinding>): MyBinding | false {
    return { ...binding, ...changes }
  }
  
  // After binding props change
  override onAfterChange(binding: MyBinding) {
    // Side effects after change
  }
  
  // When the "from" shape changes position/props
  override onAfterChangeFromShape({ binding, shapeAfter }: { binding: MyBinding, shapeAfter: TLShape }) {
    // Update binding or "to" shape in response
  }
  
  // When the "to" shape changes position/props
  override onAfterChangeToShape({ binding, shapeAfter }: { binding: MyBinding, shapeAfter: TLShape }) {
    // Common: update "from" shape to follow
    const fromShape = this.editor.getShape(binding.fromId)
    if (!fromShape) return
    
    this.editor.updateShapes([{
      id: fromShape.id,
      x: shapeAfter.x + binding.props.offset.x,
      y: shapeAfter.y + binding.props.offset.y,
    }])
  }
}
```

### Deletion Hooks

```typescript
class MyBindingUtil extends BindingUtil<MyBinding> {
  // Before binding is deleted - can return false to cancel
  override onBeforeDelete(binding: MyBinding): false | void {
    // Return false to prevent deletion
  }
  
  // After binding is deleted
  override onAfterDelete(binding: MyBinding) {
    // Cleanup
  }
}
```

### Isolation Hooks (Critical for Bindings)

Isolation occurs when a binding is removed due to deletion, copy, or duplication of one shape but not the other.

```typescript
class ArrowBindingUtil extends BindingUtil<TLArrowBinding> {
  // Before binding is removed because "from" shape is separated
  override onBeforeIsolateFromShape({ binding }: { binding: TLArrowBinding }) {
    // Bake in current attachment point before binding disappears
    const arrow = this.editor.getShape(binding.fromId)
    if (!arrow) return
    
    // Update arrow to remember where it was pointing
    this.editor.updateShapes([{
      id: arrow.id,
      props: {
        bend: arrow.props.bend,  // Preserve current state
      },
    }])
  }
  
  // Before binding is removed because "to" shape is separated
  override onBeforeIsolateToShape({ binding }: { binding: TLArrowBinding }) {
    // Arrow should "let go" naturally
  }
}
```

### Batch Completion Hook

```typescript
class MyBindingUtil extends BindingUtil<MyBinding> {
  // After all binding operations in a transaction complete
  override onOperationComplete(binding: MyBinding) {
    // Useful for aggregate updates across multiple bindings
  }
}
```

## Registering Bindings

```tsx
import { Tldraw } from 'tldraw'

function App() {
  return (
    <Tldraw 
      bindingUtils={[MyBindingUtil, PinBindingUtil]}
    />
  )
}
```

## Creating Bindings

```typescript
// Create single binding
editor.createBinding({
  type: 'arrow',
  fromId: arrowShape.id,
  toId: targetShape.id,
  props: {
    terminal: 'end',
    normalizedAnchor: { x: 0.5, y: 0.5 },
  },
})

// Create multiple bindings
editor.createBindings([
  { type: 'arrow', fromId: 'shape1', toId: 'shape2' },
  { type: 'arrow', fromId: 'shape1', toId: 'shape3' },
])
```

## Querying Bindings

```typescript
// Get specific binding
const binding = editor.getBinding(bindingId)

// Get bindings where shape is the source
const outgoing = editor.getBindingsFromShape(shapeId)
const outgoingArrows = editor.getBindingsFromShape(shapeId, 'arrow')

// Get bindings where shape is the target
const incoming = editor.getBindingsToShape(shapeId)
const incomingArrows = editor.getBindingsToShape(shapeId, 'arrow')

// Get all bindings involving shape (either direction)
const all = editor.getBindingsInvolvingShape(shapeId)
```

## Updating Bindings

```typescript
// Update binding props
editor.updateBinding({
  id: bindingId,
  props: { normalizedAnchor: { x: 0.8, y: 0.2 } },
})

// Update multiple bindings
editor.updateBindings([
  { id: bindingId1, props: { ... } },
  { id: bindingId2, props: { ... } },
])
```

## Deleting Bindings

```typescript
// Delete single binding
editor.deleteBinding(bindingId)

// Delete with isolation callbacks (shapes "let go" naturally)
editor.deleteBinding(bindingId, { isolateShapes: true })

// Delete multiple bindings
editor.deleteBindings([bindingId1, bindingId2])
```

## Controlling Which Shapes Can Bind

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  canBind({ fromShapeType, toShapeType, bindingType }: TLShapeUtilCanBindOpts) {
    // Only allow arrow bindings where this shape is the target
    if (bindingType === 'arrow' && toShapeType === this.type) {
      return true
    }
    
    // Allow pin bindings in both directions
    if (bindingType === 'pin') {
      return true
    }
    
    return false
  }
}
```

## Custom Binding Type Definition

```typescript
// 1. Extend TypeScript types
declare module 'tldraw' {
  export interface TLGlobalBindingPropsMap {
    myBinding: {
      anchor: VecModel
      strength: number
    }
  }
}

// 2. Create BindingUtil
class MyBindingUtil extends BindingUtil<TLBinding<'myBinding'>> {
  static override type = 'myBinding'
  
  override getDefaultProps() {
    return { 
      anchor: { x: 0.5, y: 0.5 }, 
      strength: 1 
    }
  }
  
  override onAfterChangeToShape({ binding, shapeAfter }) {
    // Keep connected shape in sync
  }
}

// 3. Register
<Tldraw bindingUtils={[MyBindingUtil]} />
```

## Binding Lifecycle Diagram

```
Create → onBeforeCreate → onAfterCreate
              ↓
Change → onBeforeChange → onAfterChange
              ↓
Shape Move → onAfterChangeFromShape / onAfterChangeToShape
              ↓
Delete → onBeforeDelete → onAfterDelete
              OR
Isolate → onBeforeIsolateFromShape / onBeforeIsolateToShape
```

## Examples

- [Sticker bindings](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/sticker-bindings) - Shapes that stick to and follow other shapes
- [Pin bindings](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/pin-bindings) - Connect networks of shapes that move together
- [Layout bindings](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/layout-bindings) - Constrain shapes to layout positions
- [Arrow binding options](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/arrow-binding-options)
- [Attach shapes together](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/attach-shapes-together)
