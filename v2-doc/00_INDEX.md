# LOVINGBRAIN — V2 Complete Developer Documentation Suite

**Master Reference & Architecture Map for Hardik (Developer)**  
**Source:** Official Client Specification Package (`/Users/imac/Documents/LovingBrain/05-09-2026`)  
**Design Reference:** Deepak's Final 74-Screen Mobile UI (Figma/PDF)  
**Date:** September 2026 (V2 Functional Specification)

---

## 1. Document Map

All 6 official client `.docx` specifications from `/Users/imac/Documents/LovingBrain/05-09-2026` have been fully converted into structured, high-fidelity Markdown documents in this `v2-doc/` directory with 100% of data, logic contracts, tables, and flows preserved.

| # | Document | Source Document | Scope & Purpose |
|---|----------|-----------------|-----------------|
| **01** | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) | `LovingBrain_Complete_UserFlow_Developer_Handoff_Hardik_v3_Connected_Logic.docx` | **The Master Specification.** Comprehensive breakdown of all 74 screens: screen purpose, tap/interaction contracts, logic requirements, reads/writes, why it matters to the parent, simple logic connections, core data objects, decision model, and known Figma gaps. |
| **02** | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) | `LovingBrain_Simple_Screen_Connection_Flow_Hardik.docx` | **Connected Feature Logic (All 18 Sections).** Step-by-step connection flow for every parent action: Main Loop, Energy Bridge backend role, Onboarding baseline, Quick Updates (Sleep, Tantrum, Mood, Health, Notes), Brainy AI, Journey, Programs, Mentorship, Family Sharing, Notification triggers, State logic, and Hardik's Build Rule. |
| **03** | [03_NOTIFICATION_ENGAGEMENT_RULES.md](./03_NOTIFICATION_ENGAGEMENT_RULES.md) | `LovingBrain_Hardik_Developer_Pack_4_Documents/LovingBrain_01_Notification_Engagement_Rules.docx` | **Engagement & Push Notification System.** Global notification limits (max 3/day, 0-2 typical), quiet hours, exact triggers/caps/timing/deep-links for all 8 notification types, Calm Heads-Up decision rules, permission flow, and developer implementation notes. |
| **04** | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) | `LovingBrain_Hardik_Developer_Pack_4_Documents/LovingBrain_02_Energy_Bridge_Prediction_Logic.docx` | **Prediction Engine & Data Processing.** Inputs → Logic → Outputs mapping, Sleep Forecast MVP calculation rules, confidence levels (None/Low/Moderate/High), Calm Heads-Up risk signals, parent action consequences, simple scoring approach, and clinical safety boundaries. |
| **05** | [05_APP_CONTENT_COPY_MASTER.md](./05_APP_CONTENT_COPY_MASTER.md) | `LovingBrain_Hardik_Developer_Pack_4_Documents/LovingBrain_03_App_Content_Copy_Master.docx` | **Approved Content & Copy Banks.** Core tone and non-judgmental language rules, Onboarding screen copy, Today / Energy Bridge headline states, Quick Update prompts, Sleep pattern wording, Calm Heads-Up copy blocks, Brainy 3-part response structure, Mentorship copy, and full Error/Empty/Offline copy banks. |
| **06** | [06_APP_STATES_EDGE_CASES.md](./06_APP_STATES_EDGE_CASES.md) | `LovingBrain_Hardik_Developer_Pack_4_Documents/LovingBrain_04_App_States_Edge_Cases.docx` | **Resilience, Edge Cases & Acceptance.** Universal 8-state model (Loading, Empty, Learning, Ready, Save failed, Offline, Permission denied, Service unavailable), detailed edge-case handling per feature, notification edge cases, and the 9-point per-screen acceptance checklist. |

---

## 2. Quick Reference: Where to Find What

| Topic / Requirement | Primary Document | Supporting Documents |
|---------------------|------------------|----------------------|
| **Screen-by-screen specifications (all 74 screens)** | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) | — |
| **Complete interaction & tap contracts** | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) |
| **Energy Bridge backend calculation & prediction** | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§2, §3) |
| **Sleep forecast & settling window calculations** | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) (§2) | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) (Screens 23–27) |
| **Calm Heads-Up / tantrum prediction rules** | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) (§4) | [03_NOTIFICATION_ENGAGEMENT_RULES.md](./03_NOTIFICATION_ENGAGEMENT_RULES.md) (§3) |
| **Notification triggers, caps, quiet hours & timing** | [03_NOTIFICATION_ENGAGEMENT_RULES.md](./03_NOTIFICATION_ENGAGEMENT_RULES.md) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§16) |
| **Exact copy, prompts, titles & CTA wording** | [05_APP_CONTENT_COPY_MASTER.md](./05_APP_CONTENT_COPY_MASTER.md) | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) |
| **Empty, loading, offline, and error states** | [06_APP_STATES_EDGE_CASES.md](./06_APP_STATES_EDGE_CASES.md) | [05_APP_CONTENT_COPY_MASTER.md](./05_APP_CONTENT_COPY_MASTER.md) (§10) |
| **Brainy AI context injection & 3-part answer format** | [05_APP_CONTENT_COPY_MASTER.md](./05_APP_CONTENT_COPY_MASTER.md) (§7) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§11) |
| **Safety escalation & medical boundary rules** | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) (§7) | [06_APP_STATES_EDGE_CASES.md](./06_APP_STATES_EDGE_CASES.md) (§5) |
| **Family sharing & caregiver privacy controls** | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) (Screens 54–58) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§15) |
| **Guided mentorship & program bookings** | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) (Screens 43–53) | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§13, §14) |
| **Hardik's Build Rule & development principles** | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) (§18) | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) (§Implementation Summary) |

---

## 3. Core Architecture & Development Rules

### Rule 1: Visual Source of Truth
Deepak's final Figma/PDF prototype remains the visual source of truth. **Do not redesign screens or change visual themes while building functionality.**

### Rule 2: Navigation Structure Stays Fixed
The main app navigation is permanently anchored around three tabs:
$$\text{Today} \longleftrightarrow \text{Brainy AI} \longleftrightarrow \text{Journey}$$

### Rule 3: Energy Bridge is Backend Logic, Not a Screen
Energy Bridge is the shared backend data intelligence layer that takes structured parent logs, computes context, evaluates confidence, and produces actionable insights for the existing screens. It is **never** a standalone screen.

### Rule 4: Data Must Create Parent Value
Avoid "tracking for tracking's sake." Every parent update must directly feed one of the following:
1. An improved sleep forecast or settling window
2. An actionable Calm Heads-Up or plan
3. A personalized context injection for Brainy AI
4. A meaningful milestone or trend in Journey
5. Clear clinical context for a mentor session

### Rule 5: Transparent Rule-Based MVP
Machine learning is **not** required for MVP. Use transparent, inspectable business rules with weighted signals (sleep pressure, wake duration, hunger, mood, past patterns). Keep rules inspectable so the UI can explain *why* an insight was shown.

### Rule 6: Absolute Trust & Honest Uncertainty
If data is insufficient, **never fake precision**. Show dedicated no-data or learning states with a broader estimated window, explain why, and prompt for the single update that would sharpen confidence.

### Rule 7: Zero Data Loss on Failure
On network failure, timeout, or validation error, **never discard form inputs**. Persist drafts locally and provide offline sync capabilities.
