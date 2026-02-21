# Functions & schedule – risks and things that can go wrong

This doc lists what might go wrong **now** or **in the future** so you can prevent or fix issues.

**Already fixed in code:** (1) Schedule screen uses `coParentingCalendar` (typo `coParentingColander` fixed). (2) Shared events list sorts by start time, upcoming first. (3) When there is no default child, daily routine tab shows "Select a default child in profile..." and "Please select child". (4) Routine item onTap left as no-op with TODO until edit flow exists.

---

## 1. Cloud / infra

| Risk | Impact | What to do |
|------|--------|------------|
| **Cloud Tasks queue missing or wrong region** | Scheduled notifications never run (trigger creates task but queue doesn’t exist or is in another region). | Ensure queue `notification-queue` exists in **us-central1** (or the region in `functions/utils/scheduler.js`). |
| **Cloud Tasks service account can’t invoke the function** | Tasks run but HTTP call returns 403; no push. | Grant **Cloud Functions Invoker** to the Cloud Tasks service account (see scheduling setup doc). |
| **sendScheduledNotification is public** | Anyone who knows the URL can POST and trigger fake reminders. | In production, restrict invocation to Cloud Tasks (e.g. “Require authentication” and only grant Invoker to the Tasks service account). |
| **sendNotificationToAll / sendPushNotification are public** | Anyone can spam all users or send to a token. | Protect with auth (e.g. Firebase Admin check or secret header) so only your backend or trusted clients can call them. |

---

## 2. Data and behaviour

| Risk | Impact | What to do |
|------|--------|------------|
| **User has no `fcm_token` or it’s stale** | That user never gets push notifications. | App should refresh and save FCM token on login and when it changes; handle permission denied. |
| **Routine: user’s `children` doesn’t contain the child ref** | Routine reminder is scheduled but no user is found for that child, so no push. | When linking a child to the user, ensure Firestore `users/{uid}.children` includes the child document reference. |
| **Time zones** | User picks “9:00 AM” in local time but backend stores/compares in UTC; reminder at wrong time. | App should store Firestore Timestamp in a consistent way (e.g. user’s local 9 AM converted to UTC, or store in UTC and document it). Today the app sends `Timestamp.fromDate(selectedDateTime)` – ensure `selectedDateTime` matches how you want reminders to fire. |
| **Deleting a routine or event after scheduling** | Task is already in the queue; at run time the doc may be gone. | Current code handles it: sendScheduledNotification checks if child/event exists and skips sending if not. No duplicate push. |
| **Repeated edits to child doc or event** | Multiple tasks for the same time. | We use a fixed task ID per (childId, time) or (eventId, time); duplicate task creation is skipped (ALREADY_EXISTS). |

---

## 3. Schedule screen (Flutter)

| Risk | Impact | What to do |
|------|--------|------------|
| **No default child** | Daily routine tab shows empty; routines aren’t loaded. | Ensure user has a default child set and that the child doc exists; show a clear message if none. |
| **Routine item onTap is empty** | Tapping a routine does nothing. | Optional: navigate to edit/detail (e.g. DailyRoutineScreen with prefilled routine) if you add that flow. |
| **Locale key typo** | `coParentingColander` in code – if the key is “Calendar” in translations, fix the key name. | Check `LocaleKeys.coParentingColander` and translation files; rename key if it’s meant to be “Calendar”. |
| **Shared event list sort** | Events sorted by `createdDate` descending. | If you prefer “by start time” or “upcoming first”, change the sort in ScheduleCubit `_listenToSharedEvent`. |

---

## 4. Future / scale

| Risk | Impact | What to do |
|------|--------|------------|
| **Very large number of users** | sendNotificationToAll loads all users and tokens into memory; could timeout or OOM. | Batch by reading users in chunks (e.g. Firestore pagination) and sending per chunk; or move to a dedicated job queue. |
| **FCM token limit per batch** | We batch to 500; if one batch fails, others still send. | Already handled in sendMulticastBatched. |
| **Firestore trigger retries** | If scheduleTask fails (e.g. queue down), Firestore will retry the trigger; might create duplicate tasks after recovery. | Task ID deduplication limits duplicates; monitor and add idempotency if needed. |
| **Upgrading firebase-functions** | package.json shows an older version; upgrading may introduce breaking changes. | Run tests after `npm install firebase-functions@latest`; fix any API changes (e.g. trigger or HTTP options). |

---

## 5. Quick checklist before release

- [ ] Queue `notification-queue` exists in the correct region.
- [ ] Cloud Tasks service account has **Cloud Functions Invoker**.
- [ ] Optional: sendScheduledNotification (and other HTTP functions) restricted to authenticated callers.
- [ ] App saves FCM token to Firestore and user has `children` (with child ref) for routine reminders.
- [ ] Test: create a routine and a shared event with start time 2–3 minutes ahead; confirm push at that time.
