# Camera Reference

The camera system controls viewport position, zoom level, and coordinate transformations between screen and canvas space.

## Camera Options

```typescript
editor.setCameraOptions({
  isLocked: false,        // Prevent all camera movement
  wheelBehavior: 'pan',   // 'pan' | 'zoom' | 'none'
  panSpeed: 1,            // Pan sensitivity
  zoomSpeed: 1,           // Zoom sensitivity
  zoomSteps: [0.1, 0.25, 0.5, 1, 2, 4, 8],  // Discrete zoom levels
  constraints: {          // Optional bounds
    bounds: { x: 0, y: 0, w: 1920, h: 1080 },
    padding: { x: 50, y: 50 },
    origin: { x: 0.5, y: 0.5 },
    initialZoom: 'fit-min',
    baseZoom: 'default',
    behavior: 'inside',
  },
})
```

## Camera Constraints

### Constraint Behaviors

| Behavior | Description |
|----------|-------------|
| `'free'` | No constraints, unlimited panning |
| `'fixed'` | Bounds stay at origin regardless of pan |
| `'inside'` | Bounds must stay completely within viewport |
| `'outside'` | Bounds must stay touching viewport edges |
| `'contain'` | `'fixed'` when zoomed out, `'inside'` when zoomed in |

### Per-Axis Constraints

```typescript
editor.setCameraOptions({
  constraints: {
    bounds: { x: 0, y: 0, w: 1920, h: 1080 },
    behavior: {
      x: 'free',    // Horizontal unrestricted
      y: 'inside',  // Vertical keeps bounds visible
    },
  },
})
```

### Zoom Fitting Options

| Value | Description |
|-------|-------------|
| `'default'` | 100% zoom |
| `'fit-min'` | Fit smaller axis (all content visible) |
| `'fit-max'` | Fit larger axis (may crop) |
| `'fit-x'` | Fit horizontally |
| `'fit-y'` | Fit vertically |
| `'fit-x-100'` | Fit horizontally or 100%, whichever smaller |
| `'fit-y-100'` | Fit vertically or 100%, whichever smaller |
| `'fit-min-100'` | Fit smaller axis or 100%, whichever smaller |

## Camera Methods

### Basic Navigation

```typescript
// Move to position
editor.setCamera({ x: -500, y: -300, z: 1.5 })

// Center on point
editor.centerOnPoint({ x: 1000, y: 500 })

// Zoom controls
editor.zoomIn()
editor.zoomOut()
editor.zoomIn(screenPoint, { animation: { duration: 200 } })

// Reset to 100% (or initial zoom if constrained)
editor.resetZoom()
```

### Zoom to Content

```typescript
// Fit all shapes on current page
editor.zoomToFit({ animation: { duration: 200 } })

// Fit current selection
editor.zoomToSelection()

// Fit specific bounds with padding
const bounds = { x: 0, y: 0, w: 1000, h: 800 }
editor.zoomToBounds(bounds, { 
  inset: 100,           // Padding in pixels
  targetZoom: 1,        // Max zoom level
  animation: { duration: 500 },
})
```

### Animated Movement

```typescript
import { EASINGS } from 'tldraw'

// Set camera with animation
editor.setCamera(
  { x: 0, y: 0, z: 1 },
  {
    animation: {
      duration: 500,
      easing: EASINGS.easeInOutCubic,
    },
    immediate: false,  // Run on next tick (default)
    force: false,      // Move even if isLocked
  }
)

// EASINGS available:
// EASINGS.linear, EASINGS.easeInQuad, EASINGS.easeOutQuad, EASINGS.easeInOutQuad
// EASINGS.easeInCubic, EASINGS.easeOutCubic, EASINGS.easeInOutCubic
// EASINGS.easeInQuart, EASINGS.easeOutQuart, EASINGS.easeInOutQuart
// EASINGS.easeInQuint, EASINGS.easeOutQuint, EASINGS.easeInOutQuint
// EASINGS.easeInSine, EASINGS.easeOutSine, EASINGS.easeInOutSine
// EASINGS.easeInExpo, EASINGS.easeOutExpo, EASINGS.easeInOutExpo
```

### Momentum Scrolling

```typescript
editor.slideCamera({
  speed: 2,                  // Initial velocity
  direction: { x: 1, y: 0 }, // Direction vector
  friction: 0.1,             // Deceleration (higher = stops faster)
  speedThreshold: 0.01,      // Stop when below this speed
})
```

### Stop Animation

```typescript
editor.stopCameraAnimation()
```

## Coordinate Conversions

```typescript
// Screen (viewport) to Page (canvas)
const pagePoint = editor.screenToPage({ x: event.clientX, y: event.clientY })

// Page to Screen
const screenPoint = editor.pageToScreen({ x: shape.x, y: shape.y })

// Page to Shape-local
const localPoint = editor.getPointInShapeSpace(shape, pagePoint)
```

## Camera State

```typescript
// Get current camera
const camera = editor.getCamera()
// { x: number, y: number, z: number }

// Get camera options
const options = editor.getCameraOptions()

// Check if locked
const isLocked = editor.getCameraOptions().isLocked
```

## Quick Zoom Tool

Default UI includes quick zoom (press `z`):
- Zooms out to show entire canvas
- Viewport brush shows target area
- Move cursor to reposition, release to zoom
- Escape to cancel

## User Preferences

```typescript
// Check animation speed preference
const speed = editor.user.getAnimationSpeed()
if (speed === 0) {
  // User prefers no animation (reduced motion)
  editor.setCamera({ x: 0, y: 0, z: 1 }, { immediate: true })
} else {
  editor.setCamera({ x: 0, y: 0, z: 1 }, { 
    animation: { duration: 320 * (1 / speed) }
  })
}
```

## Common Patterns

### Lock Camera Zoom

```typescript
editor.setCameraOptions({
  isLocked: true,  // Prevent all movement
})

// Or just lock zoom
editor.setCameraOptions({
  zoomSteps: [1],  // Single zoom level
})
```

### Slideshow Camera

```typescript
// Fixed viewport for presentations
editor.setCameraOptions({
  constraints: {
    bounds: { x: 0, y: 0, w: 1920, h: 1080 },
    behavior: 'fixed',
    initialZoom: 'fit-min',
  },
  wheelBehavior: 'none',
})

// Navigate between slides
function goToSlide(index: number) {
  const slideBounds = slides[index].bounds
  editor.zoomToBounds(slideBounds, { animation: { duration: 300 } })
}
```

### Image Annotator Camera

```typescript
// Fixed image bounds with zoom for detail work
editor.setCameraOptions({
  constraints: {
    bounds: imageBounds,
    behavior: 'contain',
    initialZoom: 'fit-min',
  },
  wheelBehavior: 'zoom',  // Trackpad zoom for detail
})
```

## Examples

- [Camera options](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/configuration/camera-options) - Constraints, zoom behavior, pan speed
- [Image annotator](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/use-cases/image-annotator) - Fixed viewport for annotation
- [Slideshow](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/use-cases/slideshow) - Fixed camera with slide navigation
- [Lock camera zoom](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/lock-camera-zoom) - Lock at specific zoom
- [Zoom to bounds](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/zoom-to-bounds) - Programmatic zoom
- [Scrollable container](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/layout/scroll) - Editor in scrollable container
