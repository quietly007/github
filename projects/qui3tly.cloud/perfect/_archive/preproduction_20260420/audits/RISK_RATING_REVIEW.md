# RISK RATING REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent
Method: Re-score each finding: Likelihood (1-3) x Impact (1-4). Compare against original P0/P1/P2 classification.

Scoring: Risk = Likelihood x Impact
  10-12 = P0 (Critical Blocker)
  6-9   = P1 (High Priority)
  3-5   = P2 (Medium)
  1-2   = P3 (Low)

---

## Re-Scored Findings

| ID   | Finding                              | Original | Likelihood | Impact    | Score | External |
|------|--------------------------------------|----------|------------|-----------|-------|----------|
| 1    | Lady patch backlog                   | P0       | High (3)   | Crit (4)  | 12    | P0       |
| 2    | Lady backup posture                  | P0       | Med (2)    | Crit (4)  | 8     | P0       |
| 3    | Unscoped listeners Lady              | P0       | High (3)   | High (3)  | 9     | P0 ↑    |
| 4    | Master AIDE failure                  | P1       | Med (2)    | High (3)  | 6     | P1       |
| 5    | Container resource governance        | P1       | Med (2)    | High (3)  | 6     | P1       |
| 6    | Traefik hardening verification       | P1       | Med (2)    | High (3)  | 6     | P1 (?)   |
| 7    | Sysctl hardening drift               | P2       | Low (1)    | Med (2)   | 2     | P2       |
| 8    | Container root minimization          | P2       | Low (1)    | High (3)  | 3     | P2       |
| 9    | Image lifecycle hygiene              | P2       | Med (2)    | Med (2)   | 4     | P2       |
| AC-1 | Lady UFW broad rules (NEW)          | —        | Med (2)    | High (3)  | 6     | P1       |
| AC-2 | python3:5000 unidentified (NEW)     | —        | High (3)   | High (3)  | 9     | P0       |
| AC-3 | Master load avg elevated (NEW)      | —        | Med (2)    | Med (2)   | 4     | P2       |
| AC-4 | Nextcloud unexplained restart (NEW) | —        | Med (2)    | Med (2)   | 4     | P2       |

---

## Key Rating Decisions

### Finding 1 (Lady Patching) — Score 12, P0 confirmed
Maximum risk score. 61-day unpatched internet-facing node with open SMTP is in the actively-exploited threat model. Not a theoretical risk.

### Finding 2 (Lady Backups) — Score 8, P0 confirmed
Lower probability than Finding 1 (disk failure is not daily), but consequence is catastrophic and irreversible. P0 is appropriate: you cannot "undo" a no-backup failure after the fact.

### Finding 3 (Listeners) — Score 9, P0 upgraded
Original report was correct in class but understated scope. External review found 7 listeners (vs vague reference). AC-2 (python3:5000) adds an independent unidentified process — rated separately at P0.

### Finding 5 (Container Limits) — Score 6, P1 confirmed
Would escalate to P0 if OOM events or memory exhaustion evidenced. Current evidence shows 42Gi/38Gi available on both nodes — not immediately dangerous, but the lack of limits is a stability risk that must be addressed before production.

### Finding 6 (Traefik) — Score 6, P1 held (Needs Validation)
Held at P1 as a forcing function. Cannot be confirmed or cleared without Traefik config output. If config review finds issues, this would become P0.

---

## Priority Summary

| Priority | Findings                              | Count |
|----------|---------------------------------------|-------|
| P0       | 1, 2, 3, AC-2                         | 4     |
| P1       | 4, 5, 6, AC-1                         | 4     |
| P2       | 7, 8, 9, AC-3, AC-4                   | 5     |

External review adds: 1 finding to P0 (AC-2), 1 finding to P1 (AC-1), 2 findings to P2 (AC-3, AC-4) vs original internal report.
