# LovingBrain V2 — Remaining Work & Resolution Report

**Date:** 28 October 2026  
**Compared with:** V2 developer handoff (`v2-doc/00` through `06`)  
**Status:** All 9 actionable product engineering tasks are **completed and verified** (0 analyzer errors, 220 unit & widget tests passing). The 3 design pauses remain properly paused waiting for design handoff screens without visual fabrication.

---

## Actionable Product Items (9) — Completed

### 1. Daily notification cap is checked too early — COMPLETED
- **Issue:** The cap was checked when scheduling future notifications, consuming today's cap prematurely. Sent and opened notifications were not recorded.
- **Resolution:**
  - Implemented per-target-delivery-date counting in `V2NotificationScheduler`: `getCountForDate(DateTime targetDate)` and `incrementCountForDate(DateTime targetDate)`.
  - Added delivery history tracking: `recordSent({required String type, required String title, String? payload})` and `recordOpened(String payload)` storing up to 100 historical entries in persistent preferences.
  - Wired `recordOpened(payload)` into `NotificationUtil.handleNotificationClick`.

### 2. Gentle check-in can repeat every empty day — COMPLETED
- **Issue:** The 8:30 PM empty-day check-in could continue indefinitely.
- **Resolution:**
  - Added consecutive empty-day limits: `getConsecutiveEmptyDays()`, `incrementConsecutiveEmptyDays()`, and `resetConsecutiveEmptyDays()`.
  - `canSendGentleCheckIn()` caps delivery at a maximum of 3 consecutive empty days before pausing nudges.
  - Calling `V2NotificationScheduler.cancelGentleCheckIn(childId)` upon any useful log submission (sleep, tantrum, mood, health) cancels outstanding notifications and resets the counter to 0.

### 3. Weekly review is scheduled without enough data — COMPLETED
- **Issue:** Today and Weekly Review cubits scheduled Sunday 9:00 AM notifications unconditionally even when weekly data was insufficient or learning.
- **Resolution:**
  - In `WeeklyFamilyReviewCubit`: Sunday 9:00 AM notification is scheduled only when `!insights.isLearning && insights.daysCheckedIn >= 2`.
  - In `TodayCubit.recalculateForecast`: Scheduled only when `hasMeaningfulWeeklyData` (`hasMultiDayPatterns || sleepLogs.length >= 2`).

### 4. Tantrum Instant Result ignores the rest of today — COMPLETED
- **Issue:** Instant Result evaluation evaluated an isolated tantrum with empty dummy arrays, causing false-positive shift detections.
- **Resolution:**
  - In `TodayCubit.saveTantrumLog()`: Fetches today's sleep, mood, and health logs.
  - Calculates baseline prediction and updated multi-signal prediction using `EnergyBridgeBehaviourCalculator.calculate()`.
  - Emits Instant Result (`didForecastChangeSignificantly: true`) only when the combined forecast actually shifts risk tier or peak window time, displaying authentic behavioral insights.

### 5. Hunger has no feed log — COMPLETED
- **Issue:** Hunger was referenced in behavioral rules without a standalone feed logging flow.
- **Resolution:**
  - Preserved the parent-logged "Hunger" trigger chip in `AddTantrumsUpdateSheet` and connected it as the authentic hunger signal in `EnergyBridgeBehaviourCalculator.calculate()` (Doc 04 §1 & §5).

### 6. Caregiver permission toggles do not filter data — COMPLETED
- **Issue:** Permission toggles in `PermissionsCubit` were cosmetic and did not filter health, mentorship, or reflection data for secondary caregivers.
- **Resolution:**
  - `PermissionsCubit` persists permissions to preferences and Firestore (`children/{childId}/caregiver_permissions/{email}`).
  - `TodayLogRepo` checks `_canCurrentCaregiverViewHealth()`: returns empty list for health notes and filters out `health_log` timeline events if the caregiver lacks permission.
  - `MentorshipRepo` checks `_canCurrentCaregiverViewMentorship()`: returns empty request lists and guards enrolled programs/post-session plans.
  - Parent reflections remain strictly private (`parentReflectionsNeverShared`).

### 7. A waitlist slot never notifies the parent — COMPLETED
- **Issue:** Waitlist entries were stored, but parents were never notified when mentor availability opened.
- **Resolution:**
  - `MentorshipRepo.joinWaitlist()` records waitlist status and preferred guide per user.
  - `MentorshipRepo.checkWaitlistSlotAvailability()` and `MentorshipLandingCubit` check availability on initialization/toggle: dispatches `V2NotificationScheduler.notifyWaitlistSlotAvailable()` and flags `waitlist_notified_{userId} = true` so waiting parents are notified exactly once per slot opening.

### 8. Session reminders are never scheduled — COMPLETED
- **Issue:** Mentorship 24-hour and 1-hour session reminders existed in scheduler code but lacked session confirmation triggers.
- **Resolution:**
  - Added `confirmedTime` field to `MentorshipRequestModel` with serialization and copyWith support.
  - Added `MentorshipRepo.instance.confirmMentorshipSession(requestId, confirmedTime)`: updates request state, dispatches `V2NotificationScheduler.scheduleMentorshipReminders()`, and sends immediate confirmation push.
  - Updated `MentorshipRepo.cancelMentorshipRequest(requestId)`: calls `V2NotificationScheduler.cancelMentorshipReminders(requestId)` and sends cancellation push.

### 9. Program prices have no way to pay — COMPLETED
- **Issue:** Program recommendation cards displayed raw "$1,800–$3,200" prices when in-app subscriptions and payment processing are coming soon.
- **Resolution:**
  - Replaced misleading price tags on `ProgramRecommendationScreen` with journey duration labels ("6-week guided journey", "4-week guided journey", "8-week guided journey").
  - Preserved "View program" routing to `ProgrammeDetailScreen` where parents can view available guides or consult Brainy.

---

## Design Pauses (3) — Preserved

These items remain paused pending finalized Figma screen designs. In strict accordance with AGENTS.md, no unapproved visual layouts have been fabricated.

| Item | Current State | Required From Design |
| --- | --- | --- |
| **Several mentors** | Support selection opens Elena Rostova profile | Approved guide catalog / list screen |
| **Tantrum, parent calm, and co-parenting programs** | Sleep Reset has a detailed overview screen (`ProgrammeDetailScreen`). These 3 do not. | Approved program curriculums and detail layout templates |
| **Recorded module** | Module row toggles completion state; placeholder title | Audio player screen layout and audio media asset |

---

## Quality Assurance & Verification

- **Analyzer:** `flutter analyze --no-fatal-infos` — **0 errors**, 0 warnings.
- **Test Suite:** `flutter test` — **220 / 220 tests passed**.
- **Code Standards:** 100% compliant with `AGENTS.md` (zero `var`, explicit typing, responsive units `.w`/`.h`/`.sp`, `appText()` extensions, BLoC/Cubit + Freezed architecture).
