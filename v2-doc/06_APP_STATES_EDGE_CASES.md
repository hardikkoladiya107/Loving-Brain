# LOVINGBRAIN — App States & Edge Cases

**What Hardik Should Show When Data Is Missing, Confidence Is Low, Saving Fails, or Limits Are Reached**  
**Developer Handoff for Hardik | Based on Deepak's Final 74-Screen UI**

---


App States & Edge Cases


What Hardik should show when data is missing, confidence is low, saving fails, the user is offline, or a service is unavailable


> **Core rule
Never fake a personalised result. If the app does not have enough information, say so and give a safe next action. A clear empty state is better than a confident-looking guess.**


## 1. Universal state model


| State | User experience | Developer behaviour |
| --- | --- | --- |
| Loading | Skeleton/soft loading state; keep screen title visible. | Fetch last known local state first where possible. |
| Empty | Explain what is missing and why one update helps. | Do not calculate personal prediction. |
| Learning / low confidence | Show wider estimate + honest explanation. | Use general + recent data, mark confidence low. |
| Ready | Show personalised output + “why”. | Use latest valid data and confidence. |
| Save failed | Keep entered values; offer Try again / Save on device. | Do not discard local form state. |
| Offline | Show last saved plan with offline banner. | Queue new logs locally and sync later. |
| Permission denied | Feature works without permission where possible. | Do not loop OS prompt. |
| Service unavailable | Explain and offer alternative route. | No dead-end screen. |


## 2. Onboarding edge cases


| Case | Expected behaviour |
| --- | --- |
| Phone/email invalid | Inline validation; Continue disabled until valid. |
| OTP wrong/expired | Show error + retry/resend; preserve entered phone/email. |
| “More than one” concern | Allow multi-select on same screen; store all selected concerns. |
| Location unavailable | Allow manual city/time-zone selection. |
| Child DOB in future | Block and explain. |
| User goes back | Preserve prior answers. |
| Onboarding interrupted | Resume from last completed step after sign-in. |


## 3. Sleep edge cases


| Case | What parent sees | Logic |
| --- | --- | --- |
| No sleep data | General age guide + Add sleep update. | No personal forecast. |
| 1–3 usable updates | Early personalised estimate; low/moderate confidence. | Wide range; still learning. |
| Recent data inconsistent | Wider window; “less sure tonight.” | Lower confidence. |
| Illness/travel/new setting | What could change this + lower confidence. | Do not overfit normal routine. |
| Log changes forecast | “Update saved — estimate moved…” | Recalculate immediately. |
| Duplicate sleep entry | Ask whether to edit existing or add separate event. | Prevent accidental double counting. |
| Impossible times | Inline validation (end before start, future event etc.). | Do not save invalid interval. |
| No internet during save | Save locally; show pending sync. | Sync when online. |


## 4. Mood / behaviour edge cases


| Case | Expected behaviour |
| --- | --- |
| One sad/fussy mood | Save as context only. No alarm, no diagnosis, no immediate push. |
| Repeated mood pattern | Use in pattern summaries only when there is enough repeated context. |
| Mood conflicts with other signals | Do not force a conclusion; confidence may stay low. |
| Tantrum form partly completed | Allow only required fields to block save; optional trigger/what helped may be skipped if product chooses. |
| Risk window already passed | Do not send predictive push; keep pattern in Journey/History. |
| Parent logs event after the fact | Use timestamp of event, not save time, for pattern analysis. |
| Health flag present | Reduce behaviour/sleep inference confidence; avoid attributing everything to tantrums. |


## 5. Brainy states & safety


| Case | Expected behaviour |
| --- | --- |
| No personal data | Answer generally and say it is not based on the child’s pattern yet. |
| Relevant recent data exists | Use only relevant context; explain the observed pattern. |
| Model/API loading | Show “Looking at the last two weeks…” style loading state. |
| Model/API fails | Friendly retry; do not fabricate response. |
| Concerning health statement | Show safety escalation: contact health professional / emergency services as appropriate. |
| Voice permission denied | Text chat remains available. |
| Conversation history cleared | Remove history from user view and downstream context as defined by privacy implementation. |


## 6. Mentorship edge cases


| Case | Expected behaviour |
| --- | --- |
| No matching mentor | Show other relevant mentors + Brainy option. |
| Mentor fully booked | Waitlist + other guides + Brainy; no charge. |
| External calendar fails | Return user to mentor profile with retry/copy-link option. |
| Parent declines data sharing | Mentor booking still works; do not attach recent summary. |
| Session cancelled | Update app state and notify parent once. |
| Program not purchased / unavailable | Show program information and allowed next action; no broken links. |
| Language unavailable | Clearly show mentor languages before booking; do not promise translation. |


## 7. Family sharing / privacy edge cases


| Case | Expected behaviour |
| --- | --- |
| Invite pending | Nothing shared until accepted; show expiry/status. |
| Invite expired | Offer resend; no access granted. |
| Caregiver accepted | Apply permission defaults; show Manage permissions. |
| Access removed | Revoke immediately on backend and UI. |
| Health/mentorship private by default | Do not share unless parent explicitly enables it. |
| Parent reflections | Never share with caregivers. |
| Delete account | Require confirmation; revoke caregiver access and remove data according to policy. |


## 8. Notification edge cases


If parent logs sleep before scheduled wind-down reminder, cancel reminder if no longer useful.


If recalculation changes the predicted window, cancel old scheduled notification and create the new one only if still relevant.


If user disabled a category, never fall back to another category to send the same message.


If the app is opened while a notification is queued and the action is completed, cancel it.


If confidence becomes low, suppress predictive push and keep the guidance in-app.


## 9. Acceptance checklist for each screen


Happy path works.


Back navigation preserves sensible state.


Loading state exists.


Empty/no-data state exists where relevant.


Save/API failure does not lose parent input.


Offline behaviour is defined.


Permissions denied does not create a dead end.


Deep link from notification lands on the correct screen.


No medical or behavioural conclusion is shown without appropriate context.
