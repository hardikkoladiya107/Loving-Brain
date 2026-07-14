# Sprint 1 — Home Screen + Energy Bridge

## Tasks

| # | Task | Status | Key files |
|---|------|--------|-----------|
| 1 | Family Meter card | Done | `lib/ui/home/home_screen.dart`, `family_meter_*` |
| 2 | Smart Action card | Done | embedded in home card |
| 3 | Smart Moment | Partial | `smart_moment_*`, `assets/content/smart_moment_content.json` |
| 4 | Help flow | Done | `help_flow_*`, `part4_help_guidance.json` |
| 5 | Push (105m FCM) | Code done | `functions/triggers/energyBridgeSchedulerTriggers.js` — **deploy + QA** |
| 6 | Onboarding DOB | Done | `child_profile_screen.dart`, `age_utils.dart` |

## Acceptance tests (must pass before Sprint 2)

| Test | Expected |
|------|----------|
| Log High Energy | Countdown on home |
| Log Calm after High Energy | Countdown gone |
| 105 min, app killed | FCM both parents |
| Smart Action Calm | "{name} is ready to connect" + Guide |
| Smart Action Fussy | "{name} needs support" + Help |
| I tried this | Event `outcome=success` |
| Still not working | Different solution |
| Co-parent state update | &lt; 3 seconds |
| DOB onboarding | `age_in_months` correct |

## Remaining gaps

- Deploy Cloud Functions for server-side 105m fire (`docs/DEPLOY_QA_CHECKLIST.md`)
- Manual 2-device QA (FCM, handover, co-parent sync)
