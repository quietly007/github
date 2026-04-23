# BACKUP AND DISASTER RECOVERY DRILL REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

---

## DR Readiness Assessment

| Node   | Backup Implemented | Tested | Restore Drilled | RTO/RPO Measured | Status  |
|--------|--------------------|--------|-----------------|------------------|---------|
| Master | Unknown            | No     | No              | No               | PARTIAL |
| Lady   | No evidence        | No     | No              | No               | FAIL    |

Overall DR gate: FAIL — unconditional P0 blocker.

---

## Evidence

reports/DOCUMENTATION_COVERAGE_MATRIX.md: Operations/backup/DR = PARTIAL (drill evidence pending)
reports/ACCURACY_VALIDATION_REPORT.md: restore drills listed under "Not yet fully validated"
todo/PREPRODUCTION_TODO.md: ALL 5 DR tasks = not started
evidence/11_lady_snapshot: No backup tooling visible (no restic, borgbackup, rsync, bacula, duplicati)

---

## Data at Risk on Lady (No Confirmed Backup)

| Service       | Data Type           | Recovery Without Backup  |
|---------------|---------------------|--------------------------|
| Mailcow       | Mail + MariaDB      | IMPOSSIBLE — permanent   |
| Nextcloud     | Files + MariaDB     | Permanent loss           |
| Odoo          | PostgreSQL DB       | Permanent loss           |
| UniFi         | MongoDB + config    | Partial rebuild only     |
| Home Assistant| Config + history    | Partial rebuild only     |

Lady disk: 215G of live production data with no evidenced backup chain.

---

## Backup Implementation Plan

Mailcow (built-in script):
  cd /opt/mailcow-dockerized
  bash helper-scripts/backup_and_restore.sh backup all
  # Schedule: cron 0 2 * * *

Nextcloud DB:
  docker exec nextcloud-db mysqldump -u root --all-databases > /backup/nextcloud_db_$(date +%Y%m%d).sql

Nextcloud files (with maintenance mode):
  docker exec nextcloud php /var/www/html/occ maintenance:mode --on
  rsync -av /path/to/nextcloud/data/ /backup/nextcloud_files/
  docker exec nextcloud php /var/www/html/occ maintenance:mode --off

Odoo:
  docker exec odoo-db pg_dumpall -U odoo > /backup/odoo_$(date +%Y%m%d).sql

UniFi:
  docker exec unifi-db mongodump --out /backup/unifi_$(date +%Y%m%d)/

Remote offsite (required — local backup alone is insufficient):
  apt install restic
  restic -r s3://bucket/lady init
  restic -r s3://bucket/lady backup /backup/
  restic -r s3://bucket/lady forget --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --prune

---

## Recommended RTO/RPO Targets

| Service       | RPO (max data loss) | RTO (max downtime) |
|---------------|---------------------|--------------------|
| Mailcow       | 24 hours            | 4 hours            |
| Nextcloud     | 24 hours            | 4 hours            |
| Odoo          | 24 hours            | 8 hours            |
| UniFi         | 72 hours            | 8 hours            |
| Home Assistant| 72 hours            | 24 hours           |
| Master configs| 24 hours            | 2 hours            |

---

## Restore Drill Protocol

1. Take VPS snapshot (safety net) before drill
2. Record start timestamp (T0)
3. Restore latest backup to test schema/container
4. Verify data integrity (row counts, sample queries)
5. Record end timestamp (T1) → RTO = T1 - T0
6. Calculate RPO = drill start - backup creation time
7. Save all output to evidence/restore_drill_<node>_<date>.txt

---

## Contabo Snapshots — Limitation Analysis

VPS snapshots are disk-level recovery — useful for patching rollback, NOT a substitute for application-level backups:
  - Typically 1 snapshot slot per VPS — not a rolling backup strategy
  - Provider-level outage = snapshot also unavailable
  - Restore may take 30-60 min — may not meet mail RTO of 4 hours

Recommendation: Treat Contabo snapshots as rollback insurance during the hardening sprint only. Implement proper application-level backup chain for production.

---

## DR Summary

Every single DR requirement is either Not Done or Unknown.
This is the single greatest risk gap in the preproduction package.

| Requirement                        | Status      |
|------------------------------------|-------------|
| Lady backup jobs implemented       | NOT DONE    |
| Master backup jobs verified        | UNKNOWN     |
| Lady restore drill completed       | NOT DONE    |
| Master restore drill completed     | NOT DONE    |
| RTO/RPO measured and documented    | NOT DONE    |
| Backup destination is offsite      | UNKNOWN     |
| Backup encryption confirmed        | UNKNOWN     |
| Mailcow backup script scheduled    | UNKNOWN     |
