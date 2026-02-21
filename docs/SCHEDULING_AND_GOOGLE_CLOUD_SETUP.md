# Scheduling (Daily Routine & Co‑parenting) and Google Cloud Setup

## Summary: Is Scheduling Working?

- **Daily routine**: The app saves routines to Firestore (`children/{childId}` with `routines` array). A Firestore trigger `onRoutineWrite` runs on every write and schedules a Cloud Task for each **future** routine time. The task calls `sendScheduledNotification`, which sends a push to users linked to that child. Flow is correct; it will work once Google Cloud is configured below.
- **Co‑parenting schedule**: Shared events are stored in `shared_event/{eventId}` with `start_time`. A Firestore trigger `onSharedEventWrite` runs on create/update and schedules one Cloud Task at `start_time`. The worker notifies creator and assigned users. Flow is correct.

## What You Must Set Up in Google Cloud Console

### 1. Enable APIs

1. Open [Google Cloud Console](https://console.cloud.google.com/) and select your Firebase project.
2. Enable:
   - **Cloud Tasks API**: [APIs & Services → Library](https://console.cloud.google.com/apis/library) → search “Cloud Tasks API” → Enable.
   - **Cloud Functions API** (usually already enabled for Firebase).

### 2. Create the Cloud Tasks queue

Scheduled notifications use a queue named **`notification-queue`** in the same region as your functions.

1. Go to [Cloud Tasks](https://console.cloud.google.com/cloudtasks).
2. Click **Create Queue**.
3. Set:
   - **Name**: `notification-queue`
   - **Region**: Same as your Firebase Functions (e.g. **us-central1**).  
     Your code uses `LOCATION = "us-central1"` in `functions/utils/scheduler.js`. To use another region, change it there only.
4. Leave other settings default (or tune retries/rate limits if needed).
5. Create the queue.

### 3. Permissions for Cloud Tasks to invoke the function

The Cloud Tasks service account must be allowed to call your HTTP function.

1. Go to [IAM & Admin → IAM](https://console.cloud.google.com/iam-admin/iam).
2. Find the **Cloud Tasks service account** (e.g. `PROJECT_NUMBER-compute@developer.gserviceaccount.com`) or the **default compute service account** used by your project.
3. Ensure that account has one of:
   - **Cloud Functions Invoker** (recommended), or  
   - A custom role that includes `cloudfunctions.functions.invoke`.
4. If your HTTP function is deployed with “Allow unauthenticated” (public), invocation will work without this, but it’s **safer to require authentication** and grant **Cloud Functions Invoker** only to the Cloud Tasks service account.

### 4. Firebase / Functions deployment

1. Deploy your functions (including `onRoutineWrite`, `onSharedEventWrite`, and `sendScheduledNotification`):
   ```bash
   cd functions && npm install && firebase deploy --only functions
   ```
2. Confirm in [Firebase Console → Functions](https://console.firebase.google.com/project/_/functions) that:
   - `sendScheduledNotification` is deployed.
   - Region matches the one used in your trigger code (e.g. `us-central1`).

### 5. Optional: Different region

If your functions run in a region other than `us-central1`:

- Create the Cloud Tasks queue in **that same region**.
- In `functions/triggers/routineTriggers.js` and `functions/triggers/eventTriggers.js`, set `LOCATION` to that region (e.g. `asia-south1`).

---

## Code Fixes Applied in This Project

1. **`lib/model/shared_event_model.dart`**  
   - **Bug**: `toJson()` set `map['documents'] = _createdDate`, overwriting `documents` and never setting `created_date`.  
   - **Fix**: Set `map['created_date'] = _createdDate` and keep `map['documents'] = _documents`.

2. **`lib/ui/daily_routine/bloc/daily_routine_cubit.dart`**  
   - **Bug**: `changeProps()` used `getRoutineTypeApiResult ?? ApiResultStatus.initial()`, so any update without that param reset the status and could cause flicker or lost state.  
   - **Fix**: Use `getRoutineTypeApiResult ?? state.getRoutineTypeApiResult` so status is preserved when not explicitly updated.

3. **Duplicate scheduled notifications (Functions)**  
   - **Issue**: Every time a child document or shared event was written, the trigger scheduled a task for every future routine/event. Adding a second routine caused the first to be scheduled again → duplicate notifications.  
   - **Fix**: Added an optional **task ID** to the scheduler. Routine tasks use `rout_{childId}_{scheduleTimeSeconds}` and shared-event tasks use `evt_{eventId}_{scheduleTimeSeconds}`. If a task with that ID already exists, the create is skipped (idempotent), avoiding duplicate notifications.

---

## Production readiness

The functions code is set up for production with:

- **Input validation**: `sendScheduledNotification` checks `type`, `childId`/`docId` and returns 400 for bad or missing data; unknown `type` returns 400.
- **FCM batching**: Notifications are sent in batches of 500 tokens (FCM limit) so large user sets don’t fail.
- **Safe handling of data**: Falsy `created_by`/`assigned_to` and empty/invalid FCM tokens are filtered out before use.

**You should still:**

- **Secure HTTP endpoints**: In production, restrict who can call your functions:
  - **sendScheduledNotification**: Allow only Cloud Tasks (e.g. require OIDC token from the Cloud Tasks service account, or deploy with “Require authentication” and grant **Cloud Functions Invoker** only to that account). Otherwise anyone who knows the URL could trigger fake notifications.
  - **sendNotificationToAll** and **sendPushNotification**: Require authentication (e.g. Firebase Admin, or a secret header) so only your backend or trusted clients can send notifications.
- **Monitor and test**: After deploy, test with a real routine and shared event; check Cloud Tasks and function logs for errors.

---

## Quick Checklist

- [ ] Cloud Tasks API enabled.
- [ ] Queue **`notification-queue`** created in the **same region** as your functions (e.g. `us-central1`).
- [ ] Cloud Tasks (or compute) service account has **Cloud Functions Invoker** (or equivalent) so it can call `sendScheduledNotification`.
- [ ] Functions deployed; `sendScheduledNotification` exists and region matches trigger config.
- [ ] App: users have FCM tokens and (for routines) `users` documents have `children` array containing the child reference(s).

After this, daily routine and co‑parenting scheduled notifications should work as intended.
