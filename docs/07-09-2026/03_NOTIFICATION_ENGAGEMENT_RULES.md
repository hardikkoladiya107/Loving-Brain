# LOVINGBRAIN — Notification & Engagement Rules

**When LovingBrain May Contact a Parent, How Often, and Where Each Notification Should Lead**
**Developer Handoff for Hardik | Based on Deepak's Final 74-Screen UI**

---

## Core Rule

> Notifications should reduce decision fatigue, not create pressure. LovingBrain should send fewer, more useful nudges. No broken-streak messages, guilt, or repeated prompts for missing logs.

---

## 1. Global Notification Rules

- **Maximum normal push notifications:** 3 per day. Most days should be 0–2.
- Only one notification for the same reason within the same relevant window.
- **Quiet hours default:** 9:00 PM–7:00 AM local time, except a user-booked mentorship update or user-defined sleep reminder that falls inside that period.
- If the parent has already completed the intended action, cancel the pending reminder.
- If notifications are denied, the app continues normally; show the information inside Today instead.
- Never notify because the parent missed a streak or failed to log.
- Safety/medical content should not be pushed as an automated diagnosis. Safety escalation happens when the user is actively in Brainy or enters concerning information.

---

## 2. Notification Types

| Notification | Trigger | Frequency Cap | Timing | Tap Opens | Example Copy |
|-------------|---------|---------------|--------|-----------|-------------|
| **Sleep window approaching** | Predicted wind-down window is approaching and confidence is at least moderate. | 1 per main sleep window | 20–30 min before wind-down | Today → Tonight's Plan | "Wind-down may start around 7:20 PM tonight." |
| **Sleep estimate changed** | A new sleep log materially changes tonight's plan (e.g. ~15+ min). | Max 1 after a meaningful update | Immediately after recalculation | Updated Sleep Plan | "Today's nap was shorter, so bedtime may shift a little earlier." |
| **Calm Heads-Up** | Combined recent signals suggest a harder window may be more likely. | Max 1 per risk window; max 2/day | 30–60 min before the window | Calm Heads-Up → Calm Plan | "A harder window may be more likely around 5:30–7 PM. Here's what may help." |
| **Gentle check-in** | No useful data has been logged and one update would improve today's guidance. | Max 1/day; do not send daily forever | User-selected time or ~8:30 PM | Quick Update sheet | "One quick update can help us understand today better." |
| **Weekly review ready** | Enough data exists to make a useful weekly summary. | 1/week | Sunday or user-local equivalent | Journey → Weekly Review | "Your weekly review is ready: one change, one pattern, one focus." |
| **Mentorship booking** | Mentor/session request is confirmed, changed, or cancelled. | Event-driven only | Immediately | Mentorship request/session detail | "Your session with Priya is confirmed." |
| **Mentorship reminder** | Confirmed session is approaching. | Up to 2/session | 24 h and 1 h before | External calendar/session link | "Your mentorship session starts in 1 hour." |
| **Waitlist availability** | A relevant mentor slot becomes available. | 1 per new availability event | Immediately / daytime | Available Guides | "A sleep mentor slot has opened this week." |

---

## 3. Calm Heads-Up Decision Rule

> **Do not turn one mood into a push.**
> Example: parent taps Mood → Sad. Store the signal. Do not immediately notify. Only use it if it combines with other meaningful context such as a short nap, long wake window, hunger/feeding gap, repeated difficult-time pattern, or recent behaviour update.

| Situation | What App Does | Push? |
|-----------|--------------|-------|
| One sad/fussy mood only | Save as context; update Today/Brainy context. | **No** |
| Sad/fussy + short nap + known evening difficulty | Increase risk score; if threshold is met, prepare Calm Heads-Up. | **Possibly one** |
| Parent already opened Calm Plan | Do not send another risk push for the same window. | **No** |
| Risk drops after new sleep/feed/mood information | Update the in-app card silently. | **No** |
| Risk remains high across repeated windows | Use pattern in Journey/Behaviour Pattern; do not spam. | **No extra push** |

---

## 4. Notification Permission Flow

1. Show the custom LovingBrain permission screen only after the parent has seen value, not on first splash.
2. Explain exactly what will be sent: sleep wind-down reminders and weekly review; never missed-day guilt.
3. Tap **"Allow notifications"** → request OS permission.
4. Tap **"Not now"** → continue app with no repeated prompt in the same session.
5. **Settings** always lets the parent turn Sleep, Check-in, Mentorship and Weekly Review notifications on/off independently.

---

## 5. Developer Implementation Notes

- Every scheduled notification needs a stable `notification_id` and `reason` so it can be cancelled when the underlying state changes.
- Use the parent/child time zone from profile.
- Log `notification_sent`, `opened`, `dismissed/not-opened` where platform permits.
- Deep link directly to the relevant screen; never open generic Home when a specific destination exists.
- Do not send a prediction notification when confidence is low; keep low-confidence guidance in-app.
