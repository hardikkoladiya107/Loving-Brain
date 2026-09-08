# LOVINGBRAIN — Simple Screen Connection Flow

**How Every Parent Action Connects Through the App**
**Developer Reference for Hardik | Based on Deepak's Final 74-Screen UI**

---

## 7. Tantrum / Behaviour → Pattern → Calm Heads-Up

```
Parent logs a tantrum or difficult moment
  → Time, intensity, trigger, what helped are saved
    ↓
Useful repeated pattern
  → Behaviour Pattern can show common times / triggers / what helped
    ↓
Future day matches similar context
  → Energy Bridge may raise a Calm Heads-Up
    ↓
Calm Heads-Up
  → Uses probabilistic wording: "a harder window may be more likely"
    ↓
Calm Plan
  → Shows what to try before / during that window
    ↓
Parent reflects afterwards
  → What happened + what helped becomes new data
    ↓
Future pattern improves
  → Energy Bridge uses the outcome next time
```

> **Important:** Calm Heads-Up is not a guaranteed tantrum prediction. It should require a useful repeated combination/pattern.

---

## 8. Mood → Context, Not an Alarm

```
Parent taps Mood
  → Selects child's current mood; parent state is optional
    ↓
Mood + timestamp saved
  → One mood selection is only a context signal
    ↓
Energy Bridge checks nearby context
  → Recent sleep + recent behaviour + time of day
    ↓
Mood alone
  → No alert, no diagnosis, no tantrum prediction
    ↓
Repeated combined pattern
  → May strengthen Brainy context or a future Heads-Up
    ↓
Journey
  → Only meaningful repeated patterns should appear later
```

> **Example:** Fussy alone = save only. Short nap + repeated difficult evening window + current fussiness may strengthen an existing behaviour signal.

---

## 9. Health → Confidence / Safety

```
Parent taps Health
  → Records illness, teething, medication, low appetite etc.
    ↓
Health context saved
  → Explains why today may be unusual
    ↓
Energy Bridge checks prediction reliability
  → Is today's pattern less comparable with normal days?
    ↓
If yes
  → Lower confidence / widen the sleep window instead of pretending precision
    ↓
Brainy question arrives
  → Relevant health context can be included
    ↓
Possible safety concern
  → Stop normal guidance and show professional / emergency route
    ↓
No safety concern
  → Return to normal app guidance
```

---

## 10. Quick Note → Memory / Context

```
Parent adds Quick Note
  → Example: travel day / grandparents visited / unusual event
    ↓
Note saved
  → Free text is stored as memory/context
    ↓
Brainy can use it when relevant
  → Helps explain the day without asking parent again
    ↓
Journey may surface it if meaningful
  → Example: travel disrupted the routine
    ↓
Energy Bridge prediction
  → Does NOT automatically change from free text alone
```

---

## 11. Brainy AI → Personal Answer

```
Parent asks Brainy
  → Text or voice
    ↓
Brainy requests relevant context
  → Not the whole database — only useful recent child information
    ↓
Backend supplies context
  → Age + relevant recent sleep / behaviour / mood / health + current goal
    ↓
Safety check
  → Concerning health/safety content routes away from normal AI guidance
    ↓
Brainy Answer
  → What may be happening → what to try now → when to get help if relevant
    ↓
Parent saves guidance
  → Saved Guidance becomes available later
    ↓
Journey
  → Saved guidance / action can become part of the ongoing plan
```

---

## 12. Journey → Learn Whether Advice Worked

```
Daily updates accumulate
  → Sleep / behaviour / meaningful guidance / program progress
    ↓
Journey aggregates the week
  → Do not make raw logs the main experience
    ↓
Weekly Review
  → One positive change + one continuing difficulty + one useful pattern
    ↓
Try Recommendation
  → Choose one small change, not many
    ↓
What We're Trying This Week
  → Stores the experiment + what to observe + review date
    ↓
Parent uses normal quick updates
  → No separate tracking burden
    ↓
Review date arrives
  → Compare this week with previous pattern
    ↓
If it helped
  → Record positive change / continue
    ↓
If it did not help
  → Adjust next experiment or offer extra support
    ↓
Family Timeline
  → Stores meaningful milestones, program starts, changes and harder weeks
```

---

## 13. Programs → Structured Support

```
Repeated difficulty persists
  → Example: sleep remains inconsistent over time
    ↓
Program Recommendation
  → Shown only when structured support may be useful
    ↓
Program List
  → Parent chooses a relevant program
    ↓
Program Detail
  → Who it is for + duration + support included
    ↓
Parent enrols
  → Program status is saved
    ↓
Enrolled Journey
  → Current week + one thing to try + module + next guide session
    ↓
Parent completes weekly actions
  → Progress and check-ins are stored
    ↓
Mentor / program plan
  → Agreed next action can be added
    ↓
Journey
  → Program progress becomes part of the family's overall story
```

> **Note:** Current final UI fully defines the 6-Week Sleep Journey. Other program categories can follow the same structure when their content is final.

---

## 14. Guided Mentorship → Human Support

```
Parent opens Guided Mentorship
  → From Journey / Program / relevant support area
    ↓
Choose Support Area
  → Sleep / behaviour / parent wellbeing / co-parenting / general parenting
    ↓
Guide Profile
  → Language + experience + session information
    ↓
Request Session
  → Concern + child age + preferred time + language
    ↓
Parent chooses summary sharing
  → Consent decides whether recent LovingBrain summary is shared
    ↓
Guide receives summary
  → Relevant recent pattern / concern / plan — parent does not repeat everything
    ↓
Session arranged
  → External calendar / guide confirmation
    ↓
Session happens
  → Human guide discusses the concern
    ↓
Post-Session Plan
  → Agreed actions are saved
    ↓
Journey
  → Plan + progress become part of weekly review / active goals
```

---

## 15. Family / Caregiver Sharing

```
Parent opens Family
  → Sees linked / pending caregivers
    ↓
Parent invites partner / caregiver
  → Relationship + contact are entered
    ↓
Sharing consent shown
  → Explains what stays private
    ↓
Invite pending
  → No child data is shared yet
    ↓
Partner accepts
  → Caregiver becomes linked
    ↓
Permissions selected
  → Sleep / behaviour / health / plans / mentor summary access is controlled
    ↓
Shared Child Summary
  → Partner sees only permitted information
    ↓
Both contribute relevant updates
  → Each update is attached to the same child timeline
    ↓
Energy Bridge sees one shared child timeline
  → Combines child events regardless of which permitted caregiver entered them
    ↓
Today + Journey stay in sync
  → Both see the permitted shared picture
```

> **Privacy rules:** Parent reflections are never shared. Health notes and mentorship summaries remain private unless permission is explicitly enabled.

---

## 16. Notification Logic

```
A useful app event occurs
  → Sleep window approaching / weekly review ready / mentor status changed / gentle check-in
    ↓
Check notification permission
  → Is this notification type enabled?
    ↓
Check actionability
  → Is there something useful the parent can do now?
    ↓
Check confidence
  → For prediction-based reminders, is the output reliable enough?
    ↓
Check frequency / duplicate
  → Has a similar notification already been sent recently?
    ↓
If any check fails
  → Do not push — keep the information inside the app
    ↓
If all checks pass
  → Send notification
    ↓
Parent taps it
  → Open the exact relevant screen
```

### Notification → Destination Mapping

| Notification Type | Destination |
|-------------------|-------------|
| Sleep reminder | Sleep / Tonight's Plan |
| Check-in | Today / Quick Update |
| Mentorship | Request / Session |
| Weekly Review | Journey / Weekly Review |

> **Never** send streak guilt, missed-day guilt, duplicates, or an alert just because Mood = Sad/Fussy.

---

## 17. Important State Logic

```
No data
  → Show age-based/general guidance → ask for one useful update
    ↓
Low confidence
  → Show a wider window + explain LovingBrain is still learning
    ↓
Save error
  → Keep the parent's entered data visible → retry / save locally
    ↓
Offline
  → Show last saved plan → sync when online
    ↓
Safety concern
  → Stop normal AI flow → professional / emergency route
    ↓
Mentor unavailable
  → Waitlist / other guide / Ask Brainy
```

---

## 18. Hardik's Build Rule

For every screen and every input, follow this sequence:

```
1. Parent action
   → What did the parent record / tap?
     ↓
2. Save structured data
   → What exact event and timestamp should be stored?
     ↓
3. Energy Bridge check
   → Which existing outputs can this event affect?
     ↓
4. Confidence + safety
   → Is there enough reliable data to show a personalised result?
     ↓
5. Show next useful screen
   → Forecast / plan / Heads-Up / Brainy / Journey / nothing new
     ↓
6. Notification gate
   → Only push if useful, enabled, confident and not duplicated
     ↓
7. Future learning
   → The result/outcome becomes data for later patterns
```

> **Key principle:** If Hardik cannot answer *"what output does this input improve?"*, the input should usually remain context-only instead of forcing a prediction.
