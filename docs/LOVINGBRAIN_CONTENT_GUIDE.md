# LovingBrain Content Guide — Reference Index

**Source:** `LovingBrain_ContentGuide.pdf` (April 2025, 28 pages, Confidential)  
**Purpose:** Single reference for all app copy. Replace `{childName}`, `{parentName}`, `{coParentName}` at runtime. Replace hardcoded "Liam" / "Aswin" from the PDF.

## How to use this in the codebase

| Section | App feature | Reference file | Machine-readable |
|--------|-------------|----------------|------------------|
| 1 | Daily parenting tips / morning push | [section_1_daily_insights.md](content/section_1_daily_insights.md) | [assets/content/daily_insights.json](../assets/content/daily_insights.json) |
| 2 | Energy Bridge card messages | [section_2_energy_bridge_messages.md](content/section_2_energy_bridge_messages.md) | [assets/content/energy_bridge_messages.json](../assets/content/energy_bridge_messages.json) |
| 3 | Push notification copy | [section_3_push_notifications.md](content/section_3_push_notifications.md) | [assets/content/push_notifications.json](../assets/content/push_notifications.json) |
| 4 | Help Me Now flow (Sprint 1) | [section_4_help_guidance.md](content/section_4_help_guidance.md) | [assets/content/part4_help_guidance.json](../assets/content/part4_help_guidance.json) |
| 5 | Milestone stories (Sprint 3+) | [section_5_milestones.md](content/section_5_milestones.md) | [assets/content/milestones.json](../assets/content/milestones.json) |
| 6 | Onboarding screens | [section_6_onboarding.md](content/section_6_onboarding.md) | [assets/content/onboarding_copy.json](../assets/content/onboarding_copy.json) |

**Clinical rule (all sections):** Content marked clinical must be approved before `clinicalValidated: true` in JSON or going live.

**Smart Moment content:** Not in this PDF. Sprint 1 Smart Moment stays on current in-app copy until the Sprint PDF / separate guide is added.

---

## Sprint 1 Help flow mapping (4 UI cards → Section 4)

| App `problemKey` | UI label | Section 4 problem |
|------------------|----------|-------------------|
| `crying` | Crying | Problem 1 — He won't stop crying |
| `wont_sleep` | Won't sleep | Problem 2 — He won't sleep |
| `feeding_issue` | Feeding issue | Problem 3 — He won't eat |
| `too_fussy` | Too fussy | **Fallback:** Problem 1 / `0_6` suggestions (rotate 1→2→3) |

### Age bands (Help Guidance)

| Key | Months | Label |
|-----|--------|-------|
| `0_6` | 0–6 | 0 to 6 months |
| `6_18` | 7–18 | 6 to 18 months |
| `18_36` | 19–36 | 18 to 36 months (Toddler) |
| `36_plus` | 37+ | TBD — not in PDF |

### Help content rules

- 3 suggestions per problem per age band (when complete); each suggestion = **2 steps** + tips + fallback.
- Parent taps **Still not working** → next suggestion (max 3, then escalation).
- Every step doable with **one hand free**; never leave baby alone; **no medical language**.

---

## Section summaries

### Section 1 — Daily Insights
- **36 monthly insights** (Month 0–35), sent as morning push at 8am.
- Format: 2–3 sentences, second person, age-specific, warm.
- Stages: Newborn (0–5), Baby (6–17), Toddler (18–35).

### Section 2 — Energy Bridge Messages
- **3 states:** All Good, Gentle Nudge, Rest Time (105% threshold).
- Copy varies by **time of day** (morning / nap window / afternoon / pre-bedtime / late evening).
- Tone: warm, never scary; celebrate the child at Rest Time.

### Section 3 — Push Notifications
- Title ≤6 words; body one sentence; warm and actionable.
- Types: daily insight, Energy Bridge state change, milestone window, feed/sleep reminders, co-parent handover, story ready, 3rd birthday.

### Section 4 — Help Guidance
- **5 problems** in PDF; Sprint 1 UI uses **4 cards** (see mapping above).
- PDF includes partial coverage — see [section_4_help_guidance.md](content/section_4_help_guidance.md) TBD table.

### Section 5 — Milestones
- PDF documents **sample** milestones (not all 23): First Smile, First Word, Explorer, Walker, Pointer, Laugher, Emotion Namer, Big Kid.
- Each: `whatThisMeans` (parent screen) + `storyPrompt` (Claude API).

### Section 6 — Onboarding
- Welcome screen, Energy Bridge explainer (first High Energy), All Done screen.
- Full strings in [section_6_onboarding.md](content/section_6_onboarding.md).

---

## Maintenance

1. When clinical partner approves content, set `clinicalValidated: true` in the JSON entry and record validator name in the markdown.
2. When new PDF pages arrive, update the matching `section_*.md` + JSON; append TBD rows as `complete`.
3. Do not re-send screenshots — this repo is the source of truth.
