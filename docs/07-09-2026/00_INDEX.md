# LOVINGBRAIN — Developer Handoff Documentation Index

**Date:** 07 September 2026
**Based on:** Deepak's final 74-screen mobile UI (Figma/PDF)
**Prepared for:** Hardik (Developer)

---

## Document Map

All `.docx` source files from the client have been converted to well-structured markdown files. Nothing has been omitted.

| # | File | Source Document | Description |
|---|------|----------------|-------------|
| 1 | [01_COMPLETE_USER_FLOW.md](./01_COMPLETE_USER_FLOW.md) | `LovingBrain_Complete_UserFlow_Developer_Handoff_Hardik_v3_Connected_Logic.docx` | **Master reference.** All 74 screens with interaction contracts, data/state, logic requirements, reads/writes, navigation flows, and simple logic connections. Includes core data objects, decision model, master user flow, and known Figma gaps. |
| 2 | [02_SCREEN_CONNECTION_FLOW.md](./02_SCREEN_CONNECTION_FLOW.md) | `LovingBrain_Simple_Screen_Connection_Flow_Hardik.docx` | How every parent action (tantrum, mood, health, notes, Brainy, Journey, programs, mentorship, family sharing, notifications) flows through the system. Includes Hardik's Build Rule. |
| 3 | [03_NOTIFICATION_ENGAGEMENT_RULES.md](./03_NOTIFICATION_ENGAGEMENT_RULES.md) | `LovingBrain_01_Notification_Engagement_Rules.docx` | Global notification rules, all notification types with triggers/caps/timing, Calm Heads-Up decision rule, permission flow, and developer implementation notes. |
| 4 | [04_ENERGY_BRIDGE_PREDICTION_LOGIC.md](./04_ENERGY_BRIDGE_PREDICTION_LOGIC.md) | `LovingBrain_02_Energy_Bridge_Prediction_Logic.docx` | Energy Bridge input/output mapping, sleep forecast MVP logic, confidence levels, Calm Heads-Up risk signals, parent action effects, simple scoring approach, and safety boundaries. |
| 5 | [05_APP_CONTENT_COPY_MASTER.md](./05_APP_CONTENT_COPY_MASTER.md) | `LovingBrain_03_App_Content_Copy_Master.docx` | Approved tone, core language rules, onboarding copy, Today/Energy Bridge copy states, quick update copy, sleep content patterns, Calm Heads-Up patterns, Brainy response structure, mentorship copy, notification copy bank, error/empty/offline copy bank. |
| 6 | [06_APP_STATES_EDGE_CASES.md](./06_APP_STATES_EDGE_CASES.md) | `LovingBrain_04_App_States_Edge_Cases.docx` | Universal state model, edge cases for onboarding, sleep, mood/behaviour, Brainy/safety, mentorship, family sharing/privacy, notifications, and per-screen acceptance checklist. |

---

## Quick Reference: Where to Find What

| Topic | Primary Document | Supporting Documents |
|-------|-----------------|---------------------|
| Screen-by-screen interaction contracts | `01_COMPLETE_USER_FLOW.md` | — |
| Navigation & screen routing | `01_COMPLETE_USER_FLOW.md` | `02_SCREEN_CONNECTION_FLOW.md` |
| Energy Bridge / prediction logic | `04_ENERGY_BRIDGE_PREDICTION_LOGIC.md` | `01_COMPLETE_USER_FLOW.md` (per-screen logic) |
| Notification rules & timing | `03_NOTIFICATION_ENGAGEMENT_RULES.md` | `02_SCREEN_CONNECTION_FLOW.md` §16 |
| UI copy & content patterns | `05_APP_CONTENT_COPY_MASTER.md` | — |
| Edge cases & error handling | `06_APP_STATES_EDGE_CASES.md` | `01_COMPLETE_USER_FLOW.md` (screens 64–74) |
| Figma/implementation gaps | `01_COMPLETE_USER_FLOW.md` (§Known Gaps) | — |
| Hardik's Build Rule | `02_SCREEN_CONNECTION_FLOW.md` §18 | `01_COMPLETE_USER_FLOW.md` (§Implementation Logic Summary) |
| Family sharing & privacy | `01_COMPLETE_USER_FLOW.md` (screens 54–58) | `06_APP_STATES_EDGE_CASES.md` §7 |
| Mentorship / programs | `01_COMPLETE_USER_FLOW.md` (screens 43–53) | `06_APP_STATES_EDGE_CASES.md` §6 |


