# Part 4 — Firebase data model

| PDF collection | App path | Notes |
|----------------|----------|-------|
| users | `users/{uid}` | Add `is_active_logger`, `partner_user_id` Sprint 2 |
| children | `children/{id}` | `child_state`, `child_dob`, `last_feed_time` |
| states | `children/{id}/states/*` | Audit trail (not top-level) |
| energy_bridge | `energy_bridge/{childId}` | One doc per child |
| events | `children/{id}/events/*` | smart_moment, help_flow, feed, sleep |
| milestones | `milestones/{id}` | Sprint 3 |
