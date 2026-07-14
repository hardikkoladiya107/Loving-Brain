# Section 2 — Energy Bridge Messages

**Source:** PDF Pages 11–13  
**States:** All Good, Gentle Nudge (80–104% threshold), Rest Time (105%+)

Messages change by **time of day**. Replace `Liam` with `{childName}`.

## State 1 — All Good (no action needed)

| Time window | Main message | Supporting text | Reassurance bar |
|-------------|--------------|-----------------|-----------------|
| Morning (before 12pm) | You're on top of it! | {childName} is doing great this morning. No action needed. | You've got this |
| Afternoon (12pm–5pm) | All good right now. | {childName} has plenty of good energy left in the tank. | Enjoying the afternoon |
| Evening (after 5pm) | {childName} is doing well tonight. | Still in a good window. Wind-down time is coming but not yet. | A calm evening ahead |

## State 2 — Gentle Nudge (wind down soon)

| Time window | Main message | Button CTA |
|-------------|--------------|------------|
| Morning (before 12pm) | A quiet moment soon will help. | Show me a calm activity |
| Nap window (11am–2pm) | Getting close to nap window. | Help me wind him down |
| Afternoon (2pm–5pm) | Heads up — {childName} may need a break soon. | Show me what to do |
| Pre-bedtime (5pm–7pm) | Wind-down time is approaching. | Start the wind-down |
| Late evening (after 7pm) | Bedtime is not far away. | Help me settle him |

## State 3 — Rest Time (threshold reached)

Always positive — celebrate the child, never alarm the parent.

| Time window | Main message | Button CTA |
|-------------|--------------|------------|
| Morning | {childName} did so well this morning! | Help me give him a calm moment |
| Nap time (11am–2pm) | {childName} is ready for his nap. | Help me settle him for a nap |
| Afternoon | Time for a calm moment. | Give {childName} a calm moment |
| Pre-bedtime (5pm–7pm) | {childName} is ready for bed. | Start bedtime routine |
| Late evening (after 7pm) | {childName} is ready to sleep. | Help me settle him |

**Implementation note:** PDF says "Hardik will handle which message shows when" — map time-of-day in app logic (see `lib/core/home_time_greeting.dart` pattern).
