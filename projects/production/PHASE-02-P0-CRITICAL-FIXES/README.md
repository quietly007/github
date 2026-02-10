# PHASE 02: P0 Critical Fixes

**Goal:** Fix ALL broken services - Get to 100% working  
**Time:** 6-8 hours  
**Target Grade:** 75/100

## CRITICAL FIXES (P0)

1. **Restart Prometheus** (currently DOWN - Exit 255)
2. **Fix Alertmanager** (timeout issues)
3. **Install Nextcloud** (109 errors - Not installed)
4. **Fix redis** (connection errors to 172.28.1.249:6379)
5. **Fix routing issues** (identify and fix 3 broken routes)

## SUCCESS CRITERIA

✅ Prometheus: UP and accessible (http://localhost:9090)  
✅ Alertmanager: Responds without timeout  
✅ Nextcloud: Installed and login works  
✅ Redis: Connection working  
✅ All routing: 17/17 services accessible  

## DELIVERABLE

**Save ALL work in this folder:** `PHASE-02-P0-CRITICAL-FIXES/`

Files to create:
- `P0_FIXES_REPORT.md` - What was fixed and how
- Service restart logs
- Verification results (17/17 services tested)

**After completing:** Test ALL 17 services → Ask: "Phase 02 done. All services 100% working? (Y/N)"

## WHAT HAPPENS NEXT

If user approves → User sends you: **PHASE-03-GOVERNANCE** folder
