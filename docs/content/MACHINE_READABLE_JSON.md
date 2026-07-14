# Machine-readable JSON (pending copy to assets/)

When Sprint 1 execution starts, copy generated JSON from this doc set into:

```
assets/content/part4_help_guidance.json
assets/content/daily_insights.json
assets/content/energy_bridge_messages.json
assets/content/push_notifications.json
assets/content/milestones.json
assets/content/onboarding_copy.json
```

**Source of truth for Help flow (Sprint 1):** [section_4_help_guidance.md](section_4_help_guidance.md) — structure matches `part4_help_guidance.json` schema in the Sprint 1 plan.

**Resolver API (to implement):**

```dart
// lib/content/help_guidance_content.dart
HelpGuidanceSuggestion resolveHelpGuidance({
  required String problemKey,  // crying | wont_sleep | feeding_issue | too_fussy
  required int ageInMonths,
  required int suggestionIndex, // 1-based
  required String childName,
});
```

**Age band resolution:**

```dart
String ageBandKey(int ageInMonths) {
  if (ageInMonths <= 6) return '0_6';
  if (ageInMonths <= 18) return '6_18';
  if (ageInMonths <= 36) return '18_36';
  return '36_plus'; // TBD content
}
```

**too_fussy fallback:** use `crying` + `0_6` suggestions when no dedicated content.
