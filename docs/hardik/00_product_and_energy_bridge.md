# Part 1–2 — Product + Energy Bridge

## Product (one sentence)

LovingBrain watches the child's state, predicts what happens next, and tells the parent what to do right now.

## Energy Bridge rules (build exactly)

| Rule | Behaviour |
|------|-----------|
| START | Parent logs High Energy → 105 min timer |
| DISPLAY | `~X mins before shift` on Family Meter |
| RESET | Calm, Fussy, Tired, Feed, Sleep start |
| FIRE | 105 min with no reset |
| ON FIRE | FCM both parents + amber card on home |
| HANDOVER | Timer continues (Sprint 2) |

## Firestore: `energy_bridge/{child_id}`

`is_active`, `started_at`, `duration_minutes` (105), `fired`, `fired_at`, `last_reset_at`, `reset_reason`

Implementation: `lib/repo/energy_bridge_repo.dart`
