# Deploy & QA checklist

## 1. Firestore indexes

```bash
firebase deploy --only firestore:indexes
```

Required for:
- `milestones` — `child_id` + `timestamp` (Journey tab)

## 2. Cloud Functions (105-min Energy Bridge push)

```bash
cd functions && npm test && cd ..
firebase deploy --only functions
```

## 3. Sprint 1 acceptance (2 devices, co-parent linked)

| Test | Steps | Pass |
|------|-------|------|
| High Energy countdown | Log High Energy → home shows timer | ☐ |
| Calm resets timer | Log Calm after High Energy → timer gone | ☐ |
| 105 min FCM | High Energy, kill app 105+ min | ☐ |
| Co-parent sync | Parent A updates state → Parent B &lt; 3s | ☐ |
| Handover | Active logger hands over → viewer cannot update state | ☐ |

## 4. Sprint 3 milestone flow

| Test | Steps | Pass |
|------|-------|------|
| Smart Moment → Yes | Opens milestone story | ☐ |
| I saw it | Generates + saves to Journey | ☐ |
| Chapter unlock | Saved milestone unlocks matching chapter | ☐ |
| Export | All 5 chapters → share PDF via system sheet | ☐ |
| Milestone picker | Smart Moment Yes → choose milestone type | ☐ |
| Help 3 suggestions | Each problem × age band returns 3 options | ☐ |
