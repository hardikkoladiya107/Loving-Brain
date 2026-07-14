# Sprint 2 — Timeline + Record + Brain AI + Handover

## Tasks

| # | Task | Status | Key files |
|---|------|--------|-----------|
| 1 | Timeline screen | Done | `lib/ui/timeline/`, `lib/repo/timeline_repo.dart` |
| 2 | Quick Record (Feed + Sleep sheet) | Done | `lib/ui/quick_record/` |
| 3 | Brain AI context injection | Done | `lib/content/brain_ai_system_prompt.dart`, `ai_repo.dart` |
| 4 | Co-parent handover + active logger | Done | `handover_sheet.dart`, `home_cubit.dart`, `co_parent_repo.dart` |

## Acceptance tests

| Test | Expected |
|------|----------|
| Log feed | EB resets, Timeline entry |
| Start sleep | State=Tired, EB resets |
| End sleep | Duration + state picker prompt |
| Brain AI | Uses child name + state |
| Handover | Active logger swaps &lt; 3s |
| Co-parent | Same Family Meter during handover |

## PDF rules

- No separate Behaviour screen — use State Picker
- Quick Record is bottom sheet only (Feed + Sleep)
- EB does **not** reset on handover
