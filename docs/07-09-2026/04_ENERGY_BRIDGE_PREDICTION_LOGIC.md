# LOVINGBRAIN — Energy Bridge & Prediction Logic

**Simple Product Logic for Sleep Forecasting, Calm Heads-Up, Confidence, and How Parent Updates Change the App**
**Developer Handoff for Hardik | Based on Deepak's Final 74-Screen UI**

---

## What Energy Bridge Is

> Energy Bridge is the logic layer connecting parent updates to useful next steps. Parents should not feel they are "tracking for tracking's sake." Every useful log should either improve a prediction, explain a pattern, personalise Brainy, or improve mentorship context.

---

## 1. Inputs → Logic → Outputs

| Input | What It Tells the App | Main Connections |
|-------|----------------------|-----------------|
| **Child age / DOB** | Age-based baseline only; not personalised yet. | Sleep baseline, age guidance |
| **Usual wake / bedtime / naps** | Starting rhythm before enough real logs exist. | Initial sleep estimate |
| **Sleep updates** | Actual wake, nap, bedtime/night waking, quality. | Next sleep window, confidence, sleep pattern, tantrum context |
| **Feed update** | Recency/type of feeding where included in MVP. | Hunger context for Calm Heads-Up; mentor/Brainy context |
| **Mood** | Current child state; parent mood optional. | Risk context, Brainy context, weekly patterns |
| **Tantrum/behaviour update** | What happened, time, intensity, possible trigger, what helped. | Behaviour Pattern, future risk windows, Calm Plan |
| **Health context** | Teething/illness/medication/low appetite etc. | Lowers prediction confidence; prevents overconfident advice |
| **Onboarding concern + goal** | What the parent wants help with. | Prioritises Today cards, Brainy suggestions, program recommendations |

---

## 2. Sleep Forecast: MVP Logic

> **Start honest, then personalise.**
> With no real sleep data, show a general age-based guide. After 1 update, begin personalising. After 2–3 useful updates, show the child's own window with low/moderate confidence. Around 10 recent nights can support sharper confidence if the pattern is consistent.

### Key Rules

- **Baseline** = age band + usual wake/bedtime from onboarding.
- Recent real sleep data always has more weight than onboarding estimates.
- Shorter-than-usual nap or earlier wake can shift the next settling window **earlier**.
- Long/late nap can shift the next window **later**.
- Illness, travel, a new setting, or inconsistent recent data should **widen the window** and **reduce confidence**.
- Never show a precise time when data does not justify it; show a wider range instead.

---

## 3. Confidence Levels

| Level | When to Use | UI Behaviour |
|-------|------------|--------------|
| **General / no confidence** | No personal sleep data. | Say this is a general age guide; ask for an update. |
| **Low** | Very few recent logs, inconsistent pattern, or disruptive context. | Wide range; "still learning this pattern"; no predictive push. |
| **Moderate** | Several recent usable updates with some consistency. | Normal range; explain "why"; sleep reminder allowed. |
| **High** | Sufficient recent data and stable pattern with no strong disruptor. | Narrower range; strong explanation; still avoid guaranteed language. |

---

## 4. Calm Heads-Up / Tantrum Risk

### Language Rule

> Internally Hardik can calculate a risk score. In the parent UI, avoid "a tantrum will happen." Use **"a harder window may be more likely"** and explain the contributing signals.

### Signal Contributions

| Signal | Example | Effect |
|--------|---------|--------|
| **Sleep pressure** | Short/skip nap, long wake window, poor night sleep | Raises risk |
| **Hunger/feed context** | Long interval since last relevant feed / parent-selected hunger trigger | Raises risk |
| **Mood** | Fussy/sad/overwhelmed state | Raises risk slightly; **never enough alone** |
| **Known difficult time** | Onboarding or repeated logs show evenings/transitions/public outings are hard | Raises risk in matching context |
| **Repeated behaviour pattern** | Past moments cluster in same time/context | Raises risk |
| **Overstimulation/routine change** | Parent logged trigger or context | Raises risk |
| **Calm/playful mood + recent rest/feed** | Counter-signals | **Can lower risk** |
| **Illness/health concern** | Makes behavioural prediction less reliable | **Lower confidence**; prefer health/safety guidance |

---

## 5. What Happens After Each Common Parent Action

| Parent Action | App Stores | App Recalculates / Changes | Parent Sees Later |
|--------------|-----------|---------------------------|-------------------|
| **Logs Sleep** | timestamps, duration, quality, waking | sleep window + confidence; behaviour risk context | updated sleep plan, pattern, possible sleep reminder |
| **Logs Feed** | time/type/amount where used | hunger context | may change explanation behind a Calm Heads-Up |
| **Taps Mood = Sad/Fussy** | child mood + timestamp | context score only; checks combination with sleep/feed/time | usually no immediate alert; may influence Today, Brainy, weekly pattern |
| **Logs Tantrum** | time, intensity, trigger, what helped | behaviour pattern counts + future context | better Calm Plan and pattern explanation |
| **Adds Health context** | health flag + note | reduce confidence; suppress overconfident sleep/behaviour inference | honest caveat; Brainy may route to safety if needed |
| **Changes onboarding goal** | new priority | re-rank focus / recommendations | more relevant Today/Brainy/program suggestions |

---

## 6. Simple Scoring Approach for MVP

### Implementation Approach

> Use transparent rules first. Do not wait for machine learning. Hardik should keep each contributing signal inspectable so the UI can explain "why."

1. Create a small score per signal (e.g. sleep pressure, hunger context, mood, known trigger/time pattern).
2. Combine signals only when they are recent and relevant to the current window.
3. Use thresholds for **Low / Moderate / Higher** risk internally.
4. Store which signals contributed, so the Calm Heads-Up can display 1–2 human-readable reasons.
5. Recalculate after any relevant log.
6. As data grows, rules can later be replaced or tuned without changing the UI contract.

---

## 7. Safety Boundaries

- Energy Bridge is **not** a medical diagnostic engine.
- Health red flags entered into Brainy should route to the safety response, not be interpreted as tantrum/sleep causes.
- No single mood, feed, or sleep event should create a strong behavioural conclusion.
- Recommendations should be framed as practical things to try, not guarantees.
