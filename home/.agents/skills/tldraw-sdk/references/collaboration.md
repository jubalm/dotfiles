# Collaboration Reference

Multiplayer sync for real-time collaborative editing with tldraw.

## TLSocketRoom

The core synchronization primitive for multiplayer collaboration.

```typescript
import { TLSocketRoom } from '@tldraw/sync'
import { createTLStore } from '@tldraw/tldraw'

// Server-side
const room = new TLSocketRoom({
  schema: createTLStore().schema,
  snapshot: undefined,  // Optional initial snapshot
})

// Handle WebSocket connections
wss.on('connection', (ws) => {
  room.handleSocketConnect(ws)
  
  ws.on('message', (data) => {
    room.handleSocketMessage(ws, JSON.parse(data))
  })
  
  ws.on('close', () => {
    room.handleSocketClose(ws)
  })
})
```

## Client-Side Setup

```typescript
import { Tldraw, useEditor } from 'tldraw'
import { useFileSystem } from 'tldraw/useFileSystem'
import { TlsyncClient } from '@tldraw/sync'

function MultiplayerEditor() {
  const editor = useEditor()
  
  useEffect(() => {
    const syncClient = new TlsyncClient({
      editor,
      url: `ws://localhost:3000/room/${roomId}`,
      // Custom WebSocket implementation if needed
      WebSocket: WebSocket,
    })
    
    return () => syncClient.disconnect()
  }, [editor, roomId])
  
  return <Tldraw editor={editor} />
}
```

## Presence System

### User Presence

```typescript
// Update user presence
editor.user.updatePresence({
  cursor: { x: 100, y: 200 },
  followingUserId: null,
  chatMessage: null,
  // Custom fields
  metadata: { name: 'John', color: '#FF0000' },
})

// Get other users' presence
const presence = editor.user.getPresence(userId)
```

### Custom Presence Data

```typescript
// Define custom presence schema
interface MyPresence {
  cursor: { x: number; y: number }
  followingUserId: string | null
  selection: TLShapeId[]
  metadata: { name: string; avatar?: string }
}

// Update presence with selection
editor.user.updatePresence({
  selection: editor.getSelectedShapeIds(),
})
```

### Following Users

```typescript
// Start following another user
editor.user.updatePresence({
  followingUserId: targetUserId,
})

// Stop following
editor.user.updatePresence({
  followingUserId: null,
})

// Check if following someone
const followingId = editor.user.getPresence().followingUserId
```

## Custom Messages

Send custom messages between clients:

```typescript
// Server: Send custom message to specific client
room.sendCustomMessage(socketId, {
  type: 'chat',
  from: userId,
  message: 'Hello!',
})

// Server: Broadcast to all
room.broadcastCustomMessage({
  type: 'notification',
  title: 'Document updated',
})

// Client: Listen for custom messages
syncClient.onCustomMessage((message) => {
  if (message.type === 'chat') {
    addChatMessage(message)
  }
})
```

## Snapshot Management

### Get Snapshot

```typescript
// Server: Get current room snapshot
const snapshot = room.getSnapshot()

// Send to new client joining
ws.send(JSON.stringify({
  type: 'snapshot',
  data: snapshot,
}))
```

### Load Snapshot

```typescript
// Client: Load initial snapshot
const room = new TLSocketRoom({
  schema: createTLStore().schema,
  snapshot: initialSnapshot,
})
```

### Persist Snapshots

```typescript
// Periodic snapshot saving
setInterval(async () => {
  const snapshot = room.getSnapshot()
  await saveToDatabase(roomId, snapshot)
}, 30000)  // Every 30 seconds

// Save on room empty
room.on('empty', async () => {
  const snapshot = room.getSnapshot()
  await saveToDatabase(roomId, snapshot)
})
```

## Private Content

```typescript
// Shape with private visibility
const shape = {
  ...baseShape,
  meta: {
    visibility: 'private',
    ownerId: userId,
  },
}

// Filter shapes before sync
const room = new TLSocketRoom({
  schema: createTLStore().schema,
  // Custom shape filtering
  shouldSyncShape: (shape) => {
    if (shape.meta?.visibility === 'private') {
      return shape.meta.ownerId === currentUserId
    }
    return true
  },
})
```

## User Cursors

```typescript
// Remote cursors are automatically shown when users move
// Customize cursor appearance per user

// Set custom cursor for remote user
room.setClientPresence(socketId, {
  cursor: {
    type: 'default',
    color: '#FF0000',  // User's color
  },
})
```

## Room Lifecycle

```typescript
// Server: Create room
const room = new TLSocketRoom({
  schema: createTLStore().schema,
  snapshot: loadSnapshot(roomId),
})

// Events
room.on('connect', (socketId) => {
  console.log('Client connected:', socketId)
})

room.on('disconnect', (socketId) => {
  console.log('Client disconnected:', socketId)
})

room.on('empty', () => {
  // All clients left, save and cleanup
  console.log('Room is empty')
})

room.on('change', (changes) => {
  // Document changed
  console.log('Document changed:', changes)
})

// Server: Destroy room
room.destroy()
```

## Scaling Considerations

### Multiple Rooms

```typescript
const rooms = new Map<string, TLSocketRoom>()

function getRoom(roomId: string): TLSocketRoom {
  if (!rooms.has(roomId)) {
    rooms.set(roomId, new TLSocketRoom({
      schema: createTLStore().schema,
      snapshot: loadSnapshot(roomId),
    }))
  }
  return rooms.get(roomId)!
}
```

### Load Balancing

For high-scale deployments, consider:
- Redis Pub/Sub for cross-instance sync
- Sharding rooms across instances
- Sticky sessions for WebSocket connections

## Permissions

```typescript
// Server: Check permissions before applying changes
const room = new TLSocketRoom({
  schema: createTLStore().schema,
  onBeforeShapeCreate: (shape, userId) => {
    if (!canCreateShape(userId, shape)) {
      return false  // Reject creation
    }
    return shape
  },
  onBeforeShapeUpdate: (prev, next, userId) => {
    if (!canUpdateShape(userId, next)) {
      return prev  // Keep old version
    }
    return next
  },
  onBeforeShapeDelete: (shape, userId) => {
    return canDeleteShape(userId, shape)
  },
})
```

## Examples

- [Multiplayer sync](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/sync/multiplayer)
- [Multiplayer with custom presence](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/sync/multiplayer-custom-presence)
- [Multiplayer with private content](https://github.com/tldraw/tldraw/tree/main/apps/examples/src/examples/sync/multiplayer-private-content)

## Starter Kits

- **[multiplayer](https://tldraw.dev/starter-kits/multiplayer)** - Collaborative whiteboard foundation built on tldraw sync
