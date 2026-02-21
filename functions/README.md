# Cloud Functions – Structure

This folder contains Firebase Cloud Functions for the Loving Brain app.

## Layout

```
functions/
├── index.js                 # Entry point; exports all functions
├── config/
│   └── constants.js        # Notification copy, FCM limit, etc.
├── controllers/
│   └── notificationController.js   # HTTP handlers: scheduled + broadcast + single push
├── triggers/
│   ├── routineTriggers.js  # Firestore: children/{childId} → schedule routine reminders
│   └── eventTriggers.js    # Firestore: shared_event/{eventId} → schedule event reminders
├── utils/
│   └── scheduler.js        # Cloud Tasks: create scheduled task, config, dedupe
├── notification.js         # FCM helpers: send to one or many tokens
└── package.json
```

## Flow (scheduling)

1. **User adds a routine or shared event** in the app → data is written to Firestore.
2. **Firestore trigger** (`onRoutineWrite` or `onSharedEventWrite`) runs.
3. Trigger calls **scheduler**: creates a **Cloud Task** at the reminder time.
4. At that time **Cloud Tasks** sends a POST to **sendScheduledNotification**.
5. **sendScheduledNotification** loads users/tokens and sends the **push** via **notification.js**.

## Deployed functions

| Function | Type | Purpose |
|----------|------|--------|
| `sendScheduledNotification` | HTTP | Called by Cloud Tasks to send routine/event reminders. |
| `onRoutineWrite` | Firestore (children) | Schedules a task per future routine time. |
| `onSharedEventWrite` | Firestore (shared_event) | Schedules one task at event start time. |
| `sendNotificationToAll` | HTTP | Sends a streak-style message to all users. |
| `sendPushNotification` | HTTP | Sends one notification to a given token. |

## Config

- **Queue**: Cloud Tasks queue name and region are in `utils/scheduler.js` (`LOCATION`, `QUEUE_NAME`). Change there if you use another region.
- **Notification text**: Default titles/bodies are in `config/constants.js`. The controller may override with event title or routine description when available.
