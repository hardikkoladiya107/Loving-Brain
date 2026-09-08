# LOVINGBRAIN — Complete User Flow & Interaction Logic

**Developer Handoff for Hardik | v3 - Connected Feature Logic**
**Based on Deepak's final 74-screen mobile UI (Figma/PDF)**

> **Purpose:** Remove guesswork during development. For every screen this document defines what the parent sees, what each action should do, what data/logic is involved, where the user goes next, and why the screen matters.

**Prepared for LovingBrain | September 2026**

---

## How Hardik Should Use This Document

### UI Source of Truth
Deepak's final Figma/PDF remains the visual source of truth. Do not redesign screens while implementing this flow.

### Interaction Source of Truth
Use the tap/actions and transitions in this document when a Figma prototype link is missing or clearly points to a temporary/demo screen.

### Main Navigation Stays Fixed
The bottom navigation remains **Today → Brainy AI → Journey**, exactly as Deepak designed.

### Data Should Create Value
A parent update should feed a useful output (forecast, pattern, calm heads-up, weekly review or mentor context). Avoid logging for logging's sake.

### Protect Trust
If data is missing or confidence is low, use the dedicated no-data/low-confidence states rather than displaying fake precision.

### Preserve Drafts
On network or save errors, never make the parent re-enter information they just typed.

---

## Core Data / Logic Objects

> Developer naming can follow the existing backend.

| Object | Role in the App |
|--------|----------------|
| **ParentProfile** | name, relationship, language, location/timezone, preferences |
| **ChildProfile** | name, DOB/age, gender, sleep baseline, concerns/triggers |
| **SleepLog** | wake/nap/night information + quality + timestamp |
| **TantrumLog** | event, time, intensity, possible triggers, what helped |
| **MoodLog / HealthLog / Note** | lightweight contextual updates |
| **SleepForecast** | next window, bedtime estimate, confidence, reason, plan |
| **BehaviourRisk / Pattern** | risk window, confidence, contributing signals, common patterns |
| **WeeklyReview / ActiveExperiment / TimelineEvent** | Journey summaries and progress |
| **BrainyConversation / SavedGuidance** | AI history and user-saved answers |
| **MentorshipRequest / ProgramEnrollment / MentorPlan** | human support workflow |
| **CaregiverInvite / CaregiverPermission** | family sharing and privacy controls |
| **NotificationPreferences / PendingLocalUpdate** | settings and offline reliability |

---

## How LovingBrain Should Make Decisions

> **Important for Hardik**

Use this simple model on every screen: **INPUT → DECISION → OUTPUT → PARENT VALUE**. The first version can be rules/config based. Hardik does not need machine learning to implement this logic.

| Priority | Signal | How the App Should Use It |
|----------|--------|---------------------------|
| 1 | **Safety / health context** | Overrides normal personalisation. If a safety rule is triggered, use the safety flow instead of a normal prediction or reassuring AI answer. |
| 2 | **Recent real child data** | Recent sleep, behaviour, mood and relevant health context are stronger than assumptions made during onboarding. |
| 3 | **Repeated patterns** | A repeated pattern is stronger than one isolated update. Only promote a pattern when there is enough supporting data. |
| 4 | **Parent concern + goal** | These are initial priority signals. They decide what LovingBrain emphasises first; they must not hide the rest of the app. |
| 5 | **Age-based baseline** | Use age guidance only as a starting point when personal data is missing. Label it as general guidance, not the child's own pattern. |

> **Example — Screen 06, Main Concern:** If a parent chooses Sleep and then chooses *Easier bedtimes* on Screen 07, save that as the initial focus. Today should emphasise sleep help, Brainy should offer sleep-related prompts, and the first snapshot should use sleep context where possible. Do not remove tantrum or mood features. If later real logs show a repeated difficult-evening pattern, that recent pattern can become more important than the onboarding preference.

> **Developer rule:** onboarding answers are a starting hypothesis, not permanent truth. Real usage should gradually personalise the experience.

---

## How Logs Connect to Useful Outcomes

> **Hardik:** logs are not collected just to create a tracker. Each structured update should improve a useful parent output. Energy Bridge can be treated as the shared backend logic layer; no navigation redesign is required.

- **Sleep** → improves sleep forecast/plan and can change tiredness-related Calm Heads-Up.
- **Tantrum** → learns repeated times, triggers and what helped.
- **Mood** → adds context; one Sad mood never creates an alert by itself.
- **Health** → can explain unusual days, reduce confidence or trigger safety routing.
- **Notes** → memory/context only unless later converted into an approved structured signal.

> **Notification rule:** send a notification only when there is a useful future action, the relevant notification type is enabled, and confidence is sufficient. Never notify simply because a parent selected Sad, Tired or another normal state.

---

## Master User Flow

The main parent journey is intentionally simple at the top level:

- **New user:** Splash → Welcome → Account → OTP → Parent setup → Concern → Goal → Child → Sleep baseline → Behaviour baseline → Family Snapshot → Today
- **Daily use:** Today → quick update / Sleep / Calm Heads-Up → useful result → Today
- **AI support:** Today or any relevant screen → Brainy AI → answer → follow-up / save / history
- **Progress:** Today → Journey → Weekly Review / Family Timeline / active program
- **Human support:** Sleep/Behaviour/Journey → Guided Mentorship → Program or support area → Guide → Request / external calendar → Journey progress
- **Family support:** Profile/Family → consent → invite → pending → accepted → permissions

| Area | Main Entry | Main Output |
|------|-----------|-------------|
| **Today** | App open / bottom nav | Forecast + heads-up + quick actions |
| **Sleep** | Today → View details / Sleep | Next sleep window + reason + tonight plan |
| **Tantrum support** | Today heads-up / Tantrum log | Risk window + calm plan + pattern |
| **Brainy AI** | Bottom nav / Ask Brainy | Context-aware answer + follow-up |
| **Journey** | Bottom nav | Weekly meaning + progress + timeline |
| **Mentorship** | Program recommendation / Journey | Guide + session/program support |
| **Family** | Profile/Family | Shared data with explicit permissions |

---

## Onboarding Screens (1–11)

### Screen 01 | Splash Screen

**Section:** Onboarding
**Flow:** App launch → Splash Screen → Welcome (p2)

**Purpose:** Brand entry screen shown while the app initializes.

**Tap / Interaction Contract:**
- **Automatic** → After app initialization, move to Welcome. No user tap required. → Welcome (p2)

**Logic Hardik should implement:**
- Check whether the user already has a valid signed-in session.
- If already authenticated and onboarding is complete, skip onboarding and open Today instead.

| Reads | Writes |
|-------|--------|
| Auth/session state | None |

**Why this matters to the parent:** Fast, calm entry into LovingBrain without asking the parent to do anything.

**Simple logic connection:**
- **Parent does →** Opens LovingBrain.
- **App learns / uses →** Only app/start state; no family data.
- **Next effect →** New users move to the welcome flow; signed-in users can bypass onboarding.
- **Parent benefit →** Fast entry without unnecessary questions.

---

### Screen 02 | Welcome

**Section:** Onboarding
**Flow:** Splash (p1) → Welcome → Create Account (p3)

**Purpose:** Explain the core promise before asking for account details.

**Tap / Interaction Contract:**
- **Get Started** → Open account setup. → Create Account (p3)

**Logic Hardik should implement:**
- This is shown only to a new or signed-out user.
- Do not show repeated marketing slides; one clear promise is enough.

| Reads | Writes |
|-------|--------|
| None | None |

**Why this matters to the parent:** The parent immediately understands: LovingBrain helps notice patterns and tells them what to try next.

**Simple logic connection:**
- **Parent does →** Reads the promise and taps Get Started.
- **App learns / uses →** Nothing yet; this is orientation only.
- **Next effect →** Starts account setup.
- **Parent benefit →** Understands that LovingBrain will find patterns and suggest what to try.

---

### Screen 03 | Create Account

**Section:** Onboarding
**Flow:** Welcome (p2) → Create Account → OTP (p4) or About You (p5)

**Purpose:** Create or authenticate the parent account with minimal friction.

**Tap / Interaction Contract:**
- **Continue** → Use the entered phone number to start OTP verification. Store email as contact email if supplied. → OTP (p4)
  - *Data/state:* Pending auth/contact data
- **Continue with Apple** → Run Apple sign-in. On success, continue onboarding. → About You (p5)
  - *Data/state:* Auth user record
- **Continue with Google** → Run Google sign-in. On success, continue onboarding. → About You (p5)
  - *Data/state:* Auth user record
- **Back** → Return to Welcome without deleting any already typed local values. → Welcome (p2)

**Logic Hardik should implement:**
- The separate OTP screen means phone authentication should route through OTP.
- The Figma prototype wiring is inconsistent here; use this document as the intended behavior.
- Validate phone format before sending OTP. Do not create duplicate accounts for the same authenticated identity.

| Reads | Writes |
|-------|--------|
| Existing auth account if any | Auth identity; phone/email contact |

**Why this matters to the parent:** Lets a tired parent start quickly using the sign-in method they already trust.

**Simple logic connection:**
- **Parent does →** Chooses phone, email, Apple or Google sign-in.
- **App learns / uses →** Creates/links the parent's secure account identity.
- **Next effect →** New accounts continue to verification/onboarding; existing accounts load their saved family.
- **Parent benefit →** Keeps their child data and guidance attached to one account.

---

### Screen 04 | OTP Verification

**Section:** Onboarding
**Flow:** Create Account (p3) → OTP Verification → About You (p5)

**Purpose:** Verify the parent phone number before creating the signed-in session.

**Tap / Interaction Contract:**
- **Continue** → Validate the 4-digit code. If correct, complete sign-in and continue. → About You (p5)
  - *Data/state:* Verified auth state
- **Retry / resend** → After timer reaches zero, request a new OTP and restart resend timer. → Stay on OTP
  - *Data/state:* OTP request metadata
- **Back** → Return to account setup so the parent can correct the number. → Create Account (p3)

**Logic Hardik should implement:**
- Disable Continue until four digits are entered.
- Show a clear inline error for wrong/expired code; do not clear the phone number.
- Rate-limit OTP resend.

| Reads | Writes |
|-------|--------|
| OTP challenge | Verified auth/session |

**Why this matters to the parent:** Secure sign-in while keeping the verification process short.

**Simple logic connection:**
- **Parent does →** Enters the OTP sent to the phone.
- **App learns / uses →** Confirms the phone belongs to this parent.
- **Next effect →** Successful verification unlocks profile setup; failed codes stay on this screen.
- **Parent benefit →** Protects family information from someone using the wrong number.

---

### Screen 05 | About You

**Section:** Onboarding
**Flow:** OTP / social sign-in → About You → Main Concern (p6)

**Purpose:** Collect the minimum parent information needed for personalisation, language and correct time calculations.

**Tap / Interaction Contract:**
- **Relationship option** → Select Mother, Father, Guardian or Caregiver. One selection. → Stay
  - *Data/state:* parentRelationship
- **Preferred Language** → Select the parent-facing language. → Stay
  - *Data/state:* preferredLanguage
- **Change location** → Open device/manual location-timezone selector. → Stay
  - *Data/state:* timezone/location
- **Continue** → Validate required fields, save profile and move to concern selection. → Main Concern (p6)
  - *Data/state:* Parent profile
- **Back** → Return to OTP/account step. → Create Account / OTP

**Logic Hardik should implement:**
- Time zone is important because sleep windows and notification times depend on local time.
- Language choice should later be reused for Brainy, notifications and mentor matching.

| Reads | Writes |
|-------|--------|
| Auth identity; device locale/time zone | Parent name, relationship, language, location/timezone |

**Why this matters to the parent:** Makes the app feel personal and prevents wrong-time sleep guidance.

**Simple logic connection:**
- **Parent does →** Adds name, relationship, language and location/time zone.
- **App learns / uses →** Learns how to address the parent, which language to prefer, and which local clock to use.
- **Next effect →** Time-based sleep windows/reminders use this time zone; Brainy/mentor matching can use language.
- **Parent benefit →** Advice arrives in the right language and at the right local time.

---

### Screen 06 | Main Concern

**Section:** Onboarding
**Flow:** About You (p5) → Main Concern → Success Goal (p7)

**Purpose:** Understand the parent's biggest problem right now so LovingBrain can prioritise relevant guidance.

**Tap / Interaction Contract:**
- **Sleep / Tantrums / Routine / Parenting stress** → Select one primary concern. → Stay
  - *Data/state:* primaryConcern
- **More than one** → Enable multi-select of the concern cards on this same screen. Do not add another ranking screen. → Stay
  - *Data/state:* concerns[]
- **Continue** → Save concern and move to desired outcome. → Success Goal (p7)
  - *Data/state:* Onboarding preference
- **Back** → Return to About You. → About You (p5)

**Logic Hardik should implement:**
- The screen says the parent can change this later, so this must remain editable from profile/settings.
- Concern influences home emphasis, suggested Brainy prompts and weekly focus.

| Reads | Writes |
|-------|--------|
| Child/parent profile draft | primaryConcern, concerns[] |

**Why this matters to the parent:** The parent sees relevant help instead of a generic parenting dashboard.

**Simple logic connection:**
- **Parent does →** Chooses the biggest reason for coming to LovingBrain.
- **App learns / uses →** Creates the FIRST priority signal: sleep, tantrums, routine, parenting stress, or multiple needs.
- **Next effect →** Initially changes what Today highlights, what Brainy suggests and which support is recommended. Real usage can later override this starting assumption.
- **Parent benefit →** The app starts with the problem the parent actually cares about instead of showing generic parenting content.

---

### Screen 07 | Success Goal

**Section:** Onboarding
**Flow:** Main Concern (p6) → Success Goal → About Your Child (p8)

**Purpose:** Capture what improvement would feel meaningful to this parent.

**Tap / Interaction Contract:**
- **Goal card** → Select the goal closest to the parent's desired outcome. → Stay
  - *Data/state:* successGoal
- **Continue** → Save goal and move to child profile. → About Your Child (p8)
  - *Data/state:* Goal preference
- **Back** → Return to Main Concern. → Main Concern (p6)

**Logic Hardik should implement:**
- Use this goal to shape weekly review language and recommendations.
- Avoid claiming guaranteed outcomes; it is a focus, not a promise.

| Reads | Writes |
|-------|--------|
| Primary concern | successGoal |

**Why this matters to the parent:** Turns broad parenting problems into a clear outcome the parent cares about.

**Simple logic connection:**
- **Parent does →** Chooses what a successful outcome would feel like.
- **App learns / uses →** Learns the parent's desired outcome, not just the problem category.
- **Next effect →** Weekly reviews and recommendations can measure progress against this goal while staying within the chosen concern.
- **Parent benefit →** The parent sees progress in terms that matter to them, such as easier bedtimes or more confidence.

---

### Screen 08 | About Your Child

**Section:** Onboarding
**Flow:** Success Goal (p7) → About Your Child → Sleep Setup (p9)

**Purpose:** Create the child profile and calculate age-based guidance.

**Tap / Interaction Contract:**
- **Child photo +** → Optional image picker; image is not required to continue. → Stay
  - *Data/state:* childAvatar
- **Date of birth** → Open date picker and calculate age. → Stay
  - *Data/state:* dateOfBirth
- **Gender option** → Select Boy, Girl or Prefer not to say. → Stay
  - *Data/state:* gender
- **Continue** → Validate name/date of birth and continue to sleep baseline. → Sleep Setup (p9)
  - *Data/state:* Child profile
- **Back** → Return to Success Goal. → Success Goal (p7)

**Logic Hardik should implement:**
- Age is a key input for sleep guidance, so DOB must be stored as a date, not only an age number.
- If DOB changes later, age-based guidance should re-base from the next calculation cycle.

| Reads | Writes |
|-------|--------|
| None | Child name, DOB, gender, optional avatar |

**Why this matters to the parent:** Allows LovingBrain to tailor sleep and behaviour guidance to the child's age.

**Simple logic connection:**
- **Parent does →** Adds the child's name, date of birth and gender preference.
- **App learns / uses →** Learns child age, which is the main rule input for age-based guidance.
- **Next effect →** Sleep ranges, wording and age-appropriate guidance re-base from DOB; real child data then personalises further.
- **Parent benefit →** Avoids one-size-fits-all advice.

---

### Screen 09 | Sleep Setup

**Section:** Onboarding
**Flow:** About Your Child (p8) → Sleep Setup → Behaviour Setup (p10)

**Purpose:** Collect a rough baseline of the child's normal day before any detailed logging exists.

**Tap / Interaction Contract:**
- **Wake time** → Open time picker. → Stay
  - *Data/state:* usualWakeTime
- **Bedtime** → Open time picker. → Stay
  - *Data/state:* usualBedtime
- **Naps - / +** → Decrease/increase typical naps per day within a sensible range. → Stay
  - *Data/state:* usualNapsPerDay
- **Night wakings** → Select None, 1-2, 3+ or Varies. → Stay
  - *Data/state:* nightWakingsBaseline
- **Continue** → Save baseline and move to behaviour setup. → Behaviour Setup (p10)
  - *Data/state:* Sleep baseline
- **Back** → Return to Child Profile. → About Your Child (p8)

**Logic Hardik should implement:**
- These are rough baseline values only; actual logs should gradually replace assumptions.
- Use the child's age and baseline for the initial general sleep estimate until real data is available.

| Reads | Writes |
|-------|--------|
| Child age | Sleep baseline fields |

**Why this matters to the parent:** Gives useful starting guidance without forcing the parent to log a full history first.

**Simple logic connection:**
- **Parent does →** Adds usual wake time, bedtime, naps and night-waking baseline.
- **App learns / uses →** Creates an initial sleep baseline before enough real logs exist.
- **Next effect →** The first forecast can use age + baseline. As real sleep updates accumulate, actual data should take priority over onboarding estimates.
- **Parent benefit →** Gets useful sleep guidance from day one without waiting a week.

---

### Screen 10 | Behaviour Setup

**Section:** Onboarding
**Flow:** Sleep Setup (p9) → Behaviour Setup → Family Snapshot (p11)

**Purpose:** Capture common difficult times and possible triggers to seed early pattern detection.

**Tap / Interaction Contract:**
- **Difficult time chip** → Toggle any that apply. Multiple allowed. → Stay
  - *Data/state:* difficultTimes[]
- **Possible trigger chip** → Toggle any that apply. Multiple allowed. → Stay
  - *Data/state:* knownTriggers[]
- **Continue** → Save behaviour baseline and generate first family snapshot. → Family Snapshot (p11)
  - *Data/state:* Behaviour baseline
- **Back** → Return to Sleep Setup. → Sleep Setup (p9)

**Logic Hardik should implement:**
- These are parent observations, not diagnoses.
- Later behaviour logs should confirm, weaken or replace these initial assumptions.

| Reads | Writes |
|-------|--------|
| Age, concern, goal | difficultTimes[], knownTriggers[] |

**Why this matters to the parent:** Lets LovingBrain start with the parent's lived experience instead of pretending it already knows the child.

**Simple logic connection:**
- **Parent does →** Selects difficult times and possible triggers.
- **App learns / uses →** Creates an initial behaviour/tantrum hypothesis: when hard moments happen and what may contribute.
- **Next effect →** Calm Heads-Up can use this only as a low-confidence starting signal; real tantrum, sleep and mood updates should gradually replace assumptions.
- **Parent benefit →** The app starts watching the situations the parent already finds difficult.

---

### Screen 11 | Family Snapshot

**Section:** Onboarding
**Flow:** Behaviour Setup (p10) → Family Snapshot → Today - New Parent (p13)

**Purpose:** Give immediate value at the end of onboarding using the information the parent just entered.

**Tap / Interaction Contract:**
- **Go to Today** → Finish onboarding and open the new-parent Today state. → Today - New Parent (p13)
  - *Data/state:* onboardingComplete=true

**Logic Hardik should implement:**
- Generate the snapshot from onboarding answers and age guidance only; label it as an early suggestion, not a learned pattern.
- The Figma prototype links this button incorrectly. The intended destination is Today, not Splash.

| Reads | Writes |
|-------|--------|
| All onboarding answers | onboardingComplete; initial focus/recommendation |

**Why this matters to the parent:** The parent gets a useful first action before they have built up any logs.

**Simple logic connection:**
- **Parent does →** Reviews the family snapshot and taps Go to Today.
- **App learns / uses →** Combines onboarding inputs into the first simple hypothesis and first action.
- **Next effect →** Stores the initial focus and shows Today; later recommendations are updated by real logs rather than repeating onboarding answers.
- **Parent benefit →** Parent receives value immediately instead of finishing onboarding with an empty dashboard.

---

## Today Screens (12–15)

### Screen 12 | Today - Normal State

**Section:** Today
**Flow:** App open / onboarding → Today - Normal State → Sleep, updates, Calm plan, Brainy or Journey

**Purpose:** Main daily home after enough data exists to show a personalised sleep forecast and useful patterns.

**Tap / Interaction Contract:**
- **Child / parent controls** → Child name opens Child Profile; parent avatar opens Parent Profile. → p60 / p59
- **View details** → Open the full sleep forecast experience. → Sleep Forecast (p23)
- **Heads-up card** → Open the detailed Calm Heads-Up. → Calm Heads-Up (p28)
- **Quick actions** → Sleep → p17; Tantrums → p18; Mood → p19; Health → p20; Notes → p21; Ask Brainy → p32. → Matching screen
- **Bottom navigation** → Brainy AI → p32; Journey → p37; Today keeps the user here. → p32 / p37 / Today

**Logic Hardik should implement:**
- Today is assembled from the latest sleep forecast, behaviour heads-up, weekly pattern and positive progress signal.
- If there is not enough data, show p13 instead of inventing precision.
- Do not show stale predictions as current without timestamp/date validation.

| Reads | Writes |
|-------|--------|
| Profiles; recent logs; forecast; heads-up; progress summary | None unless an action is taken |

**Why this matters to the parent:** The parent can answer three questions quickly: what is likely next, why, and what should I do?

**Simple logic connection:**
- **Parent does →** Opens Today and chooses the most relevant card or quick action.
- **App learns / uses →** Reads the latest sleep, behaviour, mood and profile context already available.
- **Next effect →** Ranks the most useful current output: forecast, heads-up, pattern, positive change or next action.
- **Parent benefit →** Parent does not have to search through the app to know what matters now.

---

### Screen 13 | Today - New Parent / Not Enough Data

**Section:** Today
**Flow:** Family Snapshot (p11) / app open → Today - New Parent / Not Enough Data → First update → p17/p18

**Purpose:** Home state for a new family before LovingBrain has enough real data to show personalised patterns.

**Tap / Interaction Contract:**
- **Add sleep update** → Open Sleep Update. → Sleep Update (p17)
- **Add behaviour update** → Open Tantrum Update. → Tantrum Update (p18)
- **Quick action tiles** → Open the matching update/Brainy screen. → p17-p21 / p32
- **Bottom nav** → Switch Today / Brainy AI / Journey. → p32 or p37

**Logic Hardik should implement:**
- Never fabricate a personalised forecast with zero data.
- After the first saved update, recalculate what can be shown; if still low confidence, use p64 or p69 states.

| Reads | Writes |
|-------|--------|
| Profiles; count of usable logs | None |

**Why this matters to the parent:** Builds trust by being honest that LovingBrain is still learning the child.

**Simple logic connection:**
- **Parent does →** Adds the first sleep or behaviour update.
- **App learns / uses →** Begins replacing generic age guidance with this child's real data.
- **Next effect →** After enough useful updates, Today moves from 'learning' to personalised forecast/pattern states.
- **Parent benefit →** Shows clearly why logging is worth doing: it unlocks personalised guidance.

---

### Screen 14 | Today - Important Heads-Up

**Section:** Today
**Flow:** Today / notification → Today - Important Heads-Up → Calm Plan (p29) or Brainy

**Purpose:** Escalated home state when a harder behaviour window is likely enough to deserve immediate attention.

**Tap / Interaction Contract:**
- **See calm plan** → Open the step-by-step Calm Plan. → Calm Plan (p29)
- **Play audio** → Play the short calming audio in place; request microphone/audio permissions only if technically necessary. → Stay
  - *Data/state:* Audio event only
- **Ask Brainy** → Open Brainy with the current heads-up context attached. → Brainy Home / Conversation (p32-p33)
- **Bottom nav** → Switch tabs. → p32/p37

**Logic Hardik should implement:**
- Only show a heads-up when there is a clear reason and confidence level.
- Always show the reason (for example overtiredness + skipped nap) and time window.
- Do not present this as certainty or diagnosis.

| Reads | Writes |
|-------|--------|
| Recent sleep/behaviour/context logs; risk output | Optional audio/engagement event |

**Why this matters to the parent:** Helps the parent prepare before a difficult window instead of only explaining it afterwards.

**Simple logic connection:**
- **Parent does →** Opens an important Calm Heads-Up, plays audio or asks Brainy.
- **App learns / uses →** Uses the current risk window and contributing signals.
- **Next effect →** Opens the prevention plan or contextual AI help. A heads-up notification should only be sent when a meaningful future window exists and notifications are enabled.
- **Parent benefit →** Gives the parent time to act before a difficult window rather than only explaining it afterwards.

---

### Screen 15 | Guided Sleep Support Recommendation Modal

**Section:** Today
**Flow:** Today (p12) → Guided Sleep Support Recommendation Modal → Program Support or back Today

**Purpose:** Offer structured support only after the app detects that sleep has remained unsettled for a sustained period.

**Tap / Interaction Contract:**
- **View support** → Open the recommended program/support view. → Program Recommendation (p27) or Program Detail (p44)
- **Join waitlist** → Add parent to the program waitlist if the program is not open. → Confirmation/toast; return Today
  - *Data/state:* Waitlist record
- **Not now** → Dismiss and remember dismissal for a cooling-off period. → Today (p12)
  - *Data/state:* Dismissal timestamp

**Logic Hardik should implement:**
- Trigger only after a defined persistence threshold, e.g. repeated inconsistent sleep across several days, not after one bad night.
- Do not show on every app open once dismissed.

| Reads | Writes |
|-------|--------|
| Sleep pattern duration; support availability | Waitlist or dismissal state |

**Why this matters to the parent:** Connects recurring problems to deeper human/program support without making the app feel sales-heavy.

**Simple logic connection:**
- **Parent does →** Chooses View support, waitlist or Not now.
- **App learns / uses →** Uses persistence of a sleep problem plus previous dismissal/support state.
- **Next effect →** Repeated sleep difficulty can surface the relevant program; dismissal pauses repeated prompts.
- **Parent benefit →** Offers deeper help only when the problem appears persistent, not after one bad night.

---

## Quick Check-ins (16–22)

### Screen 16 | Check-in Menu

**Section:** Quick Check-ins
**Flow:** Today / Add update → Check-in Menu → p17-p21 or p32

**Purpose:** A single update launcher when the parent wants to add information without navigating through separate sections.

**Tap / Interaction Contract:**
- **Sleep** → Open Sleep Update. → p17
- **Tantrums** → Open Tantrum Update. → p18
- **Mood** → Open Mood Check. → p19
- **Health** → Open Health Update. → p20
- **Notes** → Open Quick Note. → p21
- **Ask Brainy** → Open Brainy Home. → p32
- **Dismiss sheet** → Return to the underlying Today screen. → Today

**Logic Hardik should implement:**
- This sheet is a convenience entry point. Today quick-action tiles may open the same forms directly.
- Keep selected/typed data if the sheet is temporarily dismissed and reopened during the same session.

| Reads | Writes |
|-------|--------|
| Current Today context | None |

**Why this matters to the parent:** Lets parents capture a meaningful update in seconds without searching through menus.

**Simple logic connection:**
- **Parent does →** Chooses what to update: Sleep, Tantrum, Mood, Health, Note or Brainy.
- **App learns / uses →** Routes the parent to the correct structured input; the menu itself learns nothing.
- **Next effect →** Each structured update feeds only the logic it is meant to improve; Ask Brainy opens contextual help instead of a log.
- **Parent benefit →** Makes logging quick and explains that every update has a purpose.

---

### Screen 17 | Sleep Update

**Section:** Quick Check-ins
**Flow:** Today / Check-in Menu → Sleep Update → Instant Result (p22) or Today

**Purpose:** Capture the sleep information that powers sleep windows, patterns and weekly insight.

**Tap / Interaction Contract:**
- **Wake time fields** → Open time picker; choose the relevant wake event. → Stay
  - *Data/state:* wakeTime
- **Nap started/ended** → Open start/end time picker; validate end is after start. → Stay
  - *Data/state:* napStart, napEnd
- **Night waking toggle** → Mark whether a night waking occurred; if detailed count is supported, store it. → Stay
  - *Data/state:* nightWaking
- **Sleep quality** → Select quality rating. → Stay
  - *Data/state:* sleepQuality
- **Save update** → Validate, save log, recalculate sleep forecast and behaviour risk. → Instant Result (p22) if output changed; otherwise Today/Check-in Menu
  - *Data/state:* SleepLog

**Logic Hardik should implement:**
- Use timestamps and child/timezone, not display strings, for calculations.
- A saved sleep update must trigger forecast recalculation.
- If saving fails, show Error state p67 and preserve the form values.

| Reads | Writes |
|-------|--------|
| Child profile; current date/time; existing sleep logs | SleepLog; recalculated forecast inputs |

**Why this matters to the parent:** One short update creates something useful: a better next sleep window and better pattern understanding.

**Simple logic connection:**
- **Parent does →** Records wake, nap, night waking and sleep quality.
- **App learns / uses →** Learns the child's most recent sleep timing and quality.
- **Next effect →** Immediately recalculates the sleep window/confidence and can also update Calm Heads-Up because tiredness is a tantrum signal. If a reminder time materially changes, reschedule the sleep reminder when permission is enabled.
- **Parent benefit →** One short update can change tonight's plan instead of becoming a passive diary entry.

---

### Screen 18 | Tantrum Update

**Section:** Quick Check-ins
**Flow:** Today / Check-in Menu → Tantrum Update → Today / Behaviour Pattern (p30)

**Purpose:** Record a difficult moment so LovingBrain can learn timing, likely triggers and what helped.

**Tap / Interaction Contract:**
- **What happened** → Enter short description. → Stay
  - *Data/state:* eventSummary
- **Approximate time** → Open time picker. → Stay
  - *Data/state:* eventTime
- **Intensity slider** → Set mild-to-intense value. → Stay
  - *Data/state:* intensity
- **Possible trigger chips** → Select one or more known/unknown triggers. → Stay
  - *Data/state:* triggers[]
- **What helped** → Enter/select the response that helped. → Stay
  - *Data/state:* whatHelped
- **Save update** → Save event and recalculate behaviour patterns/heads-up confidence. → Today or Behaviour Pattern when enough data exists
  - *Data/state:* TantrumLog

**Logic Hardik should implement:**
- Treat triggers as parent-reported possibilities, not factual causes.
- Repeated events should feed common-time and trigger combinations on p30.
- If the event occurred during a predicted window, record that internally for future accuracy evaluation.

| Reads | Writes |
|-------|--------|
| Child/context; existing behaviour logs | TantrumLog; pattern statistics |

**Why this matters to the parent:** Turns stressful moments into practical pattern knowledge instead of a diary the parent has to reread.

**Simple logic connection:**
- **Parent does →** Records what happened, time, intensity, possible trigger and what helped.
- **App learns / uses →** Learns when hard moments occur, how intense they are, likely triggers and successful calming responses.
- **Next effect →** Repeated events update Behaviour Pattern and can improve future Calm Heads-Up timing. One tantrum alone should NOT create a scary notification or claim a pattern.
- **Parent benefit →** Over time the parent learns what tends to trigger hard moments and what actually helps their child.

---

### Screen 19 | Mood Check

**Section:** Quick Check-ins
**Flow:** Today / Check-in Menu → Mood Check → Today

**Purpose:** Capture the child's current mood and optionally the parent's state as lightweight context.

**Tap / Interaction Contract:**
- **Child emotion face** → Select one child mood. → Stay
  - *Data/state:* childMood
- **Parent state chip** → Optional: select Calm, Tired, Overwhelmed or Okay. → Stay
  - *Data/state:* parentState
- **Save update** → Save timestamped mood context and return. → Today / Check-in Menu
  - *Data/state:* MoodLog

**Logic Hardik should implement:**
- Parent state is optional and private by default.
- Child mood may be used as one context signal for behaviour heads-ups; parent state should not be used to diagnose.

| Reads | Writes |
|-------|--------|
| Child/parent profile | MoodLog |

**Why this matters to the parent:** Adds context with almost no effort and gives the parent a moment to notice how both of them are doing.

**Simple logic connection:**
- **Parent does →** Selects the child's current mood and optionally the parent's own state.
- **App learns / uses →** Adds a timestamped context signal. A single 'sad' or 'fussy' mood is NOT a diagnosis and should not be treated as a problem by itself.
- **Next effect →** Recalculate only relevant current outputs. Repeated mood changes, especially when combined with sleep/behaviour patterns, can improve Calm Heads-Up, Brainy context and weekly insights. Do NOT notify simply because 'Sad' was selected; notify only if combined signals create a useful future heads-up and notifications are enabled.
- **Parent benefit →** The parent gets more relevant guidance without writing a journal, while avoiding alarm from one normal emotion.

---

### Screen 20 | Health Update

**Section:** Quick Check-ins
**Flow:** Today / Check-in Menu → Health Update → Today

**Purpose:** Let the parent note non-diagnostic health context that may explain unusual sleep or mood.

**Tap / Interaction Contract:**
- **Health chips** → Select any relevant items such as teething, low appetite or medication. → Stay
  - *Data/state:* healthFlags[]
- **Notes** → Add a short free-text note. → Stay
  - *Data/state:* note
- **Save update** → Save health context. Recalculate only where the model is designed to consider it. → Today / Check-in Menu
  - *Data/state:* HealthLog

**Logic Hardik should implement:**
- This is context, not symptom assessment.
- Always retain the medical disclaimer and escalation route.
- If free text contains a serious safety signal and Brainy/safety rules are enabled, route to p70 rather than generating reassurance.

| Reads | Writes |
|-------|--------|
| Child profile | HealthLog |

**Why this matters to the parent:** Prevents the app from treating an unusual day as a normal sleep/behaviour pattern when illness or teething may be involved.

**Simple logic connection:**
- **Parent does →** Adds temporary health context such as fever, teething, medication or low appetite.
- **App learns / uses →** Learns that today's sleep/mood may be affected by an unusual physical context.
- **Next effect →** Can lower prediction confidence, explain why today may differ, and run safety rules. It must not diagnose. Health context can also be shown to Brainy where appropriate.
- **Parent benefit →** Prevents LovingBrain from pretending a normal pattern applies when the child may be unwell.

---

### Screen 21 | Quick Note

**Section:** Quick Check-ins
**Flow:** Today / Check-in Menu → Quick Note → Today

**Purpose:** Capture anything the parent wants to remember without forcing structured fields.

**Tap / Interaction Contract:**
- **Text area** → Type a note. → Stay
  - *Data/state:* noteText
- **Hold to record** → If microphone permission exists, record only while held and convert/store according to implementation. First use → p73 permission. → Stay
  - *Data/state:* voice note/transcript
- **Save note** → Save the note and return. → Today / Check-in Menu
  - *Data/state:* Note

**Logic Hardik should implement:**
- Quick notes do not automatically become predictions unless the backend has a safe structured extraction step.
- The Figma drag link to Instant Result is prototype-only; normal Save should not pretend the note changed the forecast.

| Reads | Writes |
|-------|--------|
| Microphone permission | Note / optional recording/transcript |

**Why this matters to the parent:** Gives the parent a low-effort memory aid without turning LovingBrain into a full journal.

**Simple logic connection:**
- **Parent does →** Writes or records something they simply want to remember.
- **App learns / uses →** Stores parent-authored context; by default this is memory, not a structured prediction signal.
- **Next effect →** Show it in the appropriate history/context. Do not silently change sleep or tantrum predictions from free text unless a future approved classifier explicitly converts it into a structured signal.
- **Parent benefit →** Lets the parent capture useful context without making every note part of the algorithm.

---

### Screen 22 | Instant Result After Update

**Section:** Quick Check-ins
**Flow:** Saved update (p17-p20) → Instant Result After Update → Today (p12)

**Purpose:** Show the parent immediately when a saved update changes the current plan.

**Tap / Interaction Contract:**
- **Save note** → Save this generated insight into Saved Guidance/notes if supported. → Stay / Saved Guidance
  - *Data/state:* Saved insight
- **Done** → Close the result and return to Today. → Today (p12)

**Logic Hardik should implement:**
- Show only when the new log materially changes a recommendation.
- The reason must reference the data change that caused it, and the action must be specific.
- If no material change occurred, show a simple *Update saved* confirmation rather than this full screen.

| Reads | Writes |
|-------|--------|
| Old vs new forecast/recommendation | Optional saved insight |

**Why this matters to the parent:** Rewards logging with an immediate answer: what changed, why, and what to do now.

**Simple logic connection:**
- **Parent does →** Reads the result shown immediately after saving an update.
- **App learns / uses →** Compares the old output with the recalculated output.
- **Next effect →** Only show this screen when the new data materially changes a window, confidence, reason or action; otherwise show a simple Saved state.
- **Parent benefit →** Parent sees the direct reward for logging: what changed, why it changed and what to do.

---

## Sleep Experience (23–27)

### Screen 23 | Sleep Forecast

**Section:** Sleep Experience
**Flow:** Today View details → Sleep Forecast → Sleep Details (p24)

**Purpose:** Primary detailed sleep screen showing the next sleep window, confidence, reason and tonight's plan.

**Tap / Interaction Contract:**
- **Day selector** → Change day only where historical/future guidance exists; default Today. → Stay
  - *Data/state:* selectedDate local state
- **Plan step row** → Open the detailed Tonight Plan if the step is tappable. → Tonight Plan (p25)
- **View details** → Open Sleep Details. → Sleep Details (p24)
- **Child/profile controls** → Use the same profile routes as Today. → p59/p60

**Logic Hardik should implement:**
- Forecast should be based on child age, baseline and recent sleep logs.
- Always show a confidence label. Wider windows are required when confidence is low (see p69).
- The reason text should be generated from specific inputs, not generic filler.

| Reads | Writes |
|-------|--------|
| Child age; sleep logs; forecast output; timezone | None |

**Why this matters to the parent:** Replaces a stopwatch with a useful answer: the likely next window and the reason behind it.

**Simple logic connection:**
- **Parent does →** Checks the next sleep window and today's plan.
- **App learns / uses →** Uses age + real sleep history + today's sleep updates + time zone.
- **Next effect →** Produces the next window, confidence, reason and plan; notification timing can follow the wind-down window if enabled.
- **Parent benefit →** Answers the practical question: 'When should I start getting my child ready for sleep?'

---

### Screen 24 | Sleep Details

**Section:** Sleep Experience
**Flow:** Sleep Forecast (p23) → Sleep Details → Tonight Plan (p25) or Sleep Update

**Purpose:** Explain the sleep forecast with the specific recent sleep information behind it.

**Tap / Interaction Contract:**
- **Update sleep** → Open Sleep Update. → Sleep Update (p17)
- **View tonight's plan** → Open the detailed plan. → Tonight Plan (p25)
- **Back** → Return to Sleep Forecast. → Sleep Forecast (p23)

**Logic Hardik should implement:**
- Display actual recent timestamps and derived sleep duration.
- *Why we expect it* should use only factors that genuinely influenced the forecast.
- *What could change this* warns that illness/travel/context can make the estimate less reliable.

| Reads | Writes |
|-------|--------|
| Latest sleep log; previous night; forecast explanation | None |

**Why this matters to the parent:** Builds trust because the parent can see why LovingBrain is making the recommendation.

**Simple logic connection:**
- **Parent does →** Opens View details or updates sleep.
- **App learns / uses →** Shows the exact inputs behind the forecast rather than hiding the logic.
- **Next effect →** New sleep data recalculates the forecast; Tonight's Plan uses the current forecast.
- **Parent benefit →** Builds trust because the parent can see why LovingBrain made the prediction.

---

### Screen 25 | Tonight's Plan

**Section:** Sleep Experience
**Flow:** Sleep Details (p24) → Tonight's Plan → Stay / back to Sleep Details

**Purpose:** Turn the predicted window into a simple sequence the parent can follow tonight.

**Tap / Interaction Contract:**
- **Start plan** → Mark the plan as started and show a lightweight confirmation. No separate active-plan UI is provided in Deepak's file, so remain on this screen. → Stay
  - *Data/state:* planStartedAt
- **Play audio** → Play the calm sleep audio in place. → Stay
  - *Data/state:* Audio event
- **Back** → Return to Sleep Details. → Sleep Details (p24)

**Logic Hardik should implement:**
- Do not auto-navigate to Sleep Pattern when Start Plan is tapped; that is prototype wiring, not sensible product behavior.
- Plan times should shift when forecast changes.
- Do not make the parent manually check off every step unless that is later designed.

| Reads | Writes |
|-------|--------|
| Current forecast; recommended routine | Optional plan-start event |

**Why this matters to the parent:** Converts prediction into an actionable bedtime routine instead of leaving the parent with a time estimate only.

**Simple logic connection:**
- **Parent does →** Starts the plan or plays the audio guide.
- **App learns / uses →** Uses the current predicted sleep window to generate a simple pre-sleep sequence.
- **Next effect →** Plan steps stay aligned with the latest window; a major new sleep update can refresh the plan rather than silently using stale times.
- **Parent benefit →** Turns prediction into something the parent can actually do tonight.

---

### Screen 26 | Sleep Pattern

**Section:** Sleep Experience
**Flow:** Sleep Details → Sleep Pattern → What We're Trying (p40) / Program Recommendation (p27)

**Purpose:** Show a simple weekly trend and one meaningful pattern noticed from recent sleep logs.

**Tap / Interaction Contract:**
- **Try this change** → Start/open the recommended weekly experiment. → What We're Trying (p40)
  - *Data/state:* Active experiment if accepted
- **Back** → Return to Sleep Details. → Sleep Details (p24)

**Logic Hardik should implement:**
- Do not show a chart until enough real data exists.
- The written pattern is more important than the graph: explain what changed and why it matters.
- If the pattern has persisted long enough to justify guided support, p27 may be offered after this screen.

| Reads | Writes |
|-------|--------|
| Aggregated sleep logs; pattern output | Optional experiment acceptance |

**Why this matters to the parent:** Parents see progress and patterns without having to interpret raw sleep logs themselves.

**Simple logic connection:**
- **Parent does →** Reviews weekly sleep pattern and taps Try this change.
- **App learns / uses →** Aggregates repeated sleep data rather than reacting to one night.
- **Next effect →** Creates one small experiment/recommendation and can feed Journey/weekly review.
- **Parent benefit →** Helps the parent understand the pattern behind repeated difficult evenings.

---

### Screen 27 | Program Recommendation / Program List

**Section:** Sleep Experience
**Flow:** Sleep Pattern / Today support prompt → Program Recommendation / Program List → Program Detail (p44) or Mentorship Landing

**Purpose:** Present structured support when self-guided changes have not settled the pattern.

**Tap / Interaction Contract:**
- **Category filter** → Filter available programs by topic. → Stay
  - *Data/state:* Local filter state
- **View program** → Open the selected program detail. Current detailed template exists for 6-Week Sleep Journey. → Program Detail (p44)
- **View All programs** → Open Guided Mentorship/program landing. → Mentorship Landing (p43)
- **Not now** → Return to Sleep Pattern/Today and apply a cooldown before recommending again. → Sleep Pattern / Today
  - *Data/state:* recommendationDismissedAt
- **Back** → Return to Sleep Details. → Sleep Details (p24)

**Logic Hardik should implement:**
- The four Sleep Restore cards appear to be placeholder duplicates in the design; backend content should provide real program records rather than hard-code duplicates.
- Recommendation reason should come from actual observed persistence.

| Reads | Writes |
|-------|--------|
| Program catalogue; sleep pattern; eligibility/availability | Dismissal or selected program |

**Why this matters to the parent:** Offers deeper support at the moment a parent has evidence that small changes alone are not enough.

**Simple logic connection:**
- **Parent does →** Reviews recommended programs and opens one if needed.
- **App learns / uses →** Uses persistent sleep/behaviour need plus program eligibility/availability.
- **Next effect →** Shows the most relevant structured support; it should not be triggered by a single bad day.
- **Parent benefit →** Parents who need more than self-guided tips can see a clear next level of support.

---

## Tantrum Support (28–31)

### Screen 28 | Calm Heads-Up

**Section:** Tantrum Support
**Flow:** Today Heads-up → Calm Heads-Up → Calm Plan (p29)

**Purpose:** Detailed pre-tantrum risk view showing the likely difficult window and the signals behind it.

**Tap / Interaction Contract:**
- **See calm plan** → Open the in-the-moment prevention plan. → Calm Plan (p29)
- **Add update** → Open Check-in Menu to add new context. → Check-in Menu (p16)
- **Back** → Return to Today. → Today (p12/p14)

**Logic Hardik should implement:**
- Use probabilistic language: *may be more likely*, not *will happen*.
- Show confidence and the two or three strongest input signals.
- The time window should update when new sleep/mood/context information arrives.

| Reads | Writes |
|-------|--------|
| Behaviour-risk output; recent sleep/context | None |

**Why this matters to the parent:** Gives parents a chance to reduce triggers before a hard moment starts.

**Simple logic connection:**
- **Parent does →** Opens the Calm Heads-Up and views the predicted difficult window.
- **App learns / uses →** Combines recent sleep, mood/context, logged tantrums, known triggers and time-of-day patterns.
- **Next effect →** Returns a LOW/MODERATE/HIGH-style confidence, likely window and strongest reasons. New inputs can move or remove the window. Notifications are only for useful future heads-ups, never certainty claims.
- **Parent benefit →** Gives the parent advance warning with an explanation they can understand.

---

### Screen 29 | Calm Plan

**Section:** Tantrum Support
**Flow:** Calm Heads-Up (p28) → Calm Plan → Reflection (p31) / Brainy

**Purpose:** Give three simple things to do now, one thing to avoid and an optional calming audio.

**Tap / Interaction Contract:**
- **Calm audio guide** → Play the 3-minute guide in place. → Stay
  - *Data/state:* Audio event
- **Tell us what happened** → Open after-the-moment reflection/log. → Reflection (p31)
- **Ask Brainy** → Open Brainy with the current heads-up attached as context. → Brainy Home/Conversation (p32-p33)
- **Back** → Return to Calm Heads-Up. → p28

**Logic Hardik should implement:**
- Keep actions short and immediately doable.
- Advice must match the detected context and child age; do not show a generic three-step list for every situation if the backend has more specific rules.

| Reads | Writes |
|-------|--------|
| Current heads-up and recommended plan | Audio engagement event only |

**Why this matters to the parent:** Removes decision load at the exact moment a parent is likely to feel overwhelmed.

**Simple logic connection:**
- **Parent does →** Follows the calm plan, plays audio, reports what happened or asks Brainy.
- **App learns / uses →** Uses the current risk context to choose a few low-effort preventive actions.
- **Next effect →** If the parent later reports what happened, that outcome feeds behaviour learning; Brainy receives the same relevant context.
- **Parent benefit →** Parent gets immediate, practical help rather than a prediction with no action.

---

### Screen 30 | Behaviour Pattern

**Section:** Tantrum Support
**Flow:** Calm Plan / Journey → Behaviour Pattern → Calm Plan or Mentorship

**Purpose:** Summarise repeated difficult moments into common times, possible trigger combinations and what has helped.

**Tap / Interaction Contract:**
- **Try this plan** → Open the relevant Calm Plan / weekly strategy. → Calm Plan (p29) or active experiment
- **View mentorship** → Open Guided Mentorship with behaviour context. → Mentorship Landing (p43)
- **Back** → Return to Calm Plan/Today. → p29 / Today

**Logic Hardik should implement:**
- Only show claims supported by enough logged events.
- Use wording such as *possible triggers* and *often* rather than causal claims.
- *What has helped* should be based on parent-reported responses that repeatedly correlate with better outcomes.

| Reads | Writes |
|-------|--------|
| Aggregated TantrumLogs; mood/sleep context | None |

**Why this matters to the parent:** Helps parents learn their own child's patterns rather than receiving generic tantrum advice.

**Simple logic connection:**
- **Parent does →** Reviews common times, triggers and what has helped.
- **App learns / uses →** Aggregates repeated tantrum/behaviour logs and related context.
- **Next effect →** Updates only when enough repeated evidence exists; can suggest one plan or mentorship if the pattern persists.
- **Parent benefit →** Shows the parent their child's recurring pattern instead of blaming a single event.

---

### Screen 31 | After-the-Moment Reflection

**Section:** Tantrum Support
**Flow:** Calm Plan (p29) → After-the-Moment Reflection → Behaviour Pattern / Today

**Purpose:** Capture a short debrief after a difficult moment to improve future pattern recognition.

**Tap / Interaction Contract:**
- **What happened before** → Enter/select the immediate preceding event. → Stay
  - *Data/state:* beforeEvent
- **Duration** → Select/enter approximate duration. → Stay
  - *Data/state:* duration
- **Intensity** → Set intensity. → Stay
  - *Data/state:* intensity
- **What helped** → Select one or more responses. → Stay
  - *Data/state:* helped[]
- **Parent feeling** → Optional private parent state. → Stay
  - *Data/state:* parentState
- **Save reflection** → Save and update behaviour pattern statistics. → Behaviour Pattern (p30) or Today
  - *Data/state:* Tantrum reflection
- **Skip** → Exit without saving the optional reflection. → Today / Calm Heads-Up

**Logic Hardik should implement:**
- Do not shame the parent for skipping.
- Parent feeling remains private and is not shared with caregivers.
- This can enrich an existing TantrumLog or create a completed-event record.

| Reads | Writes |
|-------|--------|
| Current/recent tantrum event | Reflection fields; updated behaviour pattern |

**Why this matters to the parent:** Turns a difficult event into useful learning while it is still fresh, without asking for a long journal entry.

**Simple logic connection:**
- **Parent does →** After a hard moment, records what happened before, duration, intensity and what helped.
- **App learns / uses →** Adds outcome data that tells the app whether the earlier risk signal and calming strategies matched reality.
- **Next effect →** Improves future behaviour patterns and heads-up reasoning; optional parent emotion can inform supportive Brainy wording but should not be shared automatically.
- **Parent benefit →** Turns a difficult moment into learning without requiring perfect recall.

---

## Brainy AI (32–36)

### Screen 32 | Brainy Home

**Section:** Brainy AI
**Flow:** Today / Calm Plan → Brainy Home → Conversation (p33), Saved (p35), History (p36)

**Purpose:** Context-aware AI entry point using the child's age, recent patterns and current family focus.

**Tap / Interaction Contract:**
- **Topic chip** → Set topic filter/context for suggested prompts. → Stay
  - *Data/state:* Local topic context
- **Suggested question** → Submit the suggested prompt immediately. → Loading (p65) → Conversation (p33)
  - *Data/state:* Conversation message
- **Ask Brainy text field** → Type and send a question. → Loading → Conversation
  - *Data/state:* Conversation message
- **Microphone** → First use: request p73 permission. If allowed, open voice input. → Voice Input (p34)
  - *Data/state:* Permission / voice draft
- **History** → Open conversation history. → Conversation History (p36)
- **Saved** → Open Saved Guidance. → Saved Guidance (p35)
- **Bottom nav** → Switch Today / Journey. → p12/p37

**Logic Hardik should implement:**
- Brainy should receive only the family context needed to answer the current question.
- Answers must separate *what may be happening*, *what to try now* and *when to get help* as designed.
- Safety-sensitive health messages must use the safety route p70.

| Reads | Writes |
|-------|--------|
| Profiles; recent relevant logs; active goal; conversation context | Conversation messages/history |

**Why this matters to the parent:** Parents do not have to re-explain age, recent sleep and current goals every time they ask for help.

**Simple logic connection:**
- **Parent does →** Opens Brainy, chooses a topic or asks a question.
- **App learns / uses →** Loads only relevant child age, recent context and current focus needed for that conversation.
- **Next effect →** Suggested prompts change with today's context; Brainy answers with relevant family information instead of generic chat.
- **Parent benefit →** Parent can ask 'what do I do now?' without explaining the family from scratch.

---

### Screen 33 | Brainy Conversation / Answer

**Section:** Brainy AI
**Flow:** Brainy Home / Loading → Brainy Conversation / Answer → Follow-up / Voice / Brainy Home

**Purpose:** Display a structured answer that explains the likely pattern, gives one action and shows when professional help may be appropriate.

**Tap / Interaction Contract:**
- **Reply field** → Type a follow-up and send. → Loading → refreshed Conversation
  - *Data/state:* Conversation message
- **Microphone if available** → Open Voice Input. → p34
  - *Data/state:* Voice draft
- **Back** → Return to Brainy Home while preserving conversation. → p32

**Logic Hardik should implement:**
- Ground the answer in visible recent data when referenced.
- Never invent log facts.
- Safety check every message before normal generation.
- If the design includes a save affordance, saving should create a Saved Guidance record visible on p35.

| Reads | Writes |
|-------|--------|
| Conversation; relevant family context | Conversation history; optional saved guidance |

**Why this matters to the parent:** Provides a concise answer connected to the child's actual recent pattern, not generic chatbot text.

**Simple logic connection:**
- **Parent does →** Reads Brainy's answer and can reply or save it.
- **App learns / uses →** Uses the question + allowed family context + safety rules.
- **Next effect →** Produces a structured answer: what may be happening, what to try, when to get help. Saved answers appear in Saved Guidance.
- **Parent benefit →** Makes AI advice easier to act on and safer to interpret.

---

### Screen 34 | Voice Input

**Section:** Brainy AI
**Flow:** Brainy Home / Conversation → Voice Input → Conversation (p33)

**Purpose:** Let the parent ask Brainy a question hands-free while preserving control over recording.

**Tap / Interaction Contract:**
- **Cancel** → Stop recording and discard the unsent voice draft. → Conversation / Brainy Home
- **Send** → Stop recording, transcribe/submit the message, then show loading and answer. → Loading (p65) → Conversation (p33)
  - *Data/state:* Conversation message

**Logic Hardik should implement:**
- Record only while the recording interaction is active as the permission explainer states.
- Show transcript before/while sending if transcription is available.
- Do not route Send to Saved Guidance; that is Figma prototype wiring, not intended conversation flow.

| Reads | Writes |
|-------|--------|
| Microphone permission | Voice/transcribed conversation message |

**Why this matters to the parent:** Useful when the parent is holding or settling a child and cannot type.

**Simple logic connection:**
- **Parent does →** Speaks a question instead of typing.
- **App learns / uses →** Captures speech only after microphone permission; converts it to text for the same Brainy flow.
- **Next effect →** The transcript is shown/confirmed before sending where practical; cancelling sends nothing.
- **Parent benefit →** Useful when a parent is holding a child and cannot type.

---

### Screen 35 | Saved Guidance

**Section:** Brainy AI
**Flow:** Brainy Home → Saved Guidance → Saved answer / Brainy Home

**Purpose:** Keep the few AI answers the parent intentionally saved for easy reuse.

**Tap / Interaction Contract:**
- **Saved item** → Open the saved answer/conversation detail. → Conversation/answer detail (p33)
- **Back** → Return to Brainy Home. → p32

**Logic Hardik should implement:**
- Saved guidance is user-curated, not every chat automatically.
- Group by topic as designed.
- If a source conversation expires after 90 days, the saved guidance should remain only if product policy allows it.

| Reads | Writes |
|-------|--------|
| SavedGuidance records | None |

**Why this matters to the parent:** Parents can return to advice that worked without searching through chat history.

**Simple logic connection:**
- **Parent does →** Opens a previously saved Brainy answer.
- **App learns / uses →** Reads only guidance the parent deliberately saved.
- **Next effect →** Lets the parent revisit useful advice without searching conversation history.
- **Parent benefit →** Creates a small personal reference library rather than another content feed.

---

### Screen 36 | Conversation History

**Section:** Brainy AI
**Flow:** Brainy Home → Conversation History → Conversation / Brainy Home

**Purpose:** List previous Brainy conversations by recency.

**Tap / Interaction Contract:**
- **Conversation row** → Open that conversation thread. → Conversation (p33)
- **Back** → Return to Brainy Home. → p32

**Logic Hardik should implement:**
- The design states conversations are kept for 90 days. Implement retention/clearing consistently with Privacy & Data.
- Do not expose another caregiver's private conversations.

| Reads | Writes |
|-------|--------|
| Conversation metadata limited to current parent | None |

**Why this matters to the parent:** Lets the parent continue a useful conversation without treating Brainy as permanent medical history.

**Simple logic connection:**
- **Parent does →** Opens an earlier Brainy conversation.
- **App learns / uses →** Uses the parent's conversation history within the displayed retention policy.
- **Next effect →** Reopens context while respecting privacy/retention; other caregivers' private chats are not mixed in.
- **Parent benefit →** Parent can continue useful support without repeating the same story.

---

## Journey (37–42)

### Screen 37 | Journey Home

**Section:** Journey
**Flow:** Bottom nav / program → Journey Home → p38/p39/p49/p35

**Purpose:** Show how the family is changing over time: weekly review, active program, saved guidance and timeline.

**Tap / Interaction Contract:**
- **Open review** → Open current Weekly Review. → Weekly Review (p38)
- **6-Week Sleep Journey row** → If enrolled, open journey progress; if not enrolled, open program detail. → Enrolled Journey (p49) / Program Detail (p44)
- **Saved guidance** → Open Saved Guidance. → p35
- **Family timeline / View full story** → Open Family Timeline. → p39
- **Bottom nav** → Switch Today / Brainy AI. → p12/p32

**Logic Hardik should implement:**
- Journey is the longitudinal view; it should not duplicate Today.
- Only show modules that exist for this family (for example program row only when relevant).

| Reads | Writes |
|-------|--------|
| WeeklyReview; enrollment; saved guidance; timeline events | None |

**Why this matters to the parent:** Helps parents notice progress and patterns that are hard to see day by day.

**Simple logic connection:**
- **Parent does →** Opens Journey and chooses weekly review, active program, saved guidance or timeline.
- **App learns / uses →** Aggregates meaningful changes across sleep, behaviour, experiments and mentorship.
- **Next effect →** Journey shows progress/history, not raw tap-by-tap logs.
- **Parent benefit →** Parents see whether things are actually changing over time.

---

### Screen 38 | Weekly Family Review

**Section:** Journey
**Flow:** Journey Home → Weekly Family Review → What We're Trying / Brainy

**Purpose:** Summarise one positive change, one continuing difficulty and one useful pattern from the week.

**Tap / Interaction Contract:**
- **Try the recommendation** → Open/start the recommended one-week experiment. → What We're Trying (p40)
  - *Data/state:* ActiveExperiment
- **Ask Brainy about this week** → Open Brainy with the weekly review attached as context. → Brainy Home/Conversation (p32-p33)
  - *Data/state:* Conversation context
- **Back** → Return to Journey Home. → p37

**Logic Hardik should implement:**
- Generate only after enough weekly data exists.
- Use real comparisons (e.g. settling time) and avoid overclaiming.
- One focus is better than multiple recommendations.

| Reads | Writes |
|-------|--------|
| Aggregated weekly sleep/behaviour data | Optional experiment start / AI context |

**Why this matters to the parent:** Parents get a simple interpretation of the week instead of raw charts and logs.

**Simple logic connection:**
- **Parent does →** Reads the week's positive change, continuing difficulty and useful pattern.
- **App learns / uses →** Compares this week's meaningful metrics/patterns with prior weeks.
- **Next effect →** Creates one focus/recommendation for the next week and can pass the summary to Brainy.
- **Parent benefit →** Turns a week of messy parenting data into a short, understandable review.

---

### Screen 39 | Family Timeline

**Section:** Journey
**Flow:** Journey Home → Family Timeline → Relevant detail / Journey

**Purpose:** Chronological history of meaningful LovingBrain events and progress.

**Tap / Interaction Contract:**
- **Filter chips** → Filter All / Sleep / Behaviour / Mentorship. → Stay
  - *Data/state:* Local filter
- **Timeline item** → Open the related detail when available (program, weekly review or pattern). → Relevant detail
- **Back** → Return to Journey Home. → p37

**Logic Hardik should implement:**
- Timeline should contain meaningful milestones in the app experience, not every individual log.
- Use event type + timestamp + related object ID.

| Reads | Writes |
|-------|--------|
| TimelineEvent records | None |

**Why this matters to the parent:** Shows the family story and progress without requiring a manual journal.

**Simple logic connection:**
- **Parent does →** Filters the family timeline by sleep, behaviour or mentorship.
- **App learns / uses →** Reads milestone-like PRODUCT events such as first recognised pattern, plan change or program progress - not child developmental milestones.
- **Next effect →** Adds events only when something meaningful changes.
- **Parent benefit →** Gives the family a clean story of progress without becoming a journal.

---

### Screen 40 | What We're Trying This Week

**Section:** Journey
**Flow:** Weekly Review / Sleep Pattern → What We're Trying This Week → Check-in or Journey

**Purpose:** Track one active behaviour/sleep experiment and what the parent should observe.

**Tap / Interaction Contract:**
- **Add update** → Open Check-in Menu or the most relevant update form. → p16 / relevant form
- **Finish early** → End the experiment and trigger a short review/result state. → Weekly Review/Journey
  - *Data/state:* experiment status=end
- **Back** → Return to Journey. → p37

**Logic Hardik should implement:**
- Do not require extra logging beyond usual check-ins, as the screen promises.
- At the review date compare the observed outcome with the baseline and create a Journey event.

| Reads | Writes |
|-------|--------|
| ActiveExperiment; related logs | Experiment progress/status |

**Why this matters to the parent:** Makes advice testable: one small change, one thing to watch, one review date.

**Simple logic connection:**
- **Parent does →** Follows one small change for a defined number of days and adds updates as usual.
- **App learns / uses →** Tracks the experiment, start date, observation target and normal related logs.
- **Next effect →** At review date, compare the relevant outcome and decide whether to continue, change or stop the experiment.
- **Parent benefit →** Parents test one change at a time instead of receiving many conflicting tips.

---

### Screen 41 | Harder Week Review

**Section:** Journey
**Flow:** Journey weekly review → Harder Week Review → Brainy / Journey

**Purpose:** Weekly review state for a week disrupted by travel or another context change.

**Tap / Interaction Contract:**
- **Talk to Brainy about this** → Open Brainy with this week's disruption attached. → p32/p33
  - *Data/state:* Conversation context
- **Back to Journey** → Return to Journey Home. → p37

**Logic Hardik should implement:**
- A harder week should not be framed as failure.
- Context such as travel should reduce confidence in normal pattern comparisons.

| Reads | Writes |
|-------|--------|
| Weekly data; context flags | Optional AI context |

**Why this matters to the parent:** Reassures the parent while still explaining the useful pattern that changed.

**Simple logic connection:**
- **Parent does →** Reads a harder-week summary and chooses Brainy or returns to Journey.
- **App learns / uses →** Detects that context such as travel disrupted the usual pattern.
- **Next effect →** Explains the deviation without calling it failure; the next recommendation should account for the temporary context.
- **Parent benefit →** Reduces guilt and prevents overreacting to one difficult week.

---

### Screen 42 | Consistency Recognition

**Section:** Journey
**Flow:** Weekly review completion → Consistency Recognition → Journey Home

**Purpose:** Acknowledge the parent's effort without creating a streak they can fail.

**Tap / Interaction Contract:**
- **Back to Journey** → Return to Journey Home. → p37

**Logic Hardik should implement:**
- Trigger based on meaningful check-in participation, not perfect daily completion.
- Do not send guilt-based missed-day notifications.

| Reads | Writes |
|-------|--------|
| Weekly check-in count | Recognition seen state (optional) |

**Why this matters to the parent:** Reinforces helpful participation without turning parenting into a score.

**Simple logic connection:**
- **Parent does →** Sees recognition for showing up during the week.
- **App learns / uses →** Counts useful check-ins for positive feedback only; it is not a punitive streak.
- **Next effect →** No 'streak lost' notifications. The app simply acknowledges consistent data that made patterns possible.
- **Parent benefit →** Encourages engagement without making exhausted parents feel they failed.

---

## Guided Mentorship (43–53)

### Screen 43 | Guided Mentorship Landing

**Section:** Guided Mentorship
**Flow:** Program Recommendation / Behaviour Pattern / Journey → Guided Mentorship Landing → Program Detail or support selection

**Purpose:** Explain the human-support layer and show available support areas/programs.

**Tap / Interaction Contract:**
- **Sleep Reset** → Open the 6-Week Sleep Journey detail. → Program Detail (p44)
- **Tantrum Understanding** → Open matching program/support detail when available. No separate detail design supplied. → Template/detail - design gap
- **Parent Calm & Confidence** → Open matching support detail when available. → Template/detail - design gap
- **Co-parenting Support** → Open matching support detail when available. → Template/detail - design gap
- **Human support card** → Open support-area selection. → Choose Support Area (p45)

**Logic Hardik should implement:**
- This screen is a directory, not a medical consultation screen.
- Only show programs/mentor categories that are actually available.
- For categories without a dedicated Figma detail, reuse the agreed program-detail template only after content is approved.

| Reads | Writes |
|-------|--------|
| Program/support catalogue and availability | None |

**Why this matters to the parent:** Gives parents a clear path to real human support when the app alone is not enough.

**Simple logic connection:**
- **Parent does →** Opens Guided Mentorship and chooses the area where human help is needed.
- **App learns / uses →** Uses the selected support area and existing family context to narrow relevant programs/mentors.
- **Next effect →** Routes to structured program detail or mentor matching; this is human guidance, not automatic medical consultation.
- **Parent benefit →** Makes it easy to move from app guidance to a real experienced person when needed.

---

### Screen 44 | 6-Week Sleep Journey - Program Detail

**Section:** Guided Mentorship
**Flow:** Mentorship Landing / Program List → 6-Week Sleep Journey - Program Detail → Choose Support / Guide Profile

**Purpose:** Explain who the structured program is for, expected outcome and support format before the parent chooses a guide.

**Tap / Interaction Contract:**
- **View available guides** → Open support selection with Sleep guidance preselected, then matched guide(s). → Choose Support (p45) → Guide Profile (p46)
  - *Data/state:* selectedSupport=sleep
- **Ask Brainy whether this fits** → Open Brainy with program details and current sleep pattern context. → p32/p33
  - *Data/state:* AI context
- **Back** → Return to Mentorship Landing/Program List. → p43/p27

**Logic Hardik should implement:**
- Do not promise a specific result; preserve the design disclaimer.
- Eligibility language can use recent sleep duration/persistence but must not block parents from viewing support.

| Reads | Writes |
|-------|--------|
| Program content; family sleep pattern | Selected program/support context |

**Why this matters to the parent:** Helps parents understand the commitment before they spend money or book a mentor.

**Simple logic connection:**
- **Parent does →** Reviews the 6-week sleep program and taps View available guides.
- **App learns / uses →** Checks whether the parent's sleep issue and program state fit the program.
- **Next effect →** Moves to compatible guides; Brainy can explain fit but cannot promise outcomes.
- **Parent benefit →** Parent understands exactly who the program is for and what commitment it involves.

---

### Screen 45 | Choose a Support Area

**Section:** Guided Mentorship
**Flow:** Program Detail / Mentorship Landing → Choose a Support Area → Guide Profile / guide list

**Purpose:** Match the parent to the right mentor/support type using one simple category choice.

**Tap / Interaction Contract:**
- **Support option** → Select one support category. → Stay
  - *Data/state:* selectedSupportArea
- **Continue** → Show matching available guide(s). Current final design includes a Guide Profile but no separate multi-guide list. → Guide Profile (p46) for MVP / guide list later
  - *Data/state:* Selected support area
- **Back** → Return to program/mentorship landing. → p43/p44

**Logic Hardik should implement:**
- Language preference and support area should filter mentors.
- If more than one mentor is available, a guide-list screen is required but is not supplied in this final PDF; this is a known design gap.

| Reads | Writes |
|-------|--------|
| Parent language; mentor availability; support catalogue | selectedSupportArea |

**Why this matters to the parent:** Reduces the work of choosing from many experts and keeps matching relevant.

**Simple logic connection:**
- **Parent does →** Chooses Sleep, Behaviour, Parent wellbeing, Co-parenting or General parenting support.
- **App learns / uses →** Creates the mentor-matching category.
- **Next effect →** Filters guide profiles and pre-fills the session concern; it does not change the child's prediction engine by itself.
- **Parent benefit →** Parents see people relevant to the problem they want help with.

---

### Screen 46 | Guide Profile

**Section:** Guided Mentorship
**Flow:** Choose Support → Guide Profile → Request Session (p47)

**Purpose:** Build trust by showing the mentor's experience, languages, support areas and expected session length.

**Tap / Interaction Contract:**
- **Request a session** → Open the request form prefilled with child age, concern and language. → Request Session (p47)
  - *Data/state:* selectedGuideId
- **View Sleep Reset programme** → Open Program Detail. → p44
- **Back** → Return to guide selection/support area. → p45

**Logic Hardik should implement:**
- Verified badge should only appear after internal verification.
- Keep claims factual: experience, languages and style; do not imply clinical treatment if the role is mentorship.

| Reads | Writes |
|-------|--------|
| Mentor profile; verification; availability estimate | selectedGuideId |

**Why this matters to the parent:** Parents can choose a person based on trust, fit and language rather than a generic support inbox.

**Simple logic connection:**
- **Parent does →** Reviews a guide's experience, languages and support areas and requests a session.
- **App learns / uses →** Uses support category + language + guide availability/profile.
- **Next effect →** Routes to request/booking for that guide; external calendar can be used instead of building scheduling inside LovingBrain.
- **Parent benefit →** Builds trust before the parent commits time or money.

---

### Screen 47 | Request a Session

**Section:** Guided Mentorship
**Flow:** Guide Profile → Request a Session → Confirmation / external calendar

**Purpose:** Collect only the information the mentor needs to accept a session request, with optional LovingBrain summary sharing.

**Tap / Interaction Contract:**
- **Editable fields** → Parent can adjust concern, preferred times and language. Child age is pulled from profile. → Stay
  - *Data/state:* request draft
- **Summary sharing toggle** → Allow/disable sharing the recent LovingBrain summary with this mentor. → Stay
  - *Data/state:* shareRecentSummary
- **Send request** → Create mentorship request and show confirmation. → Request Confirmation (p48)
  - *Data/state:* MentorshipRequest
- **Schedule directly via calendar link** → Open the mentor's approved external scheduling link. Preserve selected guide and return state. → Third-party calendar
  - *Data/state:* External booking event
- **Back** → Return to Guide Profile. → p46

**Logic Hardik should implement:**
- Do not send private parent reflections unless explicitly included in the approved summary design.
- If using an external calendar, do not build duplicate scheduling logic in the app.
- Prevent double booking/request spam for the same slot/mentor.

| Reads | Writes |
|-------|--------|
| Child age; main concern; parent language; guide ID | MentorshipRequest; summary-sharing consent |

**Why this matters to the parent:** The parent does not have to repeat the family story, but remains in control of what is shared.

**Simple logic connection:**
- **Parent does →** Confirms concern, child age, preferred time/language and sends request or uses the guide's calendar.
- **App learns / uses →** Creates the session request and, only with consent, prepares a recent LovingBrain summary for the mentor.
- **Next effect →** Mentor/admin receives the request or external scheduler handles time selection. No charge/confirmation should be assumed until the booking flow says so.
- **Parent benefit →** Parent avoids explaining two weeks of sleep history from scratch.

---

### Screen 48 | Session Request Confirmation

**Section:** Guided Mentorship
**Flow:** Request Session → Session Request Confirmation → Journey / request status

**Purpose:** Confirm the request and explain what happens next while reassuring the parent that nothing has been charged yet.

**Tap / Interaction Contract:**
- **Back to Journey** → Return to Journey Home. → p37
- **View your request** → Open request status. A dedicated request-status screen is not supplied; reuse current status/Parent Success Guide once assigned. → Request status / p51 after assignment

**Logic Hardik should implement:**
- Keep logging prompt is useful because recent data can give the mentor context.
- Payment status must reflect the actual commercial flow.
- This state should update when the mentor confirms/declines.

| Reads | Writes |
|-------|--------|
| MentorshipRequest status | None |

**Why this matters to the parent:** Removes uncertainty after booking: the parent knows the request was received and what to do next.

**Simple logic connection:**
- **Parent does →** Sees that the request was sent and can view status or return to Journey.
- **App learns / uses →** Stores request status and whether summary sharing was enabled.
- **Next effect →** Future status changes can trigger mentorship notifications only if enabled.
- **Parent benefit →** Removes uncertainty about whether the request went through.

---

### Screen 49 | Enrolled Sleep Reset Journey

**Section:** Guided Mentorship
**Flow:** Journey / enrolment → Enrolled Sleep Reset Journey → Module/session / Journey

**Purpose:** Home for an active structured sleep program: this week's focus, next session, recorded module and mentor note.

**Tap / Interaction Contract:**
- **Next session** → Open external booking/session details or calendar link. → External calendar/session details
- **Recorded module** → Open the recorded module player/content screen. → Module player - not separately designed
  - *Data/state:* Module progress
- **Back** → Return to Journey Home. → p37

**Logic Hardik should implement:**
- Progress is program-week based, not a generic course percentage.
- Mentor notes should be read-only here unless a reply flow is separately designed.
- Recorded module completion can update program progress.

| Reads | Writes |
|-------|--------|
| ProgramEnrollment; session; module; mentor note | Module/session progress events |

**Why this matters to the parent:** Keeps the parent focused on only the next useful step in a multi-week program.

**Simple logic connection:**
- **Parent does →** Follows the active Sleep Reset journey, opens the next session or recorded module.
- **App learns / uses →** Reads program week, mentor message, module completion and plan state.
- **Next effect →** Progress feeds Journey; session/module completion advances only according to program rules, not just app opens.
- **Parent benefit →** Keeps a multi-week program simple and shows what to do next.

---

### Screen 50 | Post-Session Plan

**Section:** Guided Mentorship
**Flow:** Mentor session / Program Journey → Post-Session Plan → Journey / request detail

**Purpose:** Show the small plan agreed with the mentor after a session.

**Tap / Interaction Contract:**
- **Plan task circle** → If task completion is supported, toggle completion; otherwise display read-only status from logs. → Stay
  - *Data/state:* Plan task status
- **Back to Journey** → Return to Journey. → p37
- **View your request** → Open current mentor/request details. → Request status

**Logic Hardik should implement:**
- Plan should be created/updated by approved mentor workflow or internal admin process, not generated as medical instruction.
- Some tasks can be automatically satisfied from normal logs (for example log three nights).

| Reads | Writes |
|-------|--------|
| MentorPlan; related logs | Task status if manual |

**Why this matters to the parent:** The parent leaves a conversation with a clear, simple plan rather than trying to remember everything discussed.

**Simple logic connection:**
- **Parent does →** Checks or completes the plan agreed with the mentor.
- **App learns / uses →** Stores human-authored tasks and completion evidence.
- **Next effect →** Normal sleep logs may mark relevant tasks as completed, but the app must not rewrite the mentor's plan automatically.
- **Parent benefit →** Parent leaves a session with a clear plan they can remember and follow.

---

### Screen 51 | Parent Success Guide

**Section:** Guided Mentorship
**Flow:** Journey / request status → Parent Success Guide → Request Session / Journey

**Purpose:** Persistent view of the assigned human guide, active goals and next recommended program step.

**Tap / Interaction Contract:**
- **Request a check-in** → Open request flow prefilled with assigned guide and current goals. → Request Session (p47)
  - *Data/state:* MentorshipRequest draft
- **Cancel this request** → Ask for confirmation, then cancel only the pending request. Confirmation UI is not separately designed. → Stay / Journey
  - *Data/state:* Request status=cancelled
- **Back** → Return to Journey. → p37

**Logic Hardik should implement:**
- One guide should not automatically gain access to private data beyond the explicit sharing consent.
- Active goals should match what was agreed with the parent.

| Reads | Writes |
|-------|--------|
| Assigned guide; active goals; enrollment; pending requests | New/cancelled request |

**Why this matters to the parent:** Creates continuity: one person knows the family context, so the parent does not start from zero each time.

**Simple logic connection:**
- **Parent does →** Views active goals and requests a check-in with the assigned guide.
- **App learns / uses →** Reads current program goals, tasks and assigned guide.
- **Next effect →** Routes check-in request to that guide and keeps the same human context across the program.
- **Parent benefit →** Parent has continuity instead of starting over with a different person each time.

---

### Screen 52 | Shared Child Summary

**Section:** Guided Mentorship
**Flow:** Family linked caregiver / Journey → Shared Child Summary → Permissions / Family

**Purpose:** Show the shared family view for a linked caregiver: today's plan, recent updates and current experiment.

**Tap / Interaction Contract:**
- **Manage access** → Open permissions for the linked caregiver. → Permissions (p58)
- **Back** → Return to Family/Journey depending entry point. → p54/p37

**Logic Hardik should implement:**
- Only show data types the linked caregiver is permitted to see.
- Health notes and mentorship summaries are private by default as the screen states.

| Reads | Writes |
|-------|--------|
| Caregiver permissions; Today plan; shared logs; active experiment | None |

**Why this matters to the parent:** Keeps parents/caregivers aligned without sharing everything.

**Simple logic connection:**
- **Parent does →** Views what a linked caregiver and the parent are both seeing.
- **App learns / uses →** Combines shared plan/log data according to permissions.
- **Next effect →** New permitted updates can appear for both caregivers and feed the same child pattern engine.
- **Parent benefit →** Everyone caring for the child can act from the same current plan.

---

### Screen 53 | Child Essentials

**Section:** Guided Mentorship
**Flow:** Child Profile / Shared Summary → Child Essentials → Item edit / back

**Purpose:** Store a small set of urgent child information such as allergies and medications for approved caregivers.

**Tap / Interaction Contract:**
- **Allergies / Medications** → Open item detail/edit. Detail screen is not supplied. → Item detail - design gap
  - *Data/state:* ChildEssential item
- **Add another item / Add item** → Open add-item form. Not separately designed. → Add form - design gap
  - *Data/state:* New ChildEssential
- **Back** → Return to Child Profile/shared family view. → p60/p52

**Logic Hardik should implement:**
- Keep this intentionally small; it is not a full medical record.
- Visibility must follow caregiver permissions.
- Sensitive edits should be auditable.

| Reads | Writes |
|-------|--------|
| ChildEssentials; caregiver permissions | ChildEssential records |

**Why this matters to the parent:** A caregiver can find the few critical facts quickly when they actually need them.

**Simple logic connection:**
- **Parent does →** Adds or views essential allergies/medications.
- **App learns / uses →** Stores a small set of urgent child facts, separate from a full medical record.
- **Next effect →** Only caregivers with permission can see them; they can be included in appropriate mentor context only with allowed sharing.
- **Parent benefit →** Important information is available quickly without turning LovingBrain into a medical-record system.

---

## Family Sharing (54–58)

### Screen 54 | Family Menu

**Section:** Family Sharing
**Flow:** Profile/Journey → Family Menu → Shared Summary / Invite flow

**Purpose:** Show linked and invited caregivers and explain that access is controlled by the parent.

**Tap / Interaction Contract:**
- **Linked caregiver row** → Open shared summary / access details. → Shared Summary (p52) / Permissions (p58)
- **Pending caregiver row** → Open Invite Pending. → p56
- **Invite a caregiver** → On first use show consent explainer, then invite form. → Consent (p74) → Invite (p55)
- **Back** → Return to previous profile/Journey entry point. → Previous

**Logic Hardik should implement:**
- Status must be live: linked, awaiting response, expired or removed.
- Never start sharing until the invite is accepted.

| Reads | Writes |
|-------|--------|
| Caregiver links/invites | None |

**Why this matters to the parent:** Makes multi-caregiver coordination visible and controllable.

**Simple logic connection:**
- **Parent does →** Views linked family members or starts a new caregiver invite.
- **App learns / uses →** Reads caregiver relationships and invite status.
- **Next effect →** Routes to invite/status/permissions; no family data is shared merely because an invite was created.
- **Parent benefit →** Parent can see exactly who is connected to the child's information.

---

### Screen 55 | Invite a Caregiver

**Section:** Family Sharing
**Flow:** Consent (p74) / Family → Invite a Caregiver → Invite Pending (p56)

**Purpose:** Invite a partner, grandparent, nanny or other caregiver and explain default privacy before sending.

**Tap / Interaction Contract:**
- **Email or phone** → Enter and validate contact. → Stay
  - *Data/state:* inviteRecipient
- **Relationship** → Select relationship. → Stay
  - *Data/state:* relationship
- **Send invite** → Create invite with default permissions based on relationship, then show Pending. → Invite Pending (p56)
  - *Data/state:* CaregiverInvite
- **Back** → Return to Family Menu. → p54

**Logic Hardik should implement:**
- Default grandparent access is sleep + plans only, as the design states.
- Do not share data before acceptance.
- If the contact already belongs to a linked caregiver, do not create a duplicate invite.

| Reads | Writes |
|-------|--------|
| Child ID; existing links | CaregiverInvite; default permission set |

**Why this matters to the parent:** Invites family help without forcing the parent to give away all private information.

**Simple logic connection:**
- **Parent does →** Enters caregiver contact and relationship and sends an invite.
- **App learns / uses →** Creates a pending invitation with default permissions based on relationship.
- **Next effect →** Nothing is shared until acceptance; after acceptance the server enforces the chosen permissions.
- **Parent benefit →** Makes shared care easy while preserving control.

---

### Screen 56 | Invite Pending

**Section:** Family Sharing
**Flow:** Invite Caregiver / Family → Invite Pending → Family or Accepted state when recipient joins

**Purpose:** Show that the invite is waiting, what will be shared after acceptance and when it expires.

**Tap / Interaction Contract:**
- **Resend invite** → Resend if allowed and update sent timestamp/expiry according to product policy. → Stay
  - *Data/state:* Invite metadata
- **Cancel invite** → Cancel and ensure no access is granted. → Family Menu (p54)
  - *Data/state:* Invite status=cancelled
- **Back** → Return to Family Menu. → p54

**Logic Hardik should implement:**
- Invites expire after 14 days according to the UI.
- Nothing should be shared while status is pending.

| Reads | Writes |
|-------|--------|
| CaregiverInvite | Resend/cancel metadata |

**Why this matters to the parent:** The parent can see and control an outstanding invitation instead of wondering whether sharing already started.

**Simple logic connection:**
- **Parent does →** Checks, resends or cancels a pending invite.
- **App learns / uses →** Tracks pending status and expiry.
- **Next effect →** No child data becomes visible while pending; cancel/expiry removes the pending access path.
- **Parent benefit →** Parent always knows whether someone actually has access.

---

### Screen 57 | Invite Accepted

**Section:** Family Sharing
**Flow:** Invite acceptance notification / Family → Invite Accepted → Permissions / Family

**Purpose:** Confirm that the caregiver joined and encourage the parent to review permissions.

**Tap / Interaction Contract:**
- **Manage permissions** → Open caregiver permissions. → Permissions (p58)
- **Back to Family** → Return to Family Menu. → p54
- **Caregiver row** → Open shared caregiver summary. → p52

**Logic Hardik should implement:**
- Acceptance should atomically create caregiver access using the invite's default permissions.
- Notify the inviting parent when acceptance occurs.

| Reads | Writes |
|-------|--------|
| Accepted invite; caregiver link | None |

**Why this matters to the parent:** Makes the new sharing relationship explicit and immediately reviewable.

**Simple logic connection:**
- **Parent does →** Sees that the caregiver accepted and chooses Manage permissions.
- **App learns / uses →** Converts the invite into an active caregiver link.
- **Next effect →** Only the approved data categories become accessible; parent can adjust immediately.
- **Parent benefit →** Clear confirmation prevents accidental oversharing.

---

### Screen 58 | Caregiver Permissions

**Section:** Family Sharing
**Flow:** Family / Accepted / Shared Summary → Caregiver Permissions → Family / Shared Summary

**Purpose:** Let the parent choose exactly what a caregiver can see and remove access at any time.

**Tap / Interaction Contract:**
- **Permission toggle** → Toggle Sleep, Behaviour, Health notes, Plans or Mentorship summaries. → Stay
  - *Data/state:* Permission set
- **Save permissions** → Persist permissions and refresh caregiver access immediately. → Family / Shared Summary
  - *Data/state:* CaregiverPermission
- **Remove access** → Show confirmation, then revoke caregiver access immediately. → Family Menu (p54)
  - *Data/state:* CaregiverLink revoked
- **Back** → Return without discarding already saved values. → p54/p52

**Logic Hardik should implement:**
- Parent reflections are never shareable, as the design states.
- All backend reads for the caregiver must enforce permissions; hiding UI alone is not sufficient.

| Reads | Writes |
|-------|--------|
| Current CaregiverPermission | Permission changes / access revocation |

**Why this matters to the parent:** Parents get the benefit of shared care without losing privacy control.

**Simple logic connection:**
- **Parent does →** Turns caregiver access categories on/off and saves.
- **App learns / uses →** Stores server-side permission rules for Sleep, Behaviour, Health, Plans and Mentorship summaries.
- **Next effect →** Every future read must obey these permissions; parent reflections remain private regardless of toggles.
- **Parent benefit →** Family collaboration does not require giving away all personal information.

---

## Profile & Settings (59–63)

### Screen 59 | Parent Profile

**Section:** Profile & Settings
**Flow:** Today avatar / settings → Parent Profile → Previous

**Purpose:** Edit parent identity, preferred language and location/timezone.

**Tap / Interaction Contract:**
- **Edit fields** → Enable editing for name/language/location. → Stay
  - *Data/state:* Profile draft
- **Save changes** → Validate and persist changes; if timezone changed, recompute time-based displays. → Previous/Profile
  - *Data/state:* ParentProfile
- **Back** → Return to previous screen. → Previous

**Logic Hardik should implement:**
- Timezone change affects sleep windows and notification schedules.
- Language change should update future app content; existing stored data does not need rewriting.

| Reads | Writes |
|-------|--------|
| ParentProfile | ParentProfile |

**Why this matters to the parent:** Keeps personalisation and time-based guidance accurate as the parent's circumstances change.

**Simple logic connection:**
- **Parent does →** Edits parent name, language or time zone.
- **App learns / uses →** Updates parent-facing preferences and local time calculation.
- **Next effect →** Future UI language/time-based reminders use the new values; historical timestamps remain stored consistently.
- **Parent benefit →** Keeps guidance accurate when the parent's circumstances change.

---

### Screen 60 | Child Profile

**Section:** Profile & Settings
**Flow:** Today child pill / settings → Child Profile → Child Essentials / Previous

**Purpose:** Edit the child's core information, routines/concerns and access Child Essentials.

**Tap / Interaction Contract:**
- **Edit child fields** → Edit name, DOB, routines/concerns, location/timezone. → Stay
  - *Data/state:* ChildProfile draft
- **View/edit Child essentials** → Open Child Essentials. → p53
- **Save changes** → Persist and re-base age guidance if DOB changes. → Previous
  - *Data/state:* ChildProfile
- **Back** → Return to previous screen. → Previous

**Logic Hardik should implement:**
- DOB changes must trigger re-calculation of age-based guidance from the next calculation cycle.
- Changing routine concerns may update recommended focus but should not delete historical logs.

| Reads | Writes |
|-------|--------|
| ChildProfile | ChildProfile |

**Why this matters to the parent:** Keeps recommendations anchored to the correct child age and current family routine.

**Simple logic connection:**
- **Parent does →** Edits child details, DOB or routines/concerns.
- **App learns / uses →** Updates child age/baseline/profile context.
- **Next effect →** DOB changes re-base age guidance; current real logs should still remain the stronger behavioural/sleep evidence.
- **Parent benefit →** Advice stays appropriate as the child grows and routines change.

---

### Screen 61 | Notifications

**Section:** Profile & Settings
**Flow:** Settings / permission flow → Notifications → Previous

**Purpose:** Give the parent precise control over useful reminders without guilt-based engagement.

**Tap / Interaction Contract:**
- **Sleep reminders toggle** → Enable/disable wind-down reminder. → Stay
  - *Data/state:* notificationPrefs.sleep
- **Check-in reminders toggle** → Enable/disable one gentle prompt when nothing is logged. → Stay
  - *Data/state:* notificationPrefs.checkin
- **Mentorship updates toggle** → Enable/disable mentor/session updates where product policy permits. → Stay
  - *Data/state:* notificationPrefs.mentorship
- **Weekly review toggle** → Enable/disable Sunday review-ready notification. → Stay
  - *Data/state:* notificationPrefs.weeklyReview
- **Back** → Return to settings. → Previous

**Logic Hardik should implement:**
- First app-level enable may require OS permission p72.
- Never send streak-loss or missed-day guilt messaging, consistent with the design.

| Reads | Writes |
|-------|--------|
| NotificationPreferences; OS permission | NotificationPreferences |

**Why this matters to the parent:** Parents receive only reminders that help them act, not notification noise.

**Simple logic connection:**
- **Parent does →** Turns sleep, check-in, mentorship or weekly-review notifications on/off.
- **App learns / uses →** Stores which classes of reminders the parent actually wants.
- **Next effect →** Only enabled notification types may be scheduled. Mood/sad selections must never create a notification on their own.
- **Parent benefit →** Parents receive useful nudges without notification overload.

---

### Screen 62 | Privacy & Data

**Section:** Profile & Settings
**Flow:** Settings → Privacy & Data → Family / external policy / signed-out

**Purpose:** Explain linked access, provide privacy policy/data export and allow permanent account deletion.

**Tap / Interaction Contract:**
- **Linked caregivers** → Open Family Menu or linked caregiver management. → p54
- **Read full privacy policy** → Open current policy web/in-app document. → External/in-app policy
- **Export my data** → Start authenticated export workflow and notify when ready. → Stay/status
  - *Data/state:* ExportRequest
- **Delete account** → Show strong confirmation/re-authentication, then permanently delete according to policy. → Signed-out state
  - *Data/state:* DeletionRequest
- **Back** → Return to settings. → Previous

**Logic Hardik should implement:**
- Deletion must remove/revoke child data and linked caregiver access as the UI states.
- Do not execute destructive actions from one accidental tap.

| Reads | Writes |
|-------|--------|
| Linked caregivers; policy version | Export/deletion actions |

**Why this matters to the parent:** Parents can understand and control what happens to their family data.

**Simple logic connection:**
- **Parent does →** Reviews privacy, linked caregivers, export or account deletion.
- **App learns / uses →** Reads privacy/access state and applies explicit data actions.
- **Next effect →** Export returns the parent's data; deletion removes profile/data/access as described and must require confirmation.
- **Parent benefit →** Gives the parent control over sensitive family information.

---

### Screen 63 | Help & Safety

**Section:** Profile & Settings
**Flow:** Settings / Safety Concern → Help & Safety → Help/support/emergency

**Purpose:** Provide support routes, mentorship booking help, emergency guidance and the medical disclaimer.

**Tap / Interaction Contract:**
- **FAQs** → Open help articles. → Help content
- **Contact support** → Open support ticket/email/chat route. → External/in-app support
  - *Data/state:* SupportRequest
- **Mentorship booking help** → Open mentor booking support. → Support route
  - *Data/state:* SupportRequest
- **Emergency services** → Use device/local emergency route where implemented. → OS phone / emergency info
- **Back** → Return to settings. → Previous

**Logic Hardik should implement:**
- LovingBrain is not monitored for emergencies.
- Medical disclaimer must be consistently reachable from health/Brainy safety surfaces.

| Reads | Writes |
|-------|--------|
| Region/emergency configuration; help content | Optional support request |

**Why this matters to the parent:** Makes the limits of the app clear and gives parents a safe route when the app is not the right place for help.

**Simple logic connection:**
- **Parent does →** Opens FAQ/support/mentorship help or reads safety information.
- **App learns / uses →** No prediction learning; this is support and safety routing.
- **Next effect →** Emergency concerns are directed away from LovingBrain; normal support goes to the correct help route.
- **Parent benefit →** Sets clear boundaries about what the app can and cannot safely do.

---

## System & Edge States (64–74)

### Screen 64 | No Sleep Data Yet

**Section:** System & Edge States
**Flow:** Sleep entry with no data → No Sleep Data Yet → Sleep Update

**Purpose:** Sleep state when no usable sleep logs exist.

**Tap / Interaction Contract:**
- **Add a sleep update** → Open Sleep Update. → p17
- **Back** → Return to Today. → Today

**Logic Hardik should implement:**
- Use age-based general guidance only and clearly label it as not the child's own pattern.
- The screen says two or three updates is usually enough to start showing a personal window; implementation can use a minimum-data rule agreed by product.

| Reads | Writes |
|-------|--------|
| Child age; sleep-log count | None |

**Why this matters to the parent:** Gives a helpful starting point without pretending the app already knows the child.

**Simple logic connection:**
- **Parent does →** Sees there is not enough sleep data and adds a sleep update.
- **App learns / uses →** Knows the app has age guidance but insufficient child-specific evidence.
- **Next effect →** Uses generic age guidance temporarily; real updates start personalisation.
- **Parent benefit →** Avoids fake precision while still giving the parent a useful starting point.

---

### Screen 65 | Loading / Analysing

**Section:** System & Edge States
**Flow:** Brainy submit → Loading / Analysing → Conversation / error

**Purpose:** Short loading state while Brainy or the pattern engine is producing an answer.

**Tap / Interaction Contract:**
- **Automatic** → On success, replace with the requested answer/detail. On failure, show a recoverable error. → Conversation (p33) / error

**Logic Hardik should implement:**
- Do not leave the parent on an indefinite spinner.
- Keep the submitted question visible so the parent knows what is being processed.

| Reads | Writes |
|-------|--------|
| Pending request | None |

**Why this matters to the parent:** Shows that LovingBrain is working on the exact question rather than appearing frozen.

**Simple logic connection:**
- **Parent does →** Waits while LovingBrain recalculates after new data.
- **App learns / uses →** Indicates a calculation/network operation is in progress.
- **Next effect →** On success show the updated output; on failure preserve the parent's entry and use the error state.
- **Parent benefit →** Parent understands the app is processing rather than frozen.

---

### Screen 66 | Update Saved / Forecast Changed

**Section:** System & Edge States
**Flow:** Saved update → Update Saved / Forecast Changed → Updated sleep plan

**Purpose:** Success state after a log materially changes the sleep estimate.

**Tap / Interaction Contract:**
- **View updated plan** → Open the new Sleep Forecast/Tonight Plan. → Sleep Forecast (p23) / Tonight Plan (p25)
- **Quick actions** → Open matching update/Brainy route. → p17-p21/p32
- **Bottom nav** → Switch tabs. → Today/Brainy/Journey

**Logic Hardik should implement:**
- Show the delta clearly, e.g. *bedtime estimate moved 15 minutes earlier*.
- This screen should use the recalculated forecast timestamp just saved.

| Reads | Writes |
|-------|--------|
| Recalculated forecast and previous forecast | None |

**Why this matters to the parent:** Makes the benefit of logging visible immediately.

**Simple logic connection:**
- **Parent does →** Sees confirmation that a saved update changed the forecast/plan.
- **App learns / uses →** Compares previous and new result.
- **Next effect →** Refresh Today and, if notification permission is on, reschedule only a materially changed future reminder.
- **Parent benefit →** Shows that the parent's input had a real effect.

---

### Screen 67 | Save Error

**Section:** System & Edge States
**Flow:** Any Save action → Save Error → Success / Offline / previous

**Purpose:** Recover gracefully when an update cannot be saved.

**Tap / Interaction Contract:**
- **Try again** → Retry the same payload without forcing re-entry. → Success or stay error
  - *Data/state:* Retry write
- **Save on this device for now** → Persist encrypted local pending update and queue for sync. → Offline/Today
  - *Data/state:* Local pending log
- **Back/dismiss** → Keep draft locally for current session and warn before discarding. → Previous
  - *Data/state:* Draft state

**Logic Hardik should implement:**
- The screen promises nothing typed is lost; implementation must preserve the full update payload.
- Avoid duplicate server records when retrying after an uncertain network response; use idempotent client IDs.

| Reads | Writes |
|-------|--------|
| Failed write payload | Retry or local pending queue |

**Why this matters to the parent:** A parent does not lose a 20-second update because of poor connectivity.

**Simple logic connection:**
- **Parent does →** Sees a save error and retries.
- **App learns / uses →** Keeps the unsaved payload locally until save succeeds or the parent discards it.
- **Next effect →** Retry sends the same data; do not make the parent re-enter it.
- **Parent benefit →** Protects exhausted parents from losing work because of connectivity.

---

### Screen 68 | Offline

**Section:** System & Edge States
**Flow:** Network loss → Offline → Synced Today when online

**Purpose:** Show the last saved plan when the device has no connection and explain that syncing will resume later.

**Tap / Interaction Contract:**
- **Normal local navigation** → Allow read-only access to cached Today content where safe. → Cached screens
- **New updates if supported** → Save locally to pending queue, then sync when online. → Stay / success local
  - *Data/state:* Local pending log

**Logic Hardik should implement:**
- Clearly distinguish cached plan from a live recalculated plan.
- When connectivity returns, sync pending logs, recalculate forecasts and resolve conflicts using timestamps/client IDs.

| Reads | Writes |
|-------|--------|
| Cached Today state; network status | Optional local queue |

**Why this matters to the parent:** LovingBrain stays useful in real family situations even with unstable mobile data.

**Simple logic connection:**
- **Parent does →** Uses the app while offline.
- **App learns / uses →** Reads last known cached guidance and knows it may be stale.
- **Next effect →** Queue safe updates for sync when online and label cached predictions clearly; do not invent fresh server results.
- **Parent benefit →** The app remains useful without pretending offline data is current.

---

### Screen 69 | Low Confidence Sleep Window

**Section:** System & Edge States
**Flow:** Sleep Forecast → Low Confidence Sleep Window → Sleep Update

**Purpose:** Show an intentionally wider sleep window when recent data is insufficient or unsettled.

**Tap / Interaction Contract:**
- **Add tonight's update** → Open Sleep Update. → p17
- **Back** → Return to Sleep/Today. → p23/p12

**Logic Hardik should implement:**
- Confidence must be derived from data sufficiency/consistency rules, not cosmetic labels.
- Prefer an honest wide window to false precision.
- As more reliable logs arrive, confidence can increase automatically.

| Reads | Writes |
|-------|--------|
| Forecast confidence; data count/consistency | None |

**Why this matters to the parent:** Protects trust: the app admits uncertainty instead of pretending to know an exact bedtime.

**Simple logic connection:**
- **Parent does →** Views a low-confidence sleep window.
- **App learns / uses →** Recognises that the available data does not support strong precision.
- **Next effect →** Show a broader range/explanation and ask for the specific update that would improve confidence; avoid strong reminders from weak forecasts.
- **Parent benefit →** Builds trust by admitting uncertainty.

---

### Screen 70 | Safety Concern

**Section:** System & Edge States
**Flow:** Brainy health question → Safety Concern → Emergency / Help & Safety / Brainy

**Purpose:** Interrupt normal Brainy guidance when the parent describes something that may need professional attention.

**Tap / Interaction Contract:**
- **Call emergency services** → Open the configured emergency calling/information route. → OS emergency route
- **Read safety information** → Open Help & Safety / relevant safety article. → p63
- **Not now - go back to Brainy** → Return to Brainy without generating a reassuring medical answer. → p32

**Logic Hardik should implement:**
- Safety classifier/rules run before normal AI response.
- Do not diagnose. State that LovingBrain cannot assess symptoms.
- Emergency contact text must be region-aware where possible.

| Reads | Writes |
|-------|--------|
| User message; safety rules; region | Safety event log if policy permits |

**Why this matters to the parent:** Prevents AI guidance from getting in the way when a child may need real clinical help.

**Simple logic connection:**
- **Parent does →** Sees a safety warning when input/question suggests possible urgent concern.
- **App learns / uses →** Triggers the safety rule set, not normal parenting prediction logic.
- **Next effect →** Interrupt ordinary guidance and direct the parent to appropriate professional/emergency help; do not diagnose.
- **Parent benefit →** Safety takes priority over engagement or keeping the parent inside the app.

---

### Screen 71 | Mentor Service Unavailable

**Section:** System & Edge States
**Flow:** Mentor selection/booking → Mentor Service Unavailable → Waitlist / other guides / Brainy

**Purpose:** Handle the case where suitable mentors have no near-term availability.

**Tap / Interaction Contract:**
- **Join the waitlist** → Add parent to waitlist and confirm. → Confirmation/toast
  - *Data/state:* MentorWaitlist
- **See other guides** → Open support selection / other suitable guides. → Choose Support (p45)
- **Ask Brainy instead** → Open Brainy with the current support concern. → p32/p33
  - *Data/state:* AI context
- **Back** → Return to previous mentorship screen. → p45/p46

**Logic Hardik should implement:**
- Do not charge for a waitlist.
- Only suggest other mentor categories if their scope actually fits the problem.
- Notify parent when suitable availability opens if permission exists.

| Reads | Writes |
|-------|--------|
| Mentor availability; waitlist status | Waitlist record |

**Why this matters to the parent:** The parent still has a next step even when human capacity is limited.

**Simple logic connection:**
- **Parent does →** Sees that a mentor/service is unavailable and chooses another option.
- **App learns / uses →** Reads service/guide availability.
- **Next effect →** Offer another guide, waitlist or return path; do not accept a booking the system cannot fulfil.
- **Parent benefit →** Prevents frustrating dead-end bookings.

---

### Screen 72 | Notification Permission Explainer

**Section:** System & Edge States
**Flow:** First useful notification moment / Settings → Notification Permission Explainer → Originating screen

**Purpose:** Explain why LovingBrain wants notification permission before triggering the operating-system prompt.

**Tap / Interaction Contract:**
- **Allow notifications** → Trigger OS notification permission request. Store resulting status. → Return to originating flow
  - *Data/state:* OS permission status
- **Not now** → Do not trigger OS prompt; continue with notifications disabled. → Return
  - *Data/state:* Preference/permission state

**Logic Hardik should implement:**
- Show this at a useful moment, e.g. after first personalised sleep plan, not immediately at launch.
- If OS permission is permanently denied, Settings should explain how to enable it at system level.

| Reads | Writes |
|-------|--------|
| OS permission status | Notification permission/preference |

**Why this matters to the parent:** Parents understand what they will receive before being asked for a device permission.

**Simple logic connection:**
- **Parent does →** Reads why notifications are useful and chooses Allow or Not now.
- **App learns / uses →** Learns OS notification permission status only.
- **Next effect →** If allowed, schedule only opted-in useful reminders/heads-ups. If declined, app remains fully usable and should not nag repeatedly.
- **Parent benefit →** Parents understand the value before granting a device permission.

---

### Screen 73 | Microphone Permission Explainer

**Section:** System & Edge States
**Flow:** Brainy mic / Quick Note record → Microphone Permission Explainer → Voice Input / Quick Note

**Purpose:** Explain microphone use before the OS prompt for Brainy voice input or Quick Notes.

**Tap / Interaction Contract:**
- **Allow microphone** → Trigger OS microphone permission and return to voice/record action if granted. → Voice Input (p34) / Quick Note (p21)
  - *Data/state:* OS microphone permission
- **Not now** → Keep typed input available and return without recording. → Originating screen
  - *Data/state:* Permission state

**Logic Hardik should implement:**
- Ask only when the parent first taps a microphone/record action.
- Recording should only occur during the explicit recording interaction.

| Reads | Writes |
|-------|--------|
| OS microphone permission | Permission state |

**Why this matters to the parent:** Keeps voice features convenient while making privacy behavior clear.

**Simple logic connection:**
- **Parent does →** Reads why microphone access is needed and chooses Allow or Not now.
- **App learns / uses →** Learns microphone permission status only.
- **Next effect →** If allowed, voice input works; if declined, typing remains available.
- **Parent benefit →** Parents can use voice conveniently without being forced to grant microphone access.

---

### Screen 74 | Family Sharing Consent Explainer

**Section:** System & Edge States
**Flow:** Family Menu - Invite → Family Sharing Consent Explainer → Invite Caregiver (p55)

**Purpose:** Explain privacy boundaries before the parent invites another caregiver for the first time.

**Tap / Interaction Contract:**
- **Continue** → Open Invite Caregiver. → p55
- **Not now** → Return to Family Menu without creating an invite. → p54

**Logic Hardik should implement:**
- Show before first invite or when sharing rules materially change.
- Reinforce that parent reflections are never shared and health/mentorship are private by default.

| Reads | Writes |
|-------|--------|
| Whether consent explainer has been acknowledged | Acknowledgement timestamp (optional) |

**Why this matters to the parent:** The parent understands what family sharing means before any invitation is sent.

**Simple logic connection:**
- **Parent does →** Reads what family sharing means and explicitly continues or cancels.
- **App learns / uses →** Records consent before starting the sharing/invite flow.
- **Next effect →** Only after consent can an invite be created; actual data sharing still waits for acceptance and permissions.
- **Parent benefit →** Makes sharing intentional and transparent.

---

## Known Figma / Implementation Gaps

> These are not redesign requests. They are places where Deepak's visual UI is clear but the Figma prototype wiring or a supporting screen is missing. Hardik should not guess silently.

| Gap | Implementation Direction |
|-----|------------------------|
| **Account routing** | Phone Continue should use OTP before About You; Apple/Google can continue after successful provider authentication. |
| **Family Snapshot** | Go to Today should open the new-parent Today state, not return to Splash. |
| **Today prototype links** | Some Figma links on View details/Add update point to nearby demo screens. Use the action tables in this document. |
| **Quick Note / Instant Result** | Saving a free note should not automatically change a sleep forecast. Instant Result is for an update that materially changes a recommendation. |
| **Tonight Plan** | Start plan and Play audio should work in place. The prototype link to Sleep Pattern is not a sensible production transition. |
| **Voice input** | Send should submit the spoken question and return to the conversation answer; it should not open Saved Guidance. |
| **Guide list** | The design has support selection and a guide profile, but no separate multi-guide results screen. If multiple mentors launch, a list screen is still needed. |
| **Program placeholders** | The Program Recommendation page repeats Sleep Restore cards. Treat these as content placeholders, not four hard-coded identical programs. |
| **Request status** | There is confirmation and Parent Success Guide, but no separate generic pending-request detail screen. |
| **Settings landing** | Parent Profile, Child Profile, Notifications, Privacy & Data and Help & Safety exist, but the final PDF does not show a dedicated Settings menu screen. |
| **Child Essential item forms** | The list screen exists; add/edit item detail screens are not included. |
| **Recorded module player** | The program journey references a recorded module, but a dedicated player screen is not included. |

> **Rule for development:** if an action is described in this handoff but its destination UI does not exist in Deepak's file, pause that specific sub-flow and ask for the missing screen. Do not create a new visual style or change the main navigation.

---

## Implementation Logic Summary

### After Any Saved Update
- Persist the update with a client-generated ID.
- Recalculate only the outputs that use that update.
- If a meaningful output changed, show p22/p66. Otherwise show a lightweight success and return.
- On failure, preserve the payload and use p67.

### Sleep Forecast
- Use child age + real sleep logs + timezone.
- Return window, estimate, confidence, reason and plan.
- No data → p64; low confidence → p69; offline → cached p68.

### Calm Heads-Up
- Use probabilistic language and explicit contributing signals.
- New sleep/mood/behaviour context can update the risk window.
- Never represent the heads-up as certainty or diagnosis.

### Brainy
- Load only relevant family context.
- Run safety check before normal response.
- Use the visible answer structure: what may be happening → what to try now → when to get help.

### Journey
- Aggregate meaningful weekly changes instead of copying raw logs.
- One useful experiment at a time.
- Timeline stores meaningful events, not every tap.

### Mentorship
- Respect mentor scope and summary-sharing consent.
- Use external calendar where configured rather than building a second booking system.
- Program/session status should feed Journey.

### Family Sharing
- No data is shared before invite acceptance.
- Backend access must enforce each permission.
- Parent reflections are never shared.

---

## Final Handoff Rule

Build the behavior described here using Deepak's existing components and visual system. This document intentionally documents the current final UI; future LovingBrain product changes should be handled as a separate change request so the team is not constantly rebuilding the foundation.

> **One final implementation principle:** for every input Hardik should be able to answer three questions: *What does LovingBrain learn? What useful output can this change? What does the parent gain?* If an input changes nothing useful, it should not be collected. One normal state on its own must never create an alarming prediction or notification.
