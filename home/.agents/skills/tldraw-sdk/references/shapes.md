# Shapes Reference

## ShapeUtil Required Methods

Every ShapeUtil must implement:

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  static override type = 'my-shape' as const
  
  // 1. Default props for new shapes
  getDefaultProps(): MyShape['props'] {
    return { w: 100, h: 100 }
  }
  
  // 2. Geometry for hit testing, bounds, snapping
  getGeometry(shape: MyShape): Geometry2d {
    return new Rectangle2d({
      width: shape.props.w,
      height: shape.props.h,
      isFilled: true,
    })
  }
  
  // 3. React component for rendering
  component(shape: MyShape): JSX.Element {
    return <div style={{ width: shape.props.w, height: shape.props.h }} />
  }
  
  // 4. SVG for selection outline
  indicator(shape: MyShape): JSX.Element {
    return <rect width={shape.props.w} height={shape.props.h} />
  }
}
```

## ShapeUtil Optional Methods

### Capability Overrides

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  // Interaction capabilities
  canEdit() { return true }           // Double-click to edit
  canResize() { return true }         // Show resize handles
  canRotate() { return true }         // Show rotate handle
  canCrop() { return false }          // Allow cropping
  canBind() { return true }           // Allow arrow bindings
  canReceiveNewChildrenOfType() { return false }  // Can contain children
  
  // Rendering capabilities
  hideSelectionBoundsFg() { return false }  // Hide foreground selection UI
  hideSelectionBoundsBg() { return false }  // Hide background selection UI
  canCull() { return true }           // Can be culled when off-screen
}
```

### Lifecycle Hooks

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  // Before create/update - can modify or validate
  onBeforeCreate(shape) { return shape }
  onBeforeUpdate(prev, next) { return next }
  
  // Transform hooks
  onResize(shape, info: TLResizeInfo) {
    return { props: { w: shape.props.w * info.scaleX, h: shape.props.h * info.scaleY } }
  }
  onRotate(shape, rotation: number) {
    return { rotation }
  }
  onTranslate(shape, offset: Vec2d) {
    return { x: shape.x + offset.x, y: shape.y + offset.y }
  }
  
  // Interaction hooks
  onDoubleClick(shape) { /* Handle double-click */ }
  onDragShapesOver({ shape, shapes }) { /* Shapes dragged over this */ }
  onDropShapes({ shape, shapes, point }) { /* Shapes dropped on this */ }
  
  // Children change (for container shapes)
  onChildrenChange(shape) { /* Children added/removed/reordered */ }
}
```

### Handles

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  getHandles(shape: MyShape): TLHandle[] {
    return [
      { id: 'nw', type: 'shape', x: 0, y: 0 },
      { id: 'se', type: 'shape', x: shape.props.w, y: shape.props.h },
      { id: 'rotation', type: 'virtual', x: shape.props.w / 2, y: -50 },
    ]
  }
  
  onHandleChange(shape, handle) {
    if (handle.id === 'nw') {
      return { props: { ... } }
    }
  }
}
```

### Text Content

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  // For shapes with editable text
  getText(shape: MyShape): string {
    return shape.props.content
  }
  
  // For accessibility (overrides getText for screen readers)
  getAriaDescriptor(shape: MyShape): string | undefined {
    return `${shape.props.title}: ${shape.props.summary}`
  }
}
```

## Geometry Classes

Import from `@tldraw/editor`:

| Class | Use Case |
|-------|----------|
| `Rectangle2d` | Axis-aligned rectangles |
| `Circle2d` | True circles (center + radius) |
| `Ellipse2d` | Ellipses with different w/h |
| `Polygon2d` | Closed polygons |
| `Polyline2d` | Open paths |
| `Arc2d` | Circular arcs |
| `Stadium2d` | Rounded rectangles |
| `Group2d` | Composite geometry (multiple shapes) |

```typescript
import { Rectangle2d, Circle2d, Group2d } from '@tldraw/editor'

getGeometry(shape) {
  // Rectangle
  return new Rectangle2d({ width: 100, height: 100, isFilled: true })
  
  // Circle
  return new Circle2d({ x: 50, y: 50, r: 50 })
  
  // Composite (multiple parts)
  return new Group2d([
    new Rectangle2d({ ... }),
    new Circle2d({ ... }),
  ])
}
```

## Shape Props Schema

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  static override props = {
    w: T.number,
    h: T.number,
    color: DefaultColorStyle,  // Built-in style
    opacity: T.number,
  }
}
```

## Shape Migrations

```typescript
class MyShapeUtil extends ShapeUtil<MyShape> {
  static override migrations = defineMigrations({
    currentVersion: 2,
    migrators: {
      1: {
        up: (shape) => ({ ...shape, props: { ...shape.props, newProp: 'default' } }),
        down: (shape) => {
          const { newProp, ...rest } = shape.props
          return { ...shape, props: rest }
        },
      },
      2: {
        up: (shape) => ({ ...shape, props: { ...shape.props, renamed: shape.props.old } }),
        down: (shape) => ({ ...shape, props: { ...shape.props, old: shape.props.renamed } }),
      },
    },
  })
}
```

## Registering Custom Shapes

```tsx
import { Tldraw } from 'tldraw'
import 'tldraw/tldraw.css'

function App() {
  return (
    <Tldraw 
      shapeUtils={[MyShapeUtil, AnotherShapeUtil]}
    />
  )
}
```

## Configuring Built-in Shapes

```typescript
import { GeoShapeUtil, Tldraw } from 'tldraw'

const ConfiguredGeoShapeUtil = GeoShapeUtil.configure({
  canCrop: false,
  canResize: true,
  hideSelectionBoundsFg: true,
})

function App() {
  return <Tldraw shapeUtils={[ConfiguredGeoShapeUtil]} />
}
```

## Built-in Shape Types

| Type | Props | Description |
|------|-------|-------------|
| `geo` | w, h, geo (rectangle|ellipse|triangle), fill, color | Basic geometric shapes |
| `text` | w, h, text, size, font, align | Editable text |
| `note` | w, h, text, size, color | Sticky note |
| `draw` | points[], isComplete, isClosed, segments[] | Freehand drawing |
| `line` | points[], isComplete | Straight line |
| `highlight` | points[], isComplete | Highlighter mark |
| `arrow` | start, end, bend, sides, fill | Connector arrow |
| `frame` | w, h, name | Container/clipping shape |
| `group` | (logical only) | Logical grouping |
| `image` | w, h, assetId, crop | Image display |
| `video` | w, h, assetId, time | Video display |
| `bookmark` | assetId | Web page preview |
| `embed` | w, h, embed, src | Embedded content |

## Shape Methods via Editor

```typescript
// Create
editor.createShape({ type: 'geo', x: 100, y: 100, props: { w: 200, h: 150 } })
editor.createShapes([shape1, shape2])

// Update (partial)
editor.updateShape({ id: shapeId, x: 200 })
editor.updateShapes([{ id: shapeId, rotation: Math.PI / 4 }])

// Delete
editor.deleteShape(shapeId)
editor.deleteShapes([id1, id2])

// Get
editor.getShape<TLGeoShape>(shapeId)
editor.getCurrentPageShapes()
editor.getShapeAtPoint(point)
editor.getShapesAtPoint(point, { margin: 10 })
editor.getShapeAndDescendants(shapeId)  // Include children

// Bounds
editor.getShapeGeometry(shapeId)
editor.getShapePageBounds(shapeId)
editor.getShapeLocalBounds(shapeId)
```

## Examples

- [Custom shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/custom-shape)
- [Editable custom shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/editable-shape)
- [Clickable custom shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/interactive-shape)
- [Shape with geometry](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/shape-with-geometry)
- [Shape with custom styles](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/shape-with-custom-styles)
- [Shape with migrations](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/shape-with-migrations)
- [Shape with handles](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/speech-bubble)
- [Cubic bezier shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/cubic-bezier-shape)
- [Data grid shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/ag-grid-shape)
- [Popup shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/popup-shape)
- [Custom clipping shape](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/custom-clipping-shape)
- [DOM-based shape size](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/shapes/tools/size-from-dom)
