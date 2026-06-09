# Assets Reference

Assets are external resources (images, videos, bookmarks) referenced by shapes. Asset records store metadata; the actual files live in your storage backend.

## TLAssetStore Interface

```typescript
interface TLAssetStore {
  upload(asset: TLAsset, file: File, abortSignal?: AbortSignal): Promise<{ src: string; meta?: JsonObject }>
  resolve(asset: TLAsset, ctx: TLAssetContext): Promise<string | null> | string | null
  remove?(assetIds: TLAssetId[]): Promise<void>
}
```

## Asset Record Structure

```typescript
// Image asset
const imageAsset: TLImageAsset = {
  id: 'asset:image123' as TLAssetId,
  typeName: 'asset',
  type: 'image',
  props: {
    w: 1920,
    h: 1080,
    name: 'photo.jpg',
    isAnimated: false,
    mimeType: 'image/jpeg',
    src: 'https://storage.example.com/uploads/photo.jpg',
    fileSize: 245000,
  },
  meta: {},
}

// Video asset
const videoAsset: TLVideoAsset = {
  id: 'asset:video456' as TLAssetId,
  type: 'video',
  props: {
    w: 1920, h: 1080,
    name: 'clip.mp4',
    isAnimated: true,
    mimeType: 'video/mp4',
    src: 'https://storage.example.com/uploads/clip.mp4',
    fileSize: 5242880,
  },
}

// Bookmark asset
const bookmarkAsset: TLBookmarkAsset = {
  id: 'asset:bookmark1' as TLAssetId,
  type: 'bookmark',
  props: {
    title: 'Example Website',
    description: 'A great example',
    image: 'https://example.com/preview.jpg',
    favicon: 'https://example.com/favicon.ico',
    src: 'https://example.com',
  },
}
```

## TLAssetContext

```typescript
interface TLAssetContext {
  screenScale: number        // Asset scale relative to native (0.5 = 50%)
  steppedScreenScale: number // Rounded to nearest power of 2
  dpr: number                // Device pixel ratio (2-3 for retina)
  networkEffectiveType: 'slow-2g' | '2g' | '3g' | '4g' | null
  shouldResolveToOriginal: boolean // True for export/copy-paste
}
```

## Implementing TLAssetStore

### S3 Upload

```typescript
const assetStore: TLAssetStore = {
  async upload(asset, file, abortSignal) {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('assetId', asset.id)
    formData.append('type', asset.type)
    
    const response = await fetch('/api/upload', {
      method: 'POST',
      body: formData,
      signal: abortSignal,
    })
    
    const { url, uploadedAt } = await response.json()
    return {
      src: url,
      meta: { uploadedAt },
    }
  },
  
  resolve(asset, ctx) {
    if (!asset.props.src) return null
    
    // For exports, return original quality
    if (ctx.shouldResolveToOriginal) {
      return asset.props.src
    }
    
    // Serve optimized size based on zoom level
    const targetWidth = Math.ceil(asset.props.w * ctx.steppedScreenScale * ctx.dpr)
    return `${asset.props.src}?w=${targetWidth}`
  },
  
  async remove(assetIds) {
    await fetch('/api/assets', {
      method: 'DELETE',
      body: JSON.stringify({ ids: assetIds }),
    })
  },
}
```

### Data URL (Prototyping Only)

```typescript
const assetStore: TLAssetStore = {
  async upload(asset, file) {
    const dataUrl = await new Promise<string>((resolve) => {
      const reader = new FileReader()
      reader.onload = () => resolve(reader.result as string)
      reader.readAsDataURL(file)
    })
    return { src: dataUrl }
  },
  
  resolve(asset) {
    return asset.props.src
  },
}
```

### Authenticated Assets

```typescript
const assetStore: TLAssetStore = {
  async upload(asset, file) {
    const token = getAuthToken()
    const formData = new FormData()
    formData.append('file', file)
    
    const response = await fetch('/api/upload', {
      method: 'POST',
      body: formData,
      headers: { Authorization: `Bearer ${token}` },
    })
    
    const { url } = await response.json()
    return { src: url }
  },
  
  resolve(asset, ctx) {
    const token = getAuthToken()
    // Add auth token and expire time
    return `${asset.props.src}?token=${token}&expires=${Date.now() + 3600000}`
  },
}
```

### Network-Adaptive Resolution

```typescript
resolve(asset, ctx) {
  const baseUrl = asset.props.src
  if (!baseUrl) return null
  
  if (ctx.shouldResolveToOriginal) {
    return baseUrl
  }
  
  // Slow connection: lower quality
  if (ctx.networkEffectiveType === 'slow-2g' || ctx.networkEffectiveType === '2g') {
    return `${baseUrl}?quality=low`
  }
  
  // Fast connection, zoomed in: high resolution
  if (ctx.steppedScreenScale >= 1 && ctx.dpr >= 2) {
    return `${baseUrl}?quality=high&w=${asset.props.w}`
  }
  
  // Default: moderate quality
  const targetWidth = Math.ceil(asset.props.w * ctx.steppedScreenScale)
  return `${baseUrl}?w=${targetWidth}`
}
```

## Editor Asset Methods

```typescript
// Create assets (outside undo/redo)
editor.createAssets([imageAsset])
editor.createAssets([videoAsset, bookmarkAsset])

// Update assets
editor.updateAssets([{ 
  id: assetId, 
  type: 'image', 
  props: { name: 'new-name.jpg' } 
}])

// Get assets
const asset = editor.getAsset<TLImageAsset>(assetId)
const allAssets = editor.getAssets()

// Delete assets (calls remove handler)
editor.deleteAssets([assetId])

// Resolve URL for rendering
const url = await editor.resolveAssetUrl(assetId, { 
  screenScale: 0.5,
  dpr: 2,
})
```

## Asset Types

### Image Assets

```typescript
// Create image shape from asset
editor.createShape({
  type: 'image',
  x: 100, y: 100,
  props: {
    w: 800, h: 600,
    assetId: imageAsset.id,
    crop: { x: 0, y: 0, w: 1, h: 1 },
  },
})

// Update image alt text (accessibility)
editor.updateShape({
  id: imageShape.id,
  props: { altText: 'A diagram showing system architecture' },
})
```

### Video Assets

```typescript
editor.createShape({
  type: 'video',
  x: 100, y: 100,
  props: {
    w: 640, h: 480,
    assetId: videoAsset.id,
    time: 0,  // Current playback time
  },
})
```

### Bookmark Assets

```typescript
// Create bookmark from URL
editor.createShape({
  type: 'bookmark',
  x: 100, y: 100,
  props: {
    assetId: bookmarkAsset.id,
  },
})

// Helper for creating from URL
const { shape, asset } = editor.createBookmarkFromUrl('https://example.com')
```

## Asset Props Configuration

```tsx
import { Tldraw } from 'tldraw'

function App() {
  return (
    <Tldraw 
      assets={assetStore}
      assetTypes={{
        image: {
          maxWidth: 4096,
          maxHeight: 4096,
          maxFileSize: 10 * 1024 * 1024,  // 10MB
        },
        video: {
          maxWidth: 1920,
          maxHeight: 1080,
          maxFileSize: 100 * 1024 * 1024,  // 100MB
        },
      }}
    />
  )
}
```

## Persistence Options

### IndexedDB (Browser Storage)

```tsx
<Tldraw 
  persistenceKey="my-app-assets"
  assets={assetStore}
/>
```

### Memory Only (No Persistence)

```tsx
<Tldraw assets={inlineBase64AssetStore} />
```

## Shape-Asset Relationship

```typescript
// Shape references asset
const imageShape = {
  id: 'shape1',
  type: 'image',
  props: {
    w: 800, h: 600,
    assetId: 'asset:image123',  // Reference
  },
}

// Multiple shapes can reference same asset
const anotherShape = {
  id: 'shape2',
  type: 'image',
  props: {
    w: 400, h: 300,
    assetId: 'asset:image123',  // Same asset
  },
}

// Delete shape doesn't delete asset (other shapes may use it)
editor.deleteShape('shape1')

// Delete asset removes from storage (if no shapes reference it)
editor.deleteAssets(['asset:image123'])
```

## Examples

- [Hosted images](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/data/assets/hosted-images)
- [Local images](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/local-images)
- [Local videos](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/editor-api/local-videos)
- [Asset options](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/configuration/asset-props)
- [Static assets](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/data/assets/static-assets)
