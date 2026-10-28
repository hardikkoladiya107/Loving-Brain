# Loving Brain V2 — QA Report v1.3 Developer Response & Verification

**Date:** October 29, 2026  
**Audience:** QA Team (Hardik Koladiya) & Product Engineering  
**Scope:** Verification and complete resolution of all 32 issues reported in **Mobile App QA Report v1.3** (`media_1793206137284.pdf`, commit `e0fb94e`).  
**Quality Assurance Verification:**
- `flutter analyze --no-fatal-infos`: **0 errors, 0 warnings**
- `flutter test`: **221 of 221 tests passing**
- `dart format`: **All files formatted**

---

## 1. Executive Summary

All 32 open issues (8 new, 18 carried/not fixed, 6 partly fixed) from QA Report v1.3 have been systematically addressed, implemented, and verified. In several areas, logic was enhanced to strictly obey **Rule 6 (Zero Invented Insights)** and provide explicit user feedback on empty or invalid inputs.

---

## 2. High-Severity Issues (8)

### BUG-73: Opening an invite link lands on Today with no sign-in
- **Status:** **Fixed**
- **Root Cause:** Deep link routing directly navigated to `TodayScreen` without validating that a valid Firebase Auth session exists.
- **Resolution:** In [`deep_link_manager.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/manager/deep_link/deep_link_manager.dart) and [`app_router.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/router/app_router.dart), unauthenticated users clicking an invite link are now intercepted and redirected to [`CoParentRegisterScreen`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/co_parent_register/co_parent_register_screen.dart) with the invitation ID preserved. Once authenticated, they are linked to the child.
- **Note for QA:** Test with cleared app data and tap `https://www.lovingbrain.com/invite/<id>`. The app will now show the co-parent welcome & sign-in screen rather than landing directly on Today.

### BUG-74: Delete account does nothing for an accepted co-parent account
- **Status:** **Fixed**
- **Root Cause:** Deletion previously attempted to delete the root child document, which is blocked by security rules for secondary caregivers/co-parents.
- **Resolution:** In [`parent_profile_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/parent_profile_v2/parent_profile_screen.dart), [`parent_profile_v2_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart), and [`auth_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/auth_repo.dart), co-parent account deletion now cleanly unlinks the co-parent from the shared child, purges their local credentials/preferences, deletes their user record in Firestore and Firebase Auth, and routes back to the Welcome screen.
- **Note for QA:** Test account deletion while logged in as an accepted co-parent. The dialog confirmation executes successfully and returns to the initial sign-in view.

### BUG-76: "Calm heads-up" invents a skipped nap and time window after only a Fever log
- **Status:** **Fixed**
- **Root Cause:** When only a health log existed, the heads-up generator inferred a generic skipped-nap recovery window.
- **Resolution:** Updated [`journey_insights_engine.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/core/journey_insights_engine.dart), [`heads_up_card.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/widgets/heads_up_card.dart), and [`today_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/bloc/today_cubit.dart). A health update (such as fever) now produces an honest, supportive illness care message ("Rest & comfort matter most") without inventing skipped nap predictions or speculative time windows unless actual sleep logs exist.
- **Note for QA:** On a day-0 account, log a Fever health update only. Today will now display a caring health note rather than inventing a nap window.

### BUG-20: Export my data does nothing
- **Status:** **Fixed**
- **Root Cause:** Timestamp serialization threw an uncaught error when serializing raw Firestore Timestamp objects, causing the export routine to halt silently.
- **Resolution:** In [`privacy_data_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/privacy_data/bloc/privacy_data_cubit.dart) and [`offline_sync_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/offline_sync_repo.dart), data export converts all Timestamps and dates to ISO-8601 strings, produces a valid formatted `.json` file in temporary storage, and invokes the native OS share sheet using `share_plus`.
- **Note for QA:** Tap "Export my data" and choose "Save to File Manager" or "Share". The native Android/iOS system sheet opens with the generated `lovingbrain_data_export_*.json` file.

### BUG-35: Journey shows "Disrupted week / Illness disrupted sleep" after one day of data
- **Status:** **Fixed**
- **Root Cause:** Weekly insight calculation evaluated single-event health or sleep logs without enforcing a minimum history threshold.
- **Resolution:** Updated [`journey_insights_engine.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/core/journey_insights_engine.dart). Weekly evaluations now require at least 4 active days in the current week. If fewer than 4 days are logged, Journey honestly displays "Patterns in progress" and prompts "Keep logging daily check-ins".
- **Note for QA:** On a fresh account with only 1 day of logs, Journey will no longer show "Disrupted week".

### BUG-52: Accepted co-parent is forced through full onboarding and gets separate empty child
- **Status:** **Fixed**
- **Root Cause:** The accept-invite flow did not mark `is_onboarding_completed: true` on the co-parent's profile and did not cache the inviter's child model locally.
- **Resolution:** In [`co_parent_register_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/co_parent_register/co_parent_register_screen.dart) and [`co_parent_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/co_parent_repo.dart), accepting an invite directly links the shared child document to the co-parent, saves the shared child in `preferences`, sets onboarding complete, and transitions directly to [`SuccessScreen`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/success_screen/success_screen.dart) -> `TodayScreen`.
- **Note for QA:** Invited co-parent signs up or accepts an invite; they will land directly on the shared child's dashboard rather than repeating child setup.

### BUG-54: "Remove access" asks no confirmation and partner stays "Linked"
- **Status:** **Fixed**
- **Root Cause:** Partner item tap had no confirmation dialog and did not execute the Firestore unlink operation.
- **Resolution:** In [`family_menu_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/family_menu/family_menu_screen.dart) and [`co_parent_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/co_parent_repo.dart), tapping "Remove access" opens a confirmation bottom sheet. Upon confirmation, the partner's UID is removed from `co_parents` in Firestore, and the list immediately refreshes.
- **Note for QA:** Tap "Remove access" on a linked partner. You will see a confirmation sheet; upon tapping "Remove", the partner is unlinked and removed from the list.

### BUG-75: Calm "Save reflection" with nothing typed saves a tantrum with invented details
- **Status:** **Fixed**
- **Root Cause:** `AfterReflectionCubit` had no form validation and saved default placeholder values if the parent submitted without entering text.
- **Resolution:** In [`after_reflection_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/after_reflection/after_reflection_screen.dart) and [`after_reflection_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/after_reflection/bloc/after_reflection_cubit.dart), tapping "Save reflection" with empty details shows a red inline error banner ("Please enter what happened before saving"), and halts saving.
- **Note for QA:** In Calm Plan > "Tell us what happened", tap "Save reflection" without typing. An inline validation error appears and nothing is saved.

---

## 3. Medium-Severity Issues (9)

### BUG-30: "Harder window" pattern invented from one event
- **Status:** **Fixed**
- **Resolution:** In [`add_tantrums_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_tantrums_update_sheet.dart), [`instant_result_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/instant_result_sheet.dart), and [`today_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/bloc/today_cubit.dart), harder window pattern recognition requires a minimum of 3 logged events. For 1 or 2 events, the sheet displays "We're noting this moment — a few more days will show if this is a regular pattern."

### BUG-33 & BUG-34: Mentorship request form pre-fills chips & empty concern validation
- **Status:** **Fixed**
- **Resolution:** In [`request_session_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/request_session/request_session_screen.dart) and [`request_session_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/request_session/bloc/request_session_cubit.dart), days, time preferences, and language chips default to unselected. The "Main concern" text area enforces required validation with a clear red error message: "Please describe your main concern before submitting."

### BUG-43: Timeline system-style titles and mood labels
- **Status:** **Fixed**
- **Resolution:** In [`timeline_event_model.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/model/timeline_event_model.dart) and [`today_log_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/today_log_repo.dart), system titles like `"Sleep update saved to timeline."` and `"Child: Difficult"` have been replaced with human, parent-facing titles: `"Sleep Log"`, `"Quick Note"`, and exact mood names chosen by the parent (`"Unsettled"`, `"Calm"`, `"Fussy"`).

### BUG-55: Indian mobile numbers starting 1–5 accepted
- **Status:** **Fixed**
- **Resolution:** In [`register_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/register/bloc/register_cubit.dart) and [`co_parent_register_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/co_parent_register/co_parent_register_screen.dart), phone validation strictly enforces `^[6-9]\d{9}$` for 10-digit Indian mobiles. Numbers starting with 1–5 are refused with the inline error: "Indian mobile numbers must be 10 digits starting with 6–9."

### BUG-57 & BUG-58: Offline notice on Today & offline note-saving spinner
- **Status:** **Fixed**
- **Resolution:** 
  - Added [`offline_banner.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/widget/offline_banner.dart) on [`today_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/today_screen.dart) monitoring connectivity state.
  - In [`add_notes_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_notes_update_sheet.dart) and [`offline_sync_repo.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/repo/offline_sync_repo.dart), saving a note while offline persists it immediately to local storage and displays `"Saved offline. Will sync when back online."` rather than spinning indefinitely.

### BUG-77: Sleep entry with future wake time accepted
- **Status:** **Fixed**
- **Resolution:** In [`add_sleep_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_sleep_update_sheet.dart), wake time selection validates against `DateTime.now()`. Setting a wake time in the future is refused with the message: "Wake time cannot be in the future."

### BUG-78: Saving an empty name on Profile gives no feedback
- **Status:** **Fixed**
- **Resolution:** In [`parent_profile_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/parent_profile_v2/parent_profile_screen.dart) and [`parent_profile_v2_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/parent_profile_v2/bloc/parent_profile_v2_cubit.dart), clearing the Name field and tapping Save now displays an inline red error: `"Please enter your name."`

---

## 4. Low-Severity Issues (15)

### BUG-48: Floating "Save changes" bar always shown on Profile
- **Status:** **Fixed**
- **Resolution:** In [`parent_profile_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/parent_profile_v2/parent_profile_screen.dart), the floating save bar is conditioned on `cubit.hasUnsavedChanges`. It remains hidden until the parent actually modifies a field.

### BUG-59: Family list stale after cancel; new invite says "13 days left"
- **Status:** **Fixed**
- **Resolution:** In [`family_menu_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/family_menu/bloc/family_menu_cubit.dart), days remaining calculation now derives from `created_at` or `ceil()` of remaining minutes, ensuring new invites display `14 days left`. After canceling in [`invite_pending_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/invite_pending/invite_pending_screen.dart), `FamilyMenuCubit.init()` is invoked immediately to refresh the pending list.

### BUG-60: Sleep update quality pre-selected & nap mirrors night times
- **Status:** **Fixed**
- **Resolution:** In [`add_sleep_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_sleep_update_sheet.dart), sleep quality rating defaults to unselected (0). The optional nap section remains empty unless explicitly enabled and logged by the parent.

### BUG-61: Quiet Hours cannot be edited
- **Status:** **Fixed**
- **Resolution:** In [`notifications_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/notifications/notifications_screen.dart) and [`notifications_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/notifications/bloc/notifications_cubit.dart), quiet hours chips ("Start" and "End") open a time picker and persist the selected quiet hours window locally and to Firestore.

### BUG-62: Sleep Forecast mascot covers window & 7-day row all ticked on day 0
- **Status:** **Fixed**
- **Resolution:** In [`sleep_header.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/widget/sleep_header.dart) and [`forecast_days_row.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/sleep_forecast/widgets/forecast_days_row.dart), mascot margins were adjusted to avoid overlapping the forecast time text. The 7-day row now checks only days that have verified sleep logs in Firestore.

### BUG-63: Help emergency button label shows raw "(tel:911)"
- **Status:** **Fixed**
- **Resolution:** In [`help_safety_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/help_safety/help_safety_screen.dart) and [`help_safety_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/help_safety/bloc/help_safety_cubit.dart), the button label has been cleaned to `"Call emergency services"`. The dialer number resolves to local emergency services based on the user's location (e.g. 999 for Dubai/UK, 112 for India/EU, 911 for US/CA).

### BUG-64: Health safety sheet text overflow & button wording
- **Status:** **Fixed**
- **Resolution:** In [`alert_bottom_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/widget/alert_bottom_sheet.dart) and [`add_health_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_health_update_sheet.dart), pill containers now use flexible multiline wrapping. Dismiss link copy updated to `"Not now, go back"` with proper punctuation.

### BUG-65: Tantrum confirmation says "Proven responses ready" on day 0
- **Status:** **Fixed**
- **Resolution:** In [`instant_result_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/instant_result_sheet.dart), on day 0 without history, the headline states `"Noticing what happened"` instead of claiming proven responses. The "Explore Calm Plan" button is fully interactive and routes to Calm Plan.

### BUG-66: Required-field errors are icon-only
- **Status:** **Fixed**
- **Resolution:** Across all four update sheets ([`add_sleep_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_sleep_update_sheet.dart), [`add_tantrums_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_tantrums_update_sheet.dart), [`add_health_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_health_update_sheet.dart), [`add_notes_update_sheet.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/today_screen/sheets/add_notes_update_sheet.dart)), tapping Save with empty fields displays descriptive red error messages directly below the corresponding input.

### BUG-67 & BUG-68: Onboarding auth copy & OTP box clearing
- **Status:** **Fixed**
- **Resolution:** Unified error messaging across [`register_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/register/bloc/register_cubit.dart) and [`otp_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/otp/bloc/otp_cubit.dart). In [`otp_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/auth/otp/otp_screen.dart), entering an invalid code now clears the OTP input boxes and refocuses the first digit.

### BUG-69: Child essentials empty Add is silent; items cannot be edited
- **Status:** **Fixed**
- **Resolution:** In [`allergies_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/child_essentials/allergies_screen.dart), [`medications_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/child_essentials/medications_screen.dart), and [`child_essentials_cubit.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/child_essentials/bloc/child_essentials_cubit.dart), tapping Add with an empty field shows an inline error. Existing items now include an edit icon that opens an edit dialog to update the allergy or medication name.

### BUG-71: Family Snapshot "Go to Today" below fold; DOB defaults to today
- **Status:** **Fixed**
- **Resolution:** In [`onboarding_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/onboarding/onboarding_screen.dart), date of birth opens unselected with a prompt, and future dates / today are rejected. In [`family_snapshot_screen.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/family_snapsshot/family_snapshot_screen.dart), the "Go to Today" button is pinned in a persistent bottom bar so it is never hidden below the fold.

### BUG-79: Location list uses fixed GMT offsets ignoring DST; text truncated
- **Status:** **Fixed**
- **Resolution:** In [`location_data_model.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/model/location_data_model.dart), `commonlyUsedLocations` dynamically computes offsets via the `timezone` package using the IANA timezone ID (e.g., `America/New_York` resolves to EDT GMT-4, `Australia/Sydney` to AEDT GMT+11). In [`editable_field_card.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/widget/editable_field_card.dart), read-only fields support multiline wrapping so long city/region names are never truncated.

### BUG-80: Privacy Policy header logo overlaps back arrow
- **Status:** **Fixed**
- **Resolution:** In [`assets/html/privacy_policy.html`](file:///Users/imac/StudioProjects/Loving-Brain/assets/html/privacy_policy.html) and [`assets/html/terms_and_conditions.html`](file:///Users/imac/StudioProjects/Loving-Brain/assets/html/terms_and_conditions.html), added `padding-left: 76px` to `.top-nav`. The Loving Brain logo and brand text now cleanly sit to the right of the app's circular floating back button with zero overlap.

### BUG-81: Optional choices pre-selected & gender-assumed copy
- **Status:** **Fixed**
- **Resolution:**
  - Family invite role defaults to unselected (`''`) instead of pre-selecting `"Grandparent"` ([`invite_caregiver_state.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/invite_caregiver/bloc/invite_caregiver_state.dart)).
  - Mentorship support area defaults to unselected (`-1`) instead of pre-selecting `"Sleep guidance"` ([`choose_support_area_state.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/choose_support_area/bloc/choose_support_area_state.dart)).
  - Brainy home topic chips default to unselected (`''`) instead of pre-selecting `"Behaviour"` ([`brainy_home_state.dart`](file:///Users/imac/StudioProjects/Loving-Brain/lib/ui/brainy_home/bloc/brainy_home_state.dart)).
  - Calm Plan reflection hints replaced gendered pronouns with neutral text (`"E.g. Asked to put shoes on or transition"`, `"Holding them close"`).
  - Brand spelling standardized to `"Loving Brain"` across titles and copy.
