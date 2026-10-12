# LOVINGBRAIN — Simple Screen Connection + Logic Flow

**Simple Screen Connection + Logic Flow | For Hardik**  
**How Every Parent Action Connects Through the App**  
**Developer Reference for Hardik | Based on Deepak's Final 74-Screen UI**

---


```text
Keep Deepak's current UI
Bottom navigation stays: Today | Brainy AI | Journey
```


```text
Energy Bridge is backend logic connecting the existing screens. It is not a new page.
```


## 1. The Main LovingBrain Loop


```text
Parent records real life
Sleep, Tantrum, Mood, Health or Quick Note
```

  ↓


```text
Data is saved to one child timeline
Every structured update keeps date/time and the child it belongs to
```

  ↓


```text
Energy Bridge checks the new event
Looks at current event + recent child pattern + age/time-zone context
```

  ↓


```text
Only relevant outputs are recalculated
Do not recalculate everything after every tap
```

  ↓


```text
Parent sees something useful
Forecast, Heads-Up, Brainy context, Journey insight or no visible change
```

  ↓


```text
Parent acts and records what happened later
The outcome becomes future pattern data
```


## 2. What Energy Bridge Actually Does


```text
1. Receives a structured event
Example: nap ended early; tantrum at 5:20 PM; mood = fussy
```

  ↓


```text
2. Adds child context
Child age, time zone, recent sleep, recent behaviour and relevant health context
```

  ↓


```text
3. Compares with the child's recent baseline
Is today normal for this child or meaningfully different?
```

  ↓


```text
4. Looks for repeated combinations
Example: short nap + difficult evenings repeatedly occurring together
```

  ↓


```text
5. Calculates confidence
More consistent personal data = stronger confidence; limited/unusual data = lower confidence
```

  ↓


```text
6. Produces only safe outputs
Sleep window, harder-window Heads-Up, Brainy context, Journey pattern
```

  ↓


```text
7. Passes through notification rules
Notify only when useful, enabled and not recently duplicated
```


```text
V1 should be rules-based and transparent. Exact thresholds/weights should be finalised with the data/science team before Hardik hard-codes them.
```


## 3. Energy Bridge - Input -> Logic -> Output


| INPUTS | INPUTS | INPUTS | INPUTS | INPUTS |
| --- | --- | --- | --- | --- |
| ↓<br>Child profile<br>Age / DOB / time zone | ↓<br>Sleep<br>Wake / nap / bedtime / night waking / quality | ↓<br>Behaviour<br>Time / intensity / trigger / what helped | ↓<br>Mood<br>Mood + timestamp | ↓<br>Health<br>Illness / teething / medication etc. |

  ↓


```text
ENERGY BRIDGE
Personal baseline + recent pattern + today's event + confidence rules
```

  ↓


| OUTPUTS | OUTPUTS | OUTPUTS | OUTPUTS |
| --- | --- | --- | --- |
| ↓<br>Sleep Forecast<br>Next window + confidence + reason | ↓<br>Calm Heads-Up<br>Harder window may be more likely | ↓<br>Brainy<br>Relevant personal context | ↓<br>Journey<br>Meaningful weekly pattern / experiment |


```text
Quick Note is stored as context. It can help Brainy/Journey, but it should not directly change predictions.
```


## 4. Onboarding -> Starting Baseline


```text
Main Concern
Sets the first priority: sleep / behaviour / parent need
```

  ↓


```text
About Child
Creates age-based starting context
```

  ↓


```text
Sleep Setup
Provides initial sleep routine before enough real logs exist
```

  ↓


```text
Behaviour Setup
Provides initial known difficult times / concerns
```

  ↓


```text
Family Snapshot
Parent confirms the setup
```

  ↓


```text
Today
Shows general/age-based guidance first
```

  ↓


```text
Real usage begins
Personal child data gradually becomes more important than onboarding assumptions
```


## 5. Today -> Any Quick Update


```text
Today
Shows the most useful current Sleep Forecast / Heads-Up / quick actions
```

  ↓


```text
Parent taps an update
Sleep, Tantrum, Mood, Health or Notes
```

  ↓


```text
Parent saves
Event is stored with date/time
```

  ↓


```text
Energy Bridge checks impact
Which existing output could this event actually affect?
```

  ↓


```text
No meaningful change
Save quietly and return to Today
```

  ↓


```text
Meaningful change
Show Instant Result / updated card
```

  ↓


```text
Today refreshes
Parent sees the newest useful output
```


## 6. Sleep -> Forecast -> Plan -> Pattern


```text
Parent taps Sleep
Opens Sleep Update
```

  ↓


```text
Sleep Update saved
Wake / nap / night waking / quality become a structured sleep event
```

  ↓


```text
Energy Bridge checks sleep logic
Child age + today's sleep + recent personal sleep pattern
```

  ↓


```text
Compare today with baseline
Example: nap was much shorter / wake was earlier than normal
```

  ↓


```text
Recalculate next sleep window
Move earlier/later only if the new information materially changes the estimate
```

  ↓


```text
Set confidence
Enough consistent data = narrower window; limited/unsettled data = wider window
```

  ↓


```text
Sleep Forecast
Shows window + confidence + short reason
```

  ↓


```text
Sleep Details
Explains why the window was calculated
```

  ↓


```text
Tonight's Plan
Turns the forecast into a practical wind-down plan
```

  ↓


```text
Next sleep update
Actual result becomes new data
```

  ↓


```text
Sleep Pattern
Repeated days create longer-term insights
```

  ↓


```text
Journey
Meaningful changes go into Weekly Review / Family Timeline
```


```text
Example: a short nap may pull the settling window earlier. Do not hard-code a fixed minute shift until the science/data team approves the rule.
```


## 7. Tantrum / Behaviour -> Pattern -> Future Heads-Up


```text
Parent taps Tantrum
Opens Tantrum Update
```

  ↓


```text
Tantrum Update saved
Time + intensity + possible trigger + what helped
```

  ↓


```text
Energy Bridge checks behaviour logic
Compares this event with previous difficult moments
```

  ↓


```text
Check repeated timing
Do difficult moments repeatedly cluster around a similar time?
```

  ↓


```text
Check repeated context
Do they often follow short sleep, transitions, hunger, overstimulation or another recorded pattern?
```

  ↓


```text
Not enough pattern
Save the event; do not create a prediction
```

  ↓


```text
Useful repeated pattern
Behaviour Pattern can show common times / triggers / what helped
```

  ↓


```text
Future day matches similar context
Energy Bridge may raise a Calm Heads-Up
```

  ↓


```text
Calm Heads-Up
Uses probabilistic wording: a harder window may be more likely
```

  ↓


```text
Calm Plan
Shows what to try before / during that window
```

  ↓


```text
Parent reflects afterwards
What happened + what helped becomes new data
```

  ↓


```text
Future pattern improves
Energy Bridge uses the outcome next time
```


```text
Calm Heads-Up is not a guaranteed tantrum prediction. It should require a useful repeated combination/pattern.
```


## 8. Mood -> Context, Not an Alarm


```text
Parent taps Mood
Selects child's current mood; parent state is optional
```

  ↓


```text
Mood + timestamp saved
One mood selection is only a context signal
```

  ↓


```text
Energy Bridge checks nearby context
Recent sleep + recent behaviour + time of day
```

  ↓


```text
Mood alone
No alert, no diagnosis, no tantrum prediction
```

  ↓


```text
Repeated combined pattern
May strengthen Brainy context or a future Heads-Up
```

  ↓


```text
Journey
Only meaningful repeated patterns should appear later
```


```text
Example: Fussy alone = save only. Short nap + repeated difficult evening window + current fussiness may strengthen an existing behaviour signal.
```


## 9. Health -> Confidence / Safety


```text
Parent taps Health
Records illness, teething, medication, low appetite etc.
```

  ↓


```text
Health context saved
Explains why today may be unusual
```

  ↓


```text
Energy Bridge checks prediction reliability
Is today's pattern less comparable with normal days?
```

  ↓


```text
If yes
Lower confidence / widen the sleep window instead of pretending precision
```

  ↓


```text
Brainy question arrives
Relevant health context can be included
```

  ↓


```text
Possible safety concern
Stop normal guidance and show professional / emergency route
```

  ↓


```text
No safety concern
Return to normal app guidance
```


## 10. Quick Note -> Memory / Context


```text
Parent adds Quick Note
Example: travel day / grandparents visited / unusual event
```

  ↓


```text
Note saved
Free text is stored as memory/context
```

  ↓


```text
Brainy can use it when relevant
Helps explain the day without asking parent again
```

  ↓


```text
Journey may surface it if meaningful
Example: travel disrupted the routine
```

  ↓


```text
Energy Bridge prediction
Does NOT automatically change from free text alone
```


## 11. Brainy AI -> Personal Answer


```text
Parent asks Brainy
Text or voice
```

  ↓


```text
Brainy requests relevant context
Not the whole database - only useful recent child information
```

  ↓


```text
Backend supplies context
Age + relevant recent sleep / behaviour / mood / health + current goal
```

  ↓


```text
Safety check
Concerning health/safety content routes away from normal AI guidance
```

  ↓


```text
Brainy Answer
What may be happening -> what to try now -> when to get help if relevant
```

  ↓


```text
Parent saves guidance
Saved Guidance becomes available later
```

  ↓


```text
Journey
Saved guidance / action can become part of the ongoing plan
```


## 12. Journey -> Learn Whether Advice Worked


```text
Daily updates accumulate
Sleep / behaviour / meaningful guidance / program progress
```

  ↓


```text
Journey aggregates the week
Do not make raw logs the main experience
```

  ↓


```text
Weekly Review
One positive change + one continuing difficulty + one useful pattern
```

  ↓


```text
Try Recommendation
Choose one small change, not many
```

  ↓


```text
What We're Trying This Week
Stores the experiment + what to observe + review date
```

  ↓


```text
Parent uses normal quick updates
No separate tracking burden
```

  ↓


```text
Review date arrives
Compare this week with previous pattern
```

  ↓


```text
If it helped
Record positive change / continue
```

  ↓


```text
If it did not help
Adjust next experiment or offer extra support
```

  ↓


```text
Family Timeline
Stores meaningful milestones, program starts, changes and harder weeks
```


## 13. Programs -> Structured Support


```text
Repeated difficulty persists
Example: sleep remains inconsistent over time
```

  ↓


```text
Program Recommendation
Shown only when structured support may be useful
```

  ↓


```text
Program List
Parent chooses a relevant program
```

  ↓


```text
Program Detail
Who it is for + duration + support included
```

  ↓


```text
Parent enrols
Program status is saved
```

  ↓


```text
Enrolled Journey
Current week + one thing to try + module + next guide session
```

  ↓


```text
Parent completes weekly actions
Progress and check-ins are stored
```

  ↓


```text
Mentor / program plan
Agreed next action can be added
```

  ↓


```text
Journey
Program progress becomes part of the family's overall story
```


```text
Current final UI fully defines the 6-Week Sleep Journey. Other program categories can follow the same structure when their content is final.
```


## 14. Guided Mentorship -> Human Support


```text
Parent opens Guided Mentorship
From Journey / Program / relevant support area
```

  ↓


```text
Choose Support Area
Sleep / behaviour / parent wellbeing / co-parenting / general parenting
```

  ↓


```text
Guide Profile
Language + experience + session information
```

  ↓


```text
Request Session
Concern + child age + preferred time + language
```

  ↓


```text
Parent chooses summary sharing
Consent decides whether recent LovingBrain summary is shared
```

  ↓


```text
Guide receives summary
Relevant recent pattern / concern / plan - parent does not repeat everything
```

  ↓


```text
Session arranged
External calendar / guide confirmation
```

  ↓


```text
Session happens
Human guide discusses the concern
```

  ↓


```text
Post-Session Plan
Agreed actions are saved
```

  ↓


```text
Journey
Plan + progress become part of weekly review / active goals
```


## 15. Family / Caregiver Sharing


```text
Parent opens Family
Sees linked / pending caregivers
```

  ↓


```text
Parent invites partner / caregiver
Relationship + contact are entered
```

  ↓


```text
Sharing consent shown
Explains what stays private
```

  ↓


```text
Invite pending
No child data is shared yet
```

  ↓


```text
Partner accepts
Caregiver becomes linked
```

  ↓


```text
Permissions selected
Sleep / behaviour / health / plans / mentor summary access is controlled
```

  ↓


```text
Shared Child Summary
Partner sees only permitted information
```

  ↓


```text
Both contribute relevant updates
Each update is attached to the same child timeline
```

  ↓


```text
Energy Bridge sees one shared child timeline
Combines child events regardless of which permitted caregiver entered them
```

  ↓


```text
Today + Journey stay in sync
Both see the permitted shared picture
```


```text
Parent reflections are never shared. Health notes and mentorship summaries remain private unless permission is explicitly enabled.
```


## 16. Notification Logic


```text
A useful app event occurs
Sleep window approaching / weekly review ready / mentor status changed / gentle check-in
```

  ↓


```text
Check notification permission
Is this notification type enabled?
```

  ↓


```text
Check actionability
Is there something useful the parent can do now?
```

  ↓


```text
Check confidence
For prediction-based reminders, is the output reliable enough?
```

  ↓


```text
Check frequency / duplicate
Has a similar notification already been sent recently?
```

  ↓


```text
If any check fails
Do not push - keep the information inside the app
```

  ↓


```text
If all checks pass
Send notification
```

  ↓


```text
Parent taps it
Open the exact relevant screen
```


| Notification -> Destination | Notification -> Destination | Notification -> Destination | Notification -> Destination |
| --- | --- | --- | --- |
| ↓<br>Sleep reminder<br>Sleep / Tonight's Plan | ↓<br>Check-in<br>Today / Quick Update | ↓<br>Mentorship<br>Request / Session | ↓<br>Weekly Review<br>Journey / Weekly Review |


```text
Never send streak guilt, missed-day guilt, duplicates, or an alert just because Mood = Sad/Fussy.
```


## 17. Important State Logic


```text
No data
Show age-based/general guidance -> ask for one useful update
```

  ↓


```text
Low confidence
Show a wider window + explain LovingBrain is still learning
```

  ↓


```text
Save error
Keep the parent's entered data visible -> retry / save locally
```

  ↓


```text
Offline
Show last saved plan -> sync when online
```

  ↓


```text
Safety concern
Stop normal AI flow -> professional / emergency route
```

  ↓


```text
Mentor unavailable
Waitlist / other guide / Ask Brainy
```


## 18. Hardik's Build Rule


```text
1. Parent action
What did the parent record / tap?
```

  ↓


```text
2. Save structured data
What exact event and timestamp should be stored?
```

  ↓


```text
3. Energy Bridge check
Which existing outputs can this event affect?
```

  ↓


```text
4. Confidence + safety
Is there enough reliable data to show a personalised result?
```

  ↓


```text
5. Show next useful screen
Forecast / plan / Heads-Up / Brainy / Journey / nothing new
```

  ↓


```text
6. Notification gate
Only push if useful, enabled, confident and not duplicated
```

  ↓


```text
7. Future learning
The result/outcome becomes data for later patterns
```


```text
If Hardik cannot answer 'what output does this input improve?', the input should usually remain context-only instead of forcing a prediction.
```
