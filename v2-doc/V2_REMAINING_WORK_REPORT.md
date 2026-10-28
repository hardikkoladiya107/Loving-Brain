# LovingBrain V2 — remaining work

**Date:** 28 October 2026, evening re-check  
**Compared with:** V2 developer handoff (`v2-doc/00` through `06`) and the previous remaining-work list  
**Status:** **10 of the 12 items are still not complete.** 2 are done.

---

## Done since the last report

- **Weekly review.** It is scheduled only when there is enough data: at least two sleep logs on Today, and a weekly review that is no longer in the learning state with at least two check-in days.
- **Tantrum Instant Result.** The save now loads recent tantrums, sleep, mood, and health, compares the forecast before and after, and shows Instant Result only when the risk or the window changed.

Program cards no longer show dollar prices. The subscription screen still does, so that item is not finished.

---

## Still to finish (7)

### 1. The daily cap counts each plan, and counts it again on refresh

Sent and opened are now stored locally, and a planned reminder counts against the day it will appear. Today recalculates often. Each recalculation schedules the same sleep, check-in, or weekly reminder again and adds another count for that day. Three refreshes can fill the cap of 3 for one real notification. Cancelling a reminder does not give the count back.

**Do:** Count a notification once for its delivery day. Do not add another count when the same reminder is scheduled again. Remove the count if it is cancelled before it appears.

### 2. The empty-day check-in counter moves on every refresh

The check-in now stops after three empty days, and it resets when a log is saved. The counter increases every time Today refreshes with no log, including several times on the same day. Opening Today three times in one afternoon can use up the whole allowance.

**Do:** Increase the empty-day count once per calendar day, not once per screen refresh.

### 3. Hunger still has no feed log

Hunger is still added only when a tantrum in the last 12 hours includes the trigger “Hunger”. There is no feed check-in, and `recordFeed` is unused.

**Do:** Keep the tantrum hunger trigger, or add a feed check-in and read that log.

### 4. Reflections are still readable, and the server does not enforce the toggles

Health logs and mentorship requests are now hidden in the app when that caregiver’s toggle is off. Quick notes and parent reflections are still loaded for every linked parent. Firestore still allows any linked parent to read the child data directly.

**Do:** Hide reflections and quick notes for caregivers. Enforce the same flags in the security rules.

### 5. The waitlist notice is not tied to an open slot

Opening Mentorship sends “a mentor slot has opened” the next time a waiting parent lands there. It does not check that a guide actually became available.

**Do:** Send that notice once, only when a real slot opens.

### 6. Session reminders are never reached from the app

`confirmMentorshipSession` schedules the 24-hour and 1-hour reminders from a confirmed time, and cancellation cancels them. No screen calls that method. A parent request still only sends the immediate “requested” notice.

**Do:** Call confirm when a session time is agreed, so the two reminders are scheduled from that time.

### 7. The subscription screen still shows prices and “coming soon”

Program cards now show duration instead of prices. The subscription screen still lists plan prices and a coming-soon button, with no purchase.

**Do:** Remove those prices until payment exists, or connect a real purchase.

---

## Design pauses (3)

These stay unfinished because the final design does not include the screen.

| Item | Current state | Wait for |
| --- | --- | --- |
| Several mentors | Support selection opens one guide profile | A guide-list screen |
| Tantrum, parent calm, and co-parenting programs | Sleep Reset has a detail screen. These three do not | Approved content and a detail template |
| Recorded module | Tapping the row says the audio will be available in an upcoming update. There is still no player | A player screen and the real recording |
