**LovingBrain V2.0**

**Build Guide for Hardik**

*Prepared by Aswin  ·  What to build, how it should behave, and the data behind it*

| **A note before you start** Hardik — this is the full picture of what LovingBrain V2.0 should become. It's detailed on purpose, so you're never guessing what a screen is meant to do. It is not a deadline list. Please take the time you need to build this properly. I'd rather have a smaller number of screens that feel solid and calm than everything rushed. Build in the order given in Section 18 — the daily-use core first, the extra features last — and if you ever have to slow down, slow down from the bottom of that list, not the top. If anything here is unclear or you think there's a simpler way to build it, tell me. This is a guide, not a rulebook. |
| --- |

# **Before Anything Else: How V2.0 Relates to What You Already Built**

You've already built Sprints 1–3 (Energy Bridge, Journal, Milestone stories, Brain AI, Schedule, and more). V2.0 is a change of direction, not a criticism of that work — a lot of it carries forward. This section maps the old app to the new one so nothing is confusing. Read this first.

**KEPT — things you built that carry forward**

| **What you built** | **What happens to it in V2.0** |
| --- | --- |
| Energy Bridge (state + timer logic) | Becomes Tantrum Prediction. The engine survives — but instead of a manual High Energy timer, it becomes a Low/Med/High risk score fed by sleep, mood, time of day, and triggers. Same idea, better inputs. |
| Brain AI | Stays, upgraded. It already pulls some live context — now it gets the full structured context payload (Section 9) with every message. |
| Sleep logging | Stays and gets promoted. It was a small tracker; now it's the hero of the whole app (Sleep Forecast card on Today + Sleep Details + prediction). |
| Quick Record (log in seconds) | Becomes Daily Check-in. Same 2-second logging idea, expanded to Sleep / Tantrum / Mood / Health / Note — and every check-in now returns an insight card. |
| Onboarding (child name + DOB) | Stays and expands into the full 'Let us get to know your family' flow (Section 4). |
| Help flow (Crying / Won't sleep / Feeding / Fussy + guidance) | The guidance content survives — it feeds into Brainy and the insight cards rather than living as its own separate flow. |

**CHANGED / MOVED — same idea, new home**

| **What you built** | **Where it goes** |
| --- | --- |
| Home screen (tiles: Jump Back In, Free Time, Family Wellness) | Rebuilt as Today / Daily Brief. Sleep Forecast hero card first, then tantrum risk, one AI note, quick actions. The tile layout goes away. |
| Mood log ('How Are We Feeling', child + parent) | Moves inside Daily Check-in as the Mood check-in type. No longer a standalone screen with a streak. |
| Today's Timeline | Becomes part of the Journey tab — progress shown as a story. |
| Bottom navigation (Home / Schedule / Brain AI / Journal / Profile) | Becomes three tabs: Today / Brainy AI / Journey. Profile and Family move to the top-right icon. |
| Co-Parenting (shared calendar in Schedule) | Returns in a different form: Family Sharing (Section 13) — invite a caregiver, share logs/notes/essentials. No shared calendar. |

**REMOVED — not in V2.0**

| **What you built** | **Why it****'****s out** |
| --- | --- |
| Milestone Stories (AI memory stories, 'The Laugher') | Doesn't serve the new sleep + prediction focus. Dropped, including its screens and story generation. |
| Journal Book tab (locked chapters + PDF export) | The chapter-book keepsake concept is gone entirely. |
| Journey milestone stages (Voice Finder / Explorer / Walker) + Readiness Score | 'Journey' now means progress and weekly review, not developmental stages. The readiness number is dropped. |
| Mood Streak (Current Streak 0 🔥) | Replaced by something better — see the 'Instead of a Streak' part of Section 10. Streaks create guilt; we celebrate effort instead. |
| Schedule tab (Daily Routine, Add Activity: Snack/Meal/Nap/Play) | Dropped as a standalone. The useful pieces live inside check-ins now. |
| Manual 'Add Sleep Log' form (the separate one) | One sleep-logging path only in V2.0 — through the check-in flow. |

**NEW — didn****'****t exist before**

- Sleep Prediction (next window, bedtime, overtired risk, confidence).

- Tantrum Prediction as an explicit Low/Med/High score with reason + action.

- Weekly Family Progress Review + Today's Win (the streak replacement).

- Guided Mentorship shells and Parent Success Guide.

- Program Recommendation engine.

- Family Sharing / Child Essentials.

- Health check-in (sick today, symptoms, medication).

| **The short version** The prediction engine, Brainy, sleep logging, quick logging, and onboarding all carry forward — your core work survives. The Journal / Milestone / Book world and the Schedule tab are retired. Sleep goes from a side feature to the hero. If you're ever unsure whether an old screen belongs in V2.0, check this section first, then ask me. |
| --- |

# **1. The Big Picture**

LovingBrain is a calm, AI-powered parenting app. It helps a parent understand what their child may need next — mainly around sleep and tantrums — and gives gentle, personal guidance before small problems become big ones.

The app should feel warm and human, like a supportive friend. It should never feel like a tracker, a form, or a generic chatbot.

| **The one rule that matters most** Never ask the parent for information unless the app gives something useful back straight away. Every check-in should return an insight. Every screen should reduce worry, not add to it. |
| --- |

# **2. What the App Does**

Everything in V2.0 supports five simple jobs:

- Get to know the family (onboarding) — so the app can personalise from Day 1.

- Show a calm daily brief (Today screen) — the screen parents open every morning.

- Predict sleep and tantrums — the two features that make the app worth opening.

- Answer questions (Brainy AI) — an assistant that actually knows the child.

- Show progress and offer support (Journey, weekly review, mentorship shells) — so parents stay.

**Full feature list and how much to build**

| **Feature** | **What the parent gets** | **How much to build now** |
| --- | --- | --- |
| Onboarding | Family + child details, goals, first sleep/behaviour info | Build fully |
| Today (Daily Brief) | Sleep forecast, tantrum risk, focus, one AI observation | Build fully |
| Daily Check-in | Quick updates that return an instant insight | Build fully |
| Sleep Prediction | Next sleep window, bedtime, overtired risk, reason | Build fully (simple logic first) |
| Tantrum Prediction | Low/Med/High risk, likely reason, what to do | Build fully (simple logic first) |
| Brainy AI | AI chat that knows the child, goals and recent logs | Build fully |
| Weekly Progress Review | Simple weekly summary of wins and changes | Build basic version |
| Family Journey / Timeline | Progress shown as a story, not charts | Build basic timeline |
| Guided Mentorship | Preview of future paid programs | Build shell screens only |
| Parent Success Guide | A friendly human-support placeholder | Build shell screens only |
| Program Recommendation | Gentle 'this might help' cards at the right moment | Build basic rules + shell button |
| Family Sharing (Co-parenting) | Invite a partner/caregiver to share the child's info | Build basic sharing + invite |
| Profile & Settings | Manage family, child, notifications, privacy | Build basic |

# **3. Navigation (Final)**

Keep the bottom of the screen simple. Only three tabs.

| **Where** | **What it is** |
| --- | --- |
| Today (tab 1) | Home screen. The Sleep Forecast is the big card at the top, then tantrum risk, one AI note, and quick actions. |
| Brainy AI (tab 2) | The parenting assistant that knows the child and family. |
| Journey (tab 3) | Progress timeline, weekly review, Guided Mentorship, Parent Success Guide, recommendations. |
| Sleep | NOT a tab. It is the hero card on Today, with a 'View Sleep Details' screen behind it. |
| Daily Check-in | NOT a tab. It is a quick action opened from Today, the sleep card, Brainy, or a recommendation card. |
| Family Sharing (Co-parenting) | NOT a tab. It lives under the top-right Family/Profile icon. |

| **Please note** Check-in is a quick pop-up sheet, not its own destination. When you see 'Check-in Home' in the screen list later, it means this quick-action sheet — don't build it as a separate main tab. |
| --- |

**The main journey a parent takes:**

Sign up → 'Let us get to know your family' → Family Snapshot → Today Home. From Today they check in, ask Brainy, and over time see their Journey and weekly progress.

# **4. Onboarding — “Let Us Get to Know Your Family”**

This should feel like a warm chat, not a form. One question per screen where you can. Show progress (Step 1 of 6, etc.).

**The screens, in order**

| **Screen** | **What to collect** | **Why** |
| --- | --- | --- |
| Welcome | Get started / I already have an account | Warm intro; route new vs returning users |
| Parent Profile | First name, relationship to child, country, language, time zone (age range + city optional) | Personalise greetings, tone, language |
| Why Are You Here? | Sleep, Tantrums, Wellbeing, First-time, Guidance, Stress, Other (multi-select, one follow-up) | Sets the family's main goal |
| What Does Success Look Like? | e.g. child sleeps better, understand tantrums, feel less stressed | Used later to show progress |
| Child Profile | Name, date of birth (age auto-calculated), gender optional; premature / allergies / meds optional | Age drives everything: sleep, tantrum, tone, safety |
| First Sleep Setup | Typical wake time, bedtime, number of naps, nap length, night wakings | Lets sleep prediction work from Day 1 (allow Skip) |
| First Behaviour Setup | Common tantrum time, trigger, intensity, a note (use chips) | Gives first tantrum context |
| Family Snapshot | Show child age, main goal, first sleep estimate, first focus | End with value, NOT 'Setup complete' |

| **Small but important** The last onboarding screen must show the parent something useful (their first sleep estimate and focus). Never end onboarding with a plain 'Setup complete' screen. |
| --- |

# **5. Today Screen — the Daily Brief**

This is the screen parents come back to every morning. It must feel calm and be useful within 10 seconds.

**What****'****s on it, top to bottom**

| **Part** | **What it shows** |
| --- | --- |
| Header | Good morning, [Parent]. Below: Today for [Child]. |
| Sleep Forecast (hero) | The FIRST and LARGEST card. Next sleep window, suggested bedtime, overtired risk, confidence %, and buttons: Log Sleep / View Sleep Details. |
| Tantrum Risk card | Low / Medium / High, the likely reason, and one thing to do. |
| Brainy Observation | One short line, e.g. 'Rohan sleeps better after outdoor play.' |
| Quick Actions | Quick Check-in, Log Sleep, Log Tantrum, Ask Brainy, Add Note. |
| Mentorship suggestion | Only when relevant, e.g. after 5 hard bedtimes. Gentle, never pushy. |
| Family Sharing status | If a co-parent is linked, a small line: 'Shared with [Name].' Keep it small. |

| **Example of the Today screen wording** Good morning, Sarah.  Today for Rohan SLEEP FORECAST — Next window: around 11:20–11:50 AM · Overtired risk: Medium · Suggested bedtime: before 7:30 PM · Confidence: 72% Tantrum risk: Medium — Reason: short nap yesterday + transition time. What to do: keep the afternoon calm, give warnings before changes. Brainy noticed: Rohan usually sleeps better after outdoor play. |
| --- |

**Simple rules for the Today screen**

- If there's a sleep log today, use the latest wake/nap to work out the next window.

- If not, fall back to the typical times from onboarding.

- If there's no tantrum data yet, show a gentle age-based estimate and ask for a first check-in.

- If confidence is low, say so kindly: 'Add today's sleep to improve accuracy.'

- Don't crowd the screen. Calm, not busy.

# **6. Daily Check-in — Logs That Don’t Feel Like Logs**

Don't use the word 'Logs' in the app. Call it 'Daily Check-in' or 'Today's Update'. The point is to help Brainy learn and give something useful straight back.

**The five check-in types**

| **Check-in** | **Fields** | **Why it exists** |
| --- | --- | --- |
| Sleep Update | Wake time, nap start/end, bedtime, night waking, quality | Sleep prediction + learning |
| Tantrum Update | Yes/no, time, duration, intensity, trigger, note | Tantrum prediction + triggers |
| Mood Check | Child mood, parent mood (emoji/chips) | AI tone + emotional trend |
| Health Update | Fever, cold, medication, sick today | Context + safety |
| Daily Note | Voice or text: anything unusual today? | AI memory + guide context |

**How it flows:**

- Parent taps Quick Check-in / Log Sleep / Log Tantrum / Add Note from Today. (There is no Check-in tab.)

- A quick sheet asks what they want to update: Sleep / Tantrum / Mood / Health / Note.

- They fill the smallest possible form — chips, sliders, one-tap fields.

- Save to Firestore, then immediately show an insight card (never just 'Saved').

- The insight card offers a next step: Adjust bedtime, Ask Brainy, Add note, View Today.

| **Instant insight examples** Sleep: 'Rohan had a shorter nap today. Bedtime may need to be 20 minutes earlier.' Tantrum: 'This may be linked to transition stress. Try a 5-minute warning before changing activities.' Mood: 'You marked yourself as overwhelmed. Brainy will keep things shorter and calmer today.' |
| --- |

# **7. Sleep Prediction (the Hero Feature)**

This is the main reason a parent opens the app. It must be the hero card on Today, never hidden in another tab.

**What the parent sees**

| **Output** | **Example** |
| --- | --- |
| Next sleep window | Around 11:20 – 11:50 AM |
| Overtired risk | Low / Medium / High |
| Bedtime suggestion | Aim before 7:30 PM |
| Confidence | 68% — improves with more logs |
| Reason | Short nap yesterday may make bedtime harder today |
| Action | Start wind-down 20 minutes before the window |

**Simple logic to start with**

- Use the child's age to set a default wake-window range.

- Anchor = latest nap end, else today's wake time, else the typical wake time from onboarding.

- Next sleep window = anchor + age-based wake window.

- Short previous nap → raise overtired risk, suggest earlier bedtime.

- Lots of night wakings → lower confidence, show supportive words.

- Child sick → add a caution and reduce confidence.

- Confidence starts low and grows with each day of logs.

**Empty states (be kind, guide the next step)**

| **When** | **What to show** |
| --- | --- |
| No child age | Ask for the child's date of birth first. |
| No sleep data yet | Show an age-based estimate + 'Add today's wake time for a better prediction.' |
| Low confidence | Show it but label as an early estimate; invite one quick update. |
| Conflicting data | Ask the parent to confirm the latest wake/nap time. |

# **8. Tantrum Prediction**

This must never feel like judging the child. It's about helping the parent prepare and stay calm.

**What the parent sees**

| **Output** | **Example** |
| --- | --- |
| Risk level | Low / Medium / High |
| Likely reason | Short nap + transition time may increase frustration |
| What to do | Give a 5-minute warning before changing activities |
| Pattern insight | Tantrums often happen after daycare pickup |
| Confidence | Improves after more check-ins |

**Simple logic to start with**

- Start at Low risk.

- Raise it if sleep was poor, a nap was missed, or bedtime was late.

- Raise it near a known trigger time from past logs.

- Raise it if the child's mood is tired, angry, or unsettled.

- Always use gentle words — may, might, likely — never absolute statements.

- Always pair the risk with something to do. Never show a risk with no guidance.

# **9. Brainy AI — the Assistant That Knows the Child**

Brainy is not a generic chatbot. Every answer should use the family and child details, recent logs, goals, and past chats.

**The screen**

- Header: 'Ask Brainy about [Child Name].'

- Context chips: Sleep, Tantrum, Mood, Health, General.

- Suggested prompts: 'Why is bedtime hard today?' / 'What should I do before a tantrum?' / 'Is this normal for this age?'

- A safety line at the bottom: Brainy gives parenting guidance, not emergency medical care.

| **The most important part for you, Hardik** Every time you send a message to Brainy, attach a structured context object as well — don't rely on the typed message alone. This is the same idea used for the milestone stories: give the AI the real data before it answers. Include: parent (name, relationship, language, goal), child (name, age in months, allergies, notes), sleep summary, tantrum summary, mood summary, health summary, current journey focus, and a short summary of recent chats. |
| --- |

**How Brainy should sound**

- Warm, calm, practical, and short by default.

- Use the child's name and age when it helps.

- Give a possible reason, then 2–3 clear steps.

- No fear-based language. Use may / might / could.

- Point to a professional for anything medical or urgent.

# **10. Weekly Review ****&**** Family Journey**

Both exist to help parents stay, by showing the app notices their effort.

**Weekly Family Progress Review**

A simple weekly summary: sleep trend, tantrum trend, one thing Brainy learned, one win to celebrate, and one focus for next week.

| **Example weekly review** This week, bedtime became 18 minutes earlier on average. Tantrums went from 5 to 3. Brainy learned that Rohan settles better after outdoor play. Your win: you stayed consistent on hard evenings. Next week: earlier wind-down before bed. |
| --- |

**Family Journey / Timeline**

Show progress as a short story, not charts: 'Week 1 — you joined because bedtime felt hard,' 'First successful earlier bedtime,' 'You stayed calm through a hard transition.' A basic timeline is enough for V2.0.

**Instead of a Streak — Progress-Based Reinforcement**

The old app had a mood streak (Current Streak 0 🔥). Do NOT rebuild it. Streaks punish parents for missing a day — 'you lost your streak' creates guilt, and LovingBrain should make parents feel supported, never judged. Build these four things instead:

| **Piece** | **Where** | **How it works** |
| --- | --- | --- |
| Today's Win | Today screen | One true, warm line about today. Example: 'You logged Rohan's sleep and helped Brainy understand his pattern better.' It must NEVER be empty — on a day with no logs, show a fallback like: 'You're here, thinking about Rohan. That's what matters.' |
| Weekly Family Progress | Journey | The weekly review from this section — real improvements, real numbers. IMPORTANT: it also needs a gentle 'harder week' mode. If sleep or tantrums got worse (teething, illness, travel), never fake positivity and never go silent. Say: 'This was a harder week — and you still showed up for Rohan. That matters.' |
| Family Journey Timeline | Journey | The story arc above ('Week 1: bedtime took 70 minutes → Week 3: 42 minutes → Week 6: Rohan slept independently for the first time'). This is the emotional heart — more meaningful than any counter. |
| Consistency Badge | Journey / Weekly Review | Gentle recognition: 'Consistent Care — you checked in 4 days this week.' Never show '0 days' and never mention a break. If a week has no check-ins, show nothing about consistency at all. Absence is never punished. |

| **One extra build note for this** The Weekly Progress can show parent confidence changing over time (e.g. 4/10 → 6/10). For that number to move, add a light recurring check-in — occasionally ask the parent 'How confident are you feeling as a parent this week?' (one tap, 1–10). If that's not built yet, leave the confidence line out of the weekly review rather than showing a number that never changes. |
| --- |

# **11. Guided Mentorship ****&**** Parent Success Guide (Shells)**

These are previews of the paid, human side of LovingBrain. In V2.0 they are shells — they should look real and explain the future experience, but don't need full booking automation yet.

**Guided Mentorship**

A home screen with program cards: 6-Week Sleep Journey, Guided Tantrum Mentorship, Calm Parent Journey, First-Time Parent Support. Each card shows the outcome, duration, what's included, an expert placeholder, and a button: Join waitlist / Book intro call / Coming soon. Tapping a card opens a detail page from the same template. If a parent requests one, save it to the mentorship_requests collection.

**Parent Success Guide**

A friendly placeholder for real human help: a guide's name/photo/role, and buttons like 'Book free welcome call' or 'Message us.' After a tap, show 'Request received — our team will contact you soon,' and save the request. It should feel like someone is walking with the parent, not like customer support.

| **Please leave room for this (added later)** About 8 months after launch we'll add a Licensed Doctor Consultation module (booking a real doctor). You don't build it now — but please build the Mentorship and Parent Success Guide shells so a booking/consultation flow can be attached later without rebuilding these screens. Just leave the space for it. |
| --- |

# **12. Gentle Program Recommendations**

Sometimes the app suggests a mentorship program. This must feel like care, never advertising. Only show it when there's a real reason.

| **Program** | **Show it when…** | **Example wording** |
| --- | --- | --- |
| 6-Week Sleep Journey | Parent chose Sleep; or 3+ poor sleep logs in a week; or asks Brainy about sleep twice | 'Brainy noticed sleep has been hard lately. Want a guided plan for calmer nights?' |
| Guided Tantrum Mentorship | Parent chose Tantrums; or 3+ tantrums in a week; or a repeating trigger | 'Tantrums seem to repeat around similar moments. A guided plan may help.' |
| Calm Parent Journey | Parent mood 'overwhelmed' 3+ times in a week | 'You marked yourself as overwhelmed a few times. LovingBrain can support you too.' |
| First-Time Parent Support | Parent chose first-time parenting; child under 12 months | 'New parenting can feel confusing. This gives step-by-step support.' |

**Rules for recommendations:**

- Use a soft bottom sheet, never a forced full-screen popup.

- Show at most one per session, and never right after signup.

- Never interrupt a sensitive Brainy conversation.

- Always allow 'Maybe later' / 'Not relevant.' If dismissed, don't repeat for at least 7 days.

- Never imply the parent is failing. The feeling should be: 'we noticed this may be hard, and we can help.'

# **13. Family Sharing (Co-parenting)**

This lets a parent share the child's info with a partner or caregiver. It lives under the top-right Family/Profile icon and is called 'Family Sharing' in the app — not a bottom tab.

**What it does**

- Invite a Mother, Father, Grandparent, Nanny, or Guardian by phone or email.

- Choose what they can see: child profile, sleep logs, tantrum notes, daily notes, child essentials, weekly progress.

- Both people see shared sleep and behaviour updates, showing who logged what.

- A simple 'Child Essentials' info bank: allergies, medications, doctor contact, daycare contact, emergency contact, notes.

| **Please do NOT build these in V2.0** No shared calendar. No custody or legal tools. No pickup/drop-off flow. No doctor booking. No document vault. No co-parent chat. Keeping it simple here is intentional — it protects your time for the core features. |
| --- |

Simple flow: tap Family/Profile icon → Family Sharing → if nobody is linked, show 'Invite a caregiver' → enter phone/email + role → pick what they can see → invite is created as 'pending' → caregiver accepts and is linked to the child.

# **14. Notifications**

Helpful, never noisy. Each one should feel like care.

| **Type** | **Example** | **When** |
| --- | --- | --- |
| Morning brief | 'Your Parenting Brief for today is ready.' | Daily (optional) |
| Sleep window | 'Rohan may be ready for sleep soon. Start wind-down?' | From prediction |
| Check-in nudge | 'Want to update today's sleep? It helps Brainy improve tomorrow.' | Gentle; stop if ignored |
| Weekly review | 'Your family progress review is ready.' | Weekly |

# **15. Data Structure (Firestore)**

A suggested model — you can rename collections if you prefer, as long as the relationships stay clear. Main collections:

- users — parent details (name, relationship, country, language, main concerns, success goal, confidence score).

- children — child details (name, DOB, age in months, allergies, medical notes, primary goal, parent link).

- sleep_logs — date, wake time, nap start/end, bedtime, night wakings, quality.

- tantrum_logs — timestamp, duration, intensity, trigger, parent note.

- mood_logs — date, child mood, parent mood.

- health_logs — date, sick today, symptoms, medication note.

- daily_notes — date, text or voice transcript, source.

- weekly_reports — week start, sleep summary, tantrum summary, Brainy observation, parent win, next focus.

- journey_events — type, title, short description, created date.

- mentorship_requests — program type, status, preferred contact, created date.

- caregiver_invites / child_caregivers / child_essentials — for Family Sharing (invite target, role, permissions, status; and the essentials info bank).

| **Note** The full field-by-field tables are in the appendix at the end. This list is just so you can see the shape of the data at a glance. |
| --- |

# **16. Starter Logic (Pseudocode)**

These are simple product rules to get useful early estimates — not final medical algorithms. Keep the wording gentle.

**Sleep prediction**

- Inputs: child age (months), latest wake or nap end, sleep quality, previous nap length, sick today.

- 1. Get the default wake-window range for the age.

- 2. Anchor = latest nap end, else wake time, else typical wake time.

- 3. Next sleep window = anchor + wake window (lower to upper).

- 4. Short nap, late bedtime, or high night wakings → raise overtired risk.

- 5. Sick today → lower confidence, add caution.

- 6. Confidence = base 55 + consistency bonus − missing-data penalty.

- 7. Return window, bedtime suggestion, risk, reason, action.

**Tantrum risk**

- Inputs: sleep quality, missed nap, time of day, recent tantrums, known triggers, child mood, health, note.

- 1. Start risk = Low.

- 2. Poor sleep or missed nap → raise.

- 3. Near a common tantrum time → raise.

- 4. Mood tired/angry/unsettled → raise.

- 5. Tantrums increasing, or trigger matches today → raise.

- 6. Sick today → add context, reduce certainty.

- 7. Return Low/Medium/High + reason + next action.

# **17. Full Screen List**

Every screen to build. (Remember: 'Check-in Home' is the quick-action sheet from Section 6, not a separate tab.)

| **Screen** | **Purpose** |
| --- | --- |
| Splash / Login / Welcome | App start, sign in, warm intro |
| Onboarding (Parent, Why Here, Goal, Child, Sleep, Behaviour) | Collect family + child info |
| Family Snapshot | First personalised summary with value |
| Today | The daily brief (sleep hero card + tantrum + AI note) |
| Today – Sleep Forecast Hero | First and largest home card |
| Sleep Details | Deeper sleep screen from Today |
| Check-in sheet (Sleep/Tantrum/Mood/Health/Note) | Quick-action updates |
| Insight Result | The insight card after any check-in |
| Sleep Prediction Detail | Full sleep forecast + explanation |
| Tantrum Prediction Detail | Risk + explanation |
| Brainy AI | Context-aware chat |
| Journey Home + Weekly Review | Timeline + progress |
| Guided Mentorship Home + Detail | Program shells |
| Parent Success Guide | Human support shell |
| Program Recommendation Card/Popup | Gentle suggestions |
| Family/Profile Menu | Top-right icon: profiles, family sharing, essentials, settings |
| Family Sharing Home + Invite | Co-parent sharing + invite |
| Child Essentials | Allergies, meds, key contacts |
| Profile / Edit Child / Settings | Manage account, notifications, privacy, language |

# **18. Suggested Build Order**

Build top to bottom. The top items are the daily-use core — make those solid first. The bottom items are extra polish. If you ever need to slow down or something has to wait, let it be the bottom of this list, never the top.

- Login and basic app navigation (the 3 tabs).

- Parent + child profile data model.

- Onboarding flow and Family Snapshot.

- Today screen (static first, with placeholder prediction cards).

- Sleep check-in + sleep_logs.

- Sleep prediction logic + Sleep Details screen.

- Tantrum check-in + tantrum_logs.

- Tantrum prediction logic + detail screen.

- Mood, health, and daily-note check-ins.

- Brainy AI with the structured context payload.

- Weekly Progress Review.

- Journey timeline.

- Guided Mentorship shell.

- Recommendation cards + rules.

- Parent Success Guide shell.

- Family Sharing (invite + shared logs + essentials).

- Notifications and final polish.

| **If time gets short** The core loop is: onboarding → Today → sleep check-in → sleep prediction → tantrum → Brainy. If that works and feels calm, we have a real product. The recommendation engine and Family Sharing are the safest things to finish later. Please don't rush the core to reach the extras. |
| --- |

# **19. “Done” Checklist**

A screen or feature is done when:

- A new parent can finish onboarding and reach Today without confusion.

- Today shows at least one useful sleep/tantrum card right after onboarding.

- A parent can log sleep, or a tantrum, in under 20 seconds each.

- Every check-in returns an insight card, not just 'Saved.'

- Brainy receives the structured family context with every message.

- The weekly review can generate even from a little data.

- Mentorship shows at least 4 program cards with a waitlist/request flow.

- Parent Success Guide captures a support request and preferred contact.

- Empty states are warm and point to the next action.

- Wording is consistent: Check-in, Today, Journey, Brainy, Guided Mentorship, Parent Success Guide.

# **20. What V2.0 Should Feel Like**

| When a parent opens LovingBrain, they should feel: this app knows my child, understands why I'm here, helps me prepare for the day, gives me clear next steps, remembers our progress, and offers real support when I need it. They should never feel: I'm filling forms, tracking random data, or talking to a generic chatbot. |
| --- |

*Thanks, Hardik. Take your time and build it well. — Aswin*