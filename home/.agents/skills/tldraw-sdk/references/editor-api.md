# Editor API Reference

Core editor methods for common operations.

## Shape Operations

### Create

```typescript
// Single shape
editor.createShape({
  type: 'geo',
  x: 100, y: 100,
  rotation: 0,
  props: { w: 200, h: 150, geo: 'rectangle' },
})

// Multiple shapes
editor.createShapes([
  { type: 'text', x: 0, y: 0, props: { text: 'Hello' } },
  { type: 'geo', x: 100, y: 100, props: { w: 100, h: 100 } },
])

// With explicit ID
const shapeId = createShapeId('my-shape')
editor.createShape({ id: shapeId, type: 'geo', ... })
```

### Update

```typescript
// Single shape (partial update)
editor.updateShape({
  id: shapeId,
  x: 200,  // Only provide changed fields
})

// Multiple shapes
editor.updateShapes([
  { id: shapeId1, x: 100 },
  { id: shapeId2, rotation: Math.PI / 4 },
])

// With animation
editor.animateShape(
  { id: shapeId, x: 200, y: 300 },
  { animation: { duration: 500, easing: EASINGS.easeOutCubic } }
)
```

### Delete

```typescript
// Single shape
editor.deleteShape(shapeId)

// Multiple shapes
editor.deleteShapes([shapeId1, shapeId2])

// With isolation callbacks for bindings
editor.deleteShapes([shapeId], { isolateShapes: true })
```

### Query

```typescript
// By ID
const shape = editor.getShape<TLGeoShape>(shapeId)
const allShapes = editor.getShapes()

// Current page
const pageShapes = editor.getCurrentPageShapes()
const pageShapeIds = editor.getCurrentPageShapeIds()

// At point
const shapesAtPoint = editor.getShapesAtPoint({ x: 100, y: 200 })
const shapeAtPoint = editor.getShapeAtPoint({ x: 100, y: 200 })

// Selection
const selectedIds = editor.getSelectedShapeIds()
const selectedShapes = editor.getSelectedShapes()
const onlySelectedShape = editor.getOnlySelectedShape()

// Bounds
const pageBounds = editor.getShapePageBounds(shapeId)
const localBounds = editor.getShapeLocalBounds(shapeId)
const geometry = editor.getShapeGeometry(shapeId)

// Hierarchy
const children = editor.getSortedChildIdsForParent(parentId)
const descendants = editor.getShapeAndDescendants(shapeId)
const ancestors = editor.getShapeAncestors(shapeId)
```

## Selection Operations

```typescript
// Select shapes
editor.select(shapeId1, shapeId2)
editor.select([shapeId1, shapeId2])

// Add to selection
editor.select(shapeId, { resetting: false })

// Clear selection
editor.selectNone()

// Select all on page
editor.selectAll()

// Box select
editor.selectInBox({ x: 0, y: 0, w: 500, h: 500 })
```

## Group Operations

```typescript
// Group selected shapes
editor.groupShapes(selectedIds)

// Ungroup
editor.ungroupShapes(groupIds)

// Get focused group (double-clicked into)
const focusedGroup = editor.getFocusedGroup()

// Exit focused group
editor.popFocusedGroupId()
```

## Camera Operations

```typescript
// Set position
editor.setCamera({ x: 0, y: 0, z: 1 })

// With animation
editor.setCamera(
  { x: 0, y: 0, z: 1 },
  { animation: { duration: 500, easing: EASINGS.easeInOutCubic } }
)

// Zoom
editor.zoomIn()
editor.zoomOut()
editor.zoomToFit()
editor.zoomToSelection()
editor.zoomToBounds(bounds, { inset: 50 })
editor.resetZoom()

// Slide (momentum)
editor.slideCamera({
  speed: 2,
  direction: { x: 1, y: 0 },
  friction: 0.1,
})

// Stop animation
editor.stopCameraAnimation()
```

## Export Operations

```typescript
// As PNG
const pngBlob = await editor.toImageDataUrl(selectedIds, {
  format: 'png',
  quality: 1,
  scale: 2,
  background: true,  // Include background
})

// As SVG
const svgBlob = await editor.toSvg(selectedIds, {
  scale: 2,
  background: true,
})

// Copy to clipboard
editor.copyAs('png')
editor.copyAs('svg')

// Export files
editor.exportAs('png', selectedIds)
editor.exportAs('svg', selectedIds)
editor.exportAs('json', selectedIds)
```

## History (Undo/Redo)

```typescript
// Undo/Redo
editor.undo()
editor.redo()

// Mark a point in history
editor.mark('user action description')

// Check if can undo/redo
const canUndo = editor.canUndo()
const canRedo = editor.canRedo()
```

## Page Operations

```typescript
// Get current page
const currentPage = editor.getCurrentPage()
const currentPageId = editor.getCurrentPageId()

// Get all pages
const pages = editor.getPages()
const pageIds = editor.getPageIds()

// Create page
const newPage = editor.createPage({ name: 'Page 2' })

// Delete page
editor.deletePage(pageId)

// Duplicate page
editor.duplicatePage(pageId)

// Set current page
editor.setCurrentPage(pageId)

// Rename page
editor.renamePage(pageId, 'New Name')
```

## Instance State

```typescript
// Get state
const state = editor.getInstanceState()

// Update state
editor.updateInstanceState({
  isToolLocked: true,
  isFocusMode: true,
  openMenus: ['main'],
  isDarkMode: true,
  isGridMode: false,
  isSnapMode: true,
})
```

## User Preferences

```typescript
// Get preferences
const prefs = editor.user.getUserPreferences()

// Update preferences
editor.user.updateUserPreferences({
  animationSpeed: 1,        // 0 = no animation
  enhancedA11yMode: true,   // Visible labels
  areKeyboardShortcutsEnabled: false,
  edgeScrollDelay: 300,
})

// Get animation speed
const speed = editor.user.getAnimationSpeed()
```

## Events

```typescript
// Listen to changes
editor.on('tick', () => { /* animation frame */ })
editor.on('change', (changes) => { /* document changed */ })
editor.on('update-shape', (prev, next) => { /* shape updated */ })
editor.on('create-shape', (shape) => { /* shape created */ })
editor.on('delete-shape', (shape) => { /* shape deleted */ })
editor.on('camera-change', (camera) => { /* camera moved */ })
editor.on('selection-change', (ids) => { /* selection changed */ })

// Remove listener
editor.off('tick', callback)

// Once
editor.once('change', callback)
```

## Input State

```typescript
// Pointer position
const pagePoint = editor.inputs.currentPagePoint
const screenPoint = editor.inputs.currentScreenPoint

// Modifiers
const shiftKey = editor.inputs.shiftKey
const altKey = editor.inputs.altKey
const cmdKey = editor.inputs.cmdKey
const ctrlKey = editor.inputs.ctrlKey

// State
const isDragging = editor.inputs.isDragging
const isPointing = editor.inputs.isPointing

// Raw events
editor.inputs.lastEvent
```

## Utility Methods

```typescript
// Create IDs
const shapeId = createShapeId('my-shape')
const assetId = createAssetId('my-asset')
const pageId = createPageId('my-page')

// Name generation
const name = editor.getUniqueShapeName('Rectangle')

// Bounds helpers
const pageBounds = editor.getPageBounds()
const viewportScreenBounds = editor.getViewportScreenBounds()

// Check conditions
const isEmpty = editor.isDocumentEmpty()
const isDarkMode = editor.getInstanceState().isDarkMode
```

## Side Effects

```typescript
// Register lifecycle hooks
editor.sideEffects.registerBeforeCreateHandler('shape', (shape, source) => {
  if (source === 'user') {
    // Validate or modify
  }
  return shape
})

editor.sideEffects.registerAfterDeleteHandler('shape', (shape, source) => {
  // Cleanup
})
```
