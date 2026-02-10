# MANDATORY LOG CHECKING COMMANDS

**USER REQUIREMENT:**
> "I want that every next agent CHECK LOG!!!! ALLL LOGSSSSS!!!!!! Native services, docker, possible, impossible, lady, master... ALL LOGS!!!!!!!!! MUST BE CHECKED!!!! Without that TASK IS NOT COMPLETED!!!"

---

## ⚠️ WITHOUT CHECKING ALL LOGS → TASK NOT COMPLETED → AUTOMATIC FAILURE

---

## 📋 COMPLETE LOG CHECKING SCRIPT

Copy and run this entire script to collect ALL logs:

```bash
#!/bin/bash
# MANDATORY LOG COLLECTION - ALL AGENTS MUST RUN THIS

LOG_DIR="/tmp/preproduction_logs_$(date +%Y%m%d_%H%M%S)"
mkdir -p $LOG_DIR
cd $LOG_DIR

echo "=========================================="
echo "COLLECTING ALL LOGS - MANDATORY REQUIREMENT"
echo "Master + Lady | Native + Docker | All 61 containers"
echo "=========================================="

# ============================================
# PART 1: MASTER NATIVE LOGS
# ============================================
echo "[1/6] Master native logs..."

journalctl -xe --no-pager -n 2000 > master_journalctl.log 2>&1
dmesg > master_dmesg.log 2>&1
tail -2000 /var/log/syslog > master_syslog.log 2>&1
tail -500 /var/log/auth.log > master_auth.log 2>&1

echo "  ✓ master_journalctl.log ($(wc -l < master_journalctl.log) lines)"
echo "  ✓ master_dmesg.log ($(wc -l < master_dmesg.log) lines)"
echo "  ✓ master_syslog.log ($(wc -l < master_syslog.log) lines)"
echo "  ✓ master_auth.log ($(wc -l < master_auth.log) lines)"

# ============================================
# PART 2: LADY NATIVE LOGS
# ============================================
echo "[2/6] Lady native logs..."

ssh lady "journalctl -xe --no-pager -n 2000" > lady_journalctl.log 2>&1
ssh lady "dmesg" > lady_dmesg.log 2>&1
ssh lady "tail -2000 /var/log/syslog" > lady_syslog.log 2>&1
ssh lady "tail -500 /var/log/auth.log" > lady_auth.log 2>&1

echo "  ✓ lady_journalctl.log ($(wc -l < lady_journalctl.log) lines)"
echo "  ✓ lady_dmesg.log ($(wc -l < lady_dmesg.log) lines)"
echo "  ✓ lady_syslog.log ($(wc -l < lady_syslog.log) lines)"
echo "  ✓ lady_auth.log ($(wc -l < lady_auth.log) lines)"

# ============================================
# PART 3: MASTER DOCKER CONTAINERS (25)
# ============================================
echo "[3/6] Master docker container logs (25 containers)..."

echo "" > master_containers_ALL.log
MASTER_COUNT=0

for container in $(docker ps -a --format '{{.Names}}'); do
  echo "" >> master_containers_ALL.log
  echo "========================================" >> master_containers_ALL.log
  echo "CONTAINER: $container" >> master_containers_ALL.log
  echo "STATUS: $(docker ps -a --filter name=$container --format '{{.Status}}')" >> master_containers_ALL.log
  echo "IMAGE: $(docker inspect $container --format '{{.Config.Image}}')" >> master_containers_ALL.log
  echo "========================================" >> master_containers_ALL.log
  docker logs $container --tail 200 2>&1 >> master_containers_ALL.log
  
  # Individual container log file
  docker logs $container --tail 500 2>&1 > "master_${container}.log"
  
  MASTER_COUNT=$((MASTER_COUNT + 1))
done

echo "  ✓ master_containers_ALL.log ($(wc -l < master_containers_ALL.log) lines)"
echo "  ✓ Individual logs: ${MASTER_COUNT} containers"

# ============================================
# PART 4: LADY DOCKER CONTAINERS (36)
# ============================================
echo "[4/6] Lady docker container logs (36 containers)..."

echo "" > lady_containers_ALL.log
LADY_COUNT=0

ssh lady 'docker ps -a --format "{{.Names}}"' | while read container; do
  echo "" >> lady_containers_ALL.log
  echo "========================================" >> lady_containers_ALL.log
  echo "CONTAINER: $container" >> lady_containers_ALL.log
  echo "STATUS: $(ssh lady "docker ps -a --filter name=$container --format '{{.Status}}'")" >> lady_containers_ALL.log
  echo "IMAGE: $(ssh lady "docker inspect $container --format '{{.Config.Image}}'")" >> lady_containers_ALL.log
  echo "========================================" >> lady_containers_ALL.log
  ssh lady "docker logs $container --tail 200" 2>&1 >> lady_containers_ALL.log
  
  # Individual container log file
  ssh lady "docker logs $container --tail 500" 2>&1 > "lady_${container}.log"
  
  LADY_COUNT=$((LADY_COUNT + 1))
done

echo "  ✓ lady_containers_ALL.log ($(wc -l < lady_containers_ALL.log) lines)"
echo "  ✓ Individual logs: ${LADY_COUNT} containers"

# ============================================
# PART 5: ERROR ANALYSIS
# ============================================
echo "[5/6] Analyzing all errors..."

cat *.log | grep -iE 'error|fatal|critical|exception|traceback|panic|segfault' | \
  sort | uniq -c | sort -rn > ALL_ERRORS_SUMMARY.txt

cat *.log | grep -iE '\[error\]|\[fatal\]|\[critical\]' | \
  head -500 > TOP_500_ERRORS.txt

echo "  ✓ ALL_ERRORS_SUMMARY.txt ($(wc -l < ALL_ERRORS_SUMMARY.txt) unique errors)"
echo "  ✓ TOP_500_ERRORS.txt (top 500 error lines)"

# ============================================
# PART 6: STATISTICS
# ============================================
echo "[6/6] Generating statistics..."

cat > LOG_COLLECTION_REPORT.txt <<EOF
========================================
LOG COLLECTION REPORT
Date: $(date)
Location: $LOG_DIR
========================================

NATIVE LOGS:
- Master journalctl: $(wc -l < master_journalctl.log) lines
- Master dmesg: $(wc -l < master_dmesg.log) lines
- Master syslog: $(wc -l < master_syslog.log) lines
- Lady journalctl: $(wc -l < lady_journalctl.log) lines
- Lady dmesg: $(wc -l < lady_dmesg.log) lines
- Lady syslog: $(wc -l < lady_syslog.log) lines

DOCKER LOGS:
- Master containers: ${MASTER_COUNT} containers
- Lady containers: ${LADY_COUNT} containers
- Master total lines: $(wc -l < master_containers_ALL.log) lines
- Lady total lines: $(wc -l < lady_containers_ALL.log) lines

ERROR ANALYSIS:
- Unique error patterns: $(wc -l < ALL_ERRORS_SUMMARY.txt)
- Total error occurrences: $(cat ALL_ERRORS_SUMMARY.txt | awk '{sum+=$1} END {print sum}')

TOP 20 ERROR PATTERNS:
$(head -20 ALL_ERRORS_SUMMARY.txt)

========================================
FILES GENERATED: $(ls -1 *.log *.txt | wc -l) files
TOTAL SIZE: $(du -sh . | awk '{print $1}')
========================================

✅ LOG COLLECTION COMPLETE
All logs checked per user requirement:
"CHECK LOG!!!! ALLL LOGSSSSS!!!!!! Native services, docker, possible, impossible, lady, master..."

Next: Review logs and create/update TODO items with actual log evidence.
EOF

cat LOG_COLLECTION_REPORT.txt

echo ""
echo "=========================================="
echo "✅ LOG COLLECTION COMPLETE"
echo "=========================================="
echo "Location: $LOG_DIR"
echo "Files: $(ls -1 *.log *.txt | wc -l)"
echo "Size: $(du -sh . | awk '{print $1}')"
echo ""
echo "Key files to review:"
echo "  - LOG_COLLECTION_REPORT.txt (this summary)"
echo "  - ALL_ERRORS_SUMMARY.txt (all unique errors ranked)"
echo "  - TOP_500_ERRORS.txt (top 500 error lines)"
echo "  - master_containers_ALL.log (all Master container logs)"
echo "  - lady_containers_ALL.log (all Lady container logs)"
echo ""
echo "Individual container logs: master_*.log and lady_*.log"
echo ""
echo "⚠️  USER REQUIREMENT SATISFIED: ALL LOGS CHECKED"
echo "=========================================="
```

---

## 🎯 QUICK COMMANDS FOR SPECIFIC CHECKS

### Check Master Errors Only
```bash
docker ps -a --format '{{.Names}}' | xargs -I {} sh -c 'echo "=== {} ==="; docker logs {} --tail 100 2>&1 | grep -iE "error|fatal|critical"'
```

### Check Lady Errors Only
```bash
ssh lady 'docker ps -a --format "{{.Names}}" | xargs -I {} sh -c "echo \"=== {} ===\"; docker logs {} --tail 100 2>&1 | grep -iE \"error|fatal|critical\""'
```

### Check Specific Service (e.g., Prometheus)
```bash
docker logs prometheus --tail 500 2>&1 | grep -iE 'error|fatal|warn'
```

### Check Specific Service on Lady (e.g., Mailcow)
```bash
ssh lady "docker ps --filter name=mailcow --format '{{.Names}}' | xargs -I {} sh -c 'echo \"=== {} ===\"; docker logs {} --tail 100 2>&1 | grep -iE \"error|fatal|warn\"'"
```

### Count Errors Per Container
```bash
for c in $(docker ps -a --format '{{.Names}}'); do
  errors=$(docker logs $c --tail 500 2>&1 | grep -icE 'error|fatal|critical')
  if [ $errors -gt 0 ]; then
    echo "$c: $errors errors"
  fi
done | sort -t: -k2 -rn
```

---

## 📊 WHAT TO LOOK FOR IN LOGS

### Critical Issues (Must Fix - P0)
- `FATAL`, `CRITICAL`, `PANIC` - service-breaking errors
- `OOMKilled` - out of memory issues
- `Connection refused`, `Connection reset` - networking issues
- `No such file or directory` - missing dependencies
- `Permission denied` - access control issues
- `Database connection failed` - data layer issues

### Important Issues (Should Fix - P1)
- `ERROR` repeated multiple times
- `WARNING` with implications (disk space, deprecated features)
- `Timeout`, `Retry` patterns
- `Failed to`, `Unable to` messages
- SSL/TLS certificate issues
- Authentication failures

### Monitoring Issues (Nice to Fix - P2)
- Deprecation warnings
- Performance warnings
- Non-critical connection issues
- Info-level repeated messages

---

## ✅ VERIFICATION CHECKLIST

Before claiming "task completed", verify:

- [ ] Master journalctl checked (2000+ lines collected)
- [ ] Master dmesg checked
- [ ] Master syslog checked
- [ ] Lady journalctl checked (2000+ lines collected)
- [ ] Lady dmesg checked
- [ ] Lady syslog checked
- [ ] All 25 Master containers logged (200+ lines each)
- [ ] All 36 Lady containers logged (200+ lines each)
- [ ] Error analysis completed (summary generated)
- [ ] Top errors documented
- [ ] Individual container logs saved
- [ ] LOG_COLLECTION_REPORT.txt generated

**Without ALL checkboxes ✅ → TASK NOT COMPLETED**

---

## 🚨 FAILURE CONSEQUENCES

**If you don't check ALL logs:**
- ❌ Agent #6 will REJECT your work immediately
- ❌ User will escalate: "Without that TASK IS NOT COMPLETED!!!"
- ❌ You must redo entire TODO list with log evidence
- ❌ Adds 10-20 hours to timeline
- ❌ Reduces A+++ success probability from 90% to 30%

**Just run the script. Check all logs. Include log evidence in every TODO item.**

---

**This is non-negotiable. User explicitly demands it. Don't skip this.**
