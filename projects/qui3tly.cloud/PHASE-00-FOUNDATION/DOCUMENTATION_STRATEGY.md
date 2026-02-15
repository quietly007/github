# DOCUMENTATION STRATEGY
## Consolidating 452 Files to Single Source of Truth

**Document Version**: 1.0  
**Date**: February 15, 2026  
**Purpose**: Define strategy to consolidate scattered documentation

---

## 1. CURRENT STATE PROBLEM

**Documentation Locations** (5 places):
1. `~/.docs/` - 58 files (current standards and guides)
2. `~/.copilot/backups/` - 322 files (archived projects, old versions)
3. `~/personal/` - 72 files (personal notes, how-tos, audits)
4. `~/.copilot/memories.jsonl` - 1,329 entries (decision history)
5. `~/projects/qui3tly.cloud/` - 0 files (empty, this project)

**Total**: 452 markdown files + 1,329 memory entries

**Problems**:
- No single source of truth
- User must search 5 locations
- Version confusion (which is current?)
- Contradictions (container counts, grades, status)
- High risk of using outdated info

---

## 2. CONSOLIDATION STRATEGY

### 2.1 Target Structure

**Single Location**: `~/.docs/` (recommended)

**Rationale**:
- Already exists with 58 current files
- Clear name ("docs" = documentation)
- Not in backup folders (clearly active)
- Follows Unix convention (~/.config, ~/.local, ~/.docs)

**Full Structure**:
```
~/.docs/
├── 00-standards/              ← Governance, mandatory policies
├── 01-infrastructure/         ← Architecture, network, servers
├── 02-services/              ← Per-service documentation
├── 03-monitoring/            ← Prometheus, Grafana, Loki, alerts
├── 04-security/              ← CrowdSec, fail2ban, Authelia
├── 05-dr-backup/             ← Disaster recovery, backup strategies
├── 06-business/              ← Business model, pricing, customers
├── 07-projects/              ← Customer projects (Montefish, Norma)
├── 08-runbooks/              ← Troubleshooting guides
├── 09-diagrams/              ← Network, service, flow diagrams
├── 10-howto/                 ← How-to guides (git, GitHub, VPN)
└── README.md                 ← Documentation index
```

### 2.2 What Goes Where

**~/.docs/** (Production Documentation):
- Current, accurate, maintained
- All services documented
- Architecture, network, procedures
- Runbooks, troubleshooting
- Business documentation

**~/.copilot/backups/** (Archives):
- Historical snapshots
- Old versions (keep for reference, labeled by date)
- Abandoned project attempts
- No active use

**~/personal/** (Merge into ~/.docs/):
- Useful content → Move to appropriate ~/.docs/ folder
- Obsolete content → Archive to backups with date
- Audit requests → Keep in personal/ (historical context)

**~/.copilot/memories.jsonl** (Keep Separate):
- Decision history (invaluable context)
- Not documentation, but decision log
- Continue using for all agent actions

### 2.3 Migration Plan

**Phase 1: Prepare** (During Phase 00)
- Create ~/.docs/ structure (folders above)
- Create ~/.docs/README.md (index of all docs)

**Phase 2: Consolidate** (During Phase 02)
- Move current docs from personal/ to appropriate ~/.docs/ folders
- Update links (no broken references)
- Archive old backups with dates (e.g., backups/2026-01-11/)

**Phase 3: Update** (During Phase 02)
- Fix contradictions (container counts → 64, grade → 72/100)
- Complete service documentation (6/54 → 54/54)
- Add business documentation (model, revenue, pricing)

**Phase 4: Maintain** (Ongoing After Phase 02)
- Update docs WITH infrastructure changes (not after)
- Single source = always update ~/.docs/ version
- Archive old versions to backups/ with date if major changes

---

## 3. DOCUMENTATION STANDARDS

### 3.1 File Naming

**Convention**: `UPPERCASE_WITH_UNDERSCORES.md` for major docs

**Examples**:
- INFRASTRUCTURE_OVERVIEW.md
- NETWORK_ARCHITECTURE.md
- TRAEFIK.md
- MAILCOW.md
- DISASTER_RECOVERY.md

**Rationale**: Easy to spot important documents, consistent with existing

### 3.2 Document Structure

**Required Sections** (Every Doc):
```markdown
# [TITLE]
## [Subtitle if needed]

**Document Version**: 1.0
**Last Updated**: [Date]
**Purpose**: [1-2 sentence purpose]

---

## 1. [FIRST SECTION]

[Content]

---

[More sections]

---

## CONCLUSION

[Summary]

---

**Status**: [Current status]
**Next Actions**: [What's next]
```

**Optional Sections**:
- Prerequisites
- Quick Start
- Detailed Guide
- Troubleshooting
- Examples
- References

### 3.3 Content Standards

**Accurate**:
- Based on evidence (audit, logs, actual state)
- Not assumptions or outdated info
- Facts with sources

**Complete**:
- All required sections present
- No "TBD" or "TODO" in production docs
- Examples included where helpful

**Clear**:
- External agent can understand
- Technical but not obscure
- Diagrams where complex

**Consistent**:
- Same naming conventions
- Same structure across docs
- No contradictions between docs

**Maintainable**:
- Update date when changed
- Version number increments
- Old versions archived (not deleted)

---

## 4. UPDATE WORKFLOW

### 4.1 When to Update

**Infrastructure Change** → Update docs IMMEDIATELY
- Service added/removed → Update SERVICE_CATALOG.md, architecture docs
- Network change → Update NETWORK_ARCHITECTURE.md
- Configuration change → Update service-specific doc

**Discovery of Error** → Fix IMMEDIATELY
- Wrong container count → Fix all docs with wrong count
- Wrong IP/port → Fix all references
- Outdated version → Update version info

**New Feature/Service** → Document BEFORE or DURING deployment
- New service → Create service doc before deploying
- New procedure → Add to runbook as you develop it

### 4.2 Update Process

**Step 1: Identify Docs Affected**
- Which docs mention this service/IP/config?
- Use grep to find all references: `grep -r "search_term" ~/.docs/`

**Step 2: Update All at Once**
- Don't update one doc and forget others
- Use checklist: "Updated INFRASTRUCTURE_OVERVIEW.md, NETWORK_ARCHITECTURE.md, TRAEFIK.md"

**Step 3: Increment Version**
- Major changes: 1.0 → 2.0
- Minor changes: 1.0 → 1.1
- Fixes: 1.0 → 1.0.1

**Step 4: Archive Old Version** (if major change)
- Copy to ~/.copilot/backups/docs-[date]/
- Keep in case need to reference old state

**Step 5: Commit to Git**
- Descriptive commit message: "Updated TRAEFIK.md: Added new router for quietly.online"
- Push to GitHub

### 4.3 Review Schedule

**Weekly**: Quick scan for outdated info  
**Monthly**: Full review of critical docs (architecture, network)  
**Quarterly**: Complete documentation audit (all docs reviewed)  
**Major Changes**: Immediate update

---

## 5. SERVICE DOCUMENTATION TEMPLATE

**Every Service Gets**:
```markdown
# [SERVICE NAME]
## [Brief description]

**Version**: [Current version]
**Location**: [Server: Master/Lady]
**Container**: [Container name]
**Status**: [Operational / Partial / Planned]

---

## 1. OVERVIEW

**Purpose**: [What does this service do?]
**Use Case**: [When/why do we use it?]
**Importance**: [Critical / Important / Nice to have]

---

## 2. TECHNICAL DETAILS

**Image**: [Docker image:tag]
**Ports**: [Exposed ports]
**Dependencies**: [Other services it needs]
**Resources**: [CPU/RAM limits if set]
**Volumes**: [Persistent data locations]

---

## 3. CONFIGURATION

**Location**: `~/.docker-compose/[service]/docker-compose.yaml`
**Config Files**: `~/.docker/[service]/config/`
**Secrets**: `~/.secrets/[service]/`

**Key Settings**:
- [Setting 1]: [Value and purpose]
- [Setting 2]: [Value and purpose]

---

## 4. ACCESS

**URL**: https://[service].quietly.its.me
**Authentication**: [Authelia 2FA / Service-specific / VPN-only]
**Users**: [Who has access]

---

## 5. MONITORING

**Metrics**: [Prometheus exporter if any]
**Logs**: [Loki label]
**Alerts**: [Alertmanager rules if any]
**Uptime Check**: [Uptime Kuma check configured]

---

## 6. BACKUP

**Data Location**: `~/.docker/[service]/data/`
**Backup Method**: [Git / Snapshot / Manual]
**Backup Frequency**: [Real-time / Daily / On-demand]
**Restore Procedure**: [Brief steps]

---

## 7. TROUBLESHOOTING

**Common Issues**:

**Issue 1**: [Description]
- **Symptom**: [What you see]
- **Cause**: [Why it happens]
- **Fix**: [How to resolve]

**Issue 2**: [Another common issue]
[... repeat ...]

**Logs**: `docker logs [container]` or Loki query

---

## 8. MAINTENANCE

**Updates**: [How to update safely]
**Configuration Changes**: [How to modify config]
**Restart Procedure**: [When/how to restart]

---

**Last Updated**: [Date]
**Maintained By**: [Team/Person]
```

---

## 6. DOCUMENTATION QUALITY CHECKLIST

**Before Marking Doc "Complete"**:

- [ ] **Accurate**: All facts verified against reality
- [ ] **Complete**: All required sections present, no TBD/TODO
- [ ] **Clear**: External agent can understand and follow
- [ ] **Tested**: Procedures tested, steps work
- [ ] **Links**: All internal links work (no 404)
- [ ] **Formatting**: Proper Markdown, renders correctly
- [ ] **Version**: Version number and date present
- [ ] **Diagrams**: Included where helpful
- [ ] **Examples**: Concrete examples provided
- [ ] **Consistent**: Matches other docs (no contradictions)

---

## 7. ARCHIVAL STRATEGY

### 7.1 What to Archive

**Archive** (Move to ~/.copilot/backups/[date]/):
- Old versions of docs (when major update)
- Abandoned project attempts
- Historical snapshots
- Superseded procedures

**Keep** (In ~/.docs/):
- Current documentation only
- Most recent version
- Active procedures

**Delete** (Rare):
- Duplicate files (exact copies)
- Completely obsolete (e.g., OSPF docs after permanent rejection)

### 7.2 Archive Naming

**Format**: `~/.copilot/backups/[description]-[YYYY-MM-DD]/`

**Examples**:
- backups/qui3tly.cloud-2026-01-11/
- backups/qui3tly.cloud-2026-01-24/
- backups/docs-2026-02-01/

**README in Archive**: Always include README explaining what's archived and why

---

## 8. SPECIAL CASES

### 8.1 Memories (.copilot/memories.jsonl)

**Keep Separate**: Don't consolidate into ~/.docs/  
**Purpose**: Decision history, agent actions, timestamps  
**Use**: Reference when need historical context  
**Maintenance**: Continue adding, don't delete

### 8.2 GitHub Documentation

**Two-Repo Model**:
- quietly007/master: Server-specific files (~/)
- quietly007/github: Shared content (symlinked to ~/.github/)

**Symlinks**:
- ~/.docs/ → Not symlinked (lives on server)
- ~/.github/governance/ → Symlinked from GitHub repo

**Updates**: Commit to appropriate repo, push to GitHub

### 8.3 Customer Project Docs

**Location**: ~/.docs/07-projects/[customer]/  
**Example**: ~/.docs/07-projects/montefish/  
**Content**: Proposals, architecture, deployment plans, customer-specific configs

---

## 9. IMPLEMENTATION TIMELINE

**Phase 00** (Current):
- ✅ Define strategy (this document)
- ✅ Decide location (_.docs/_)

**Phase 02** (Documentation Consolidation):
- Day 1-2: Create folder structure in ~/.docs/
- Day 2-3: Move files from personal/ to _.docs/_
- Day 3-4: Archive backups with proper naming
- Day 4-5: Fix contradictions, update to match reality
- Day 5: Test all links, verify no 404s

**Phase 02 Deliverable**: SERVICE_CATALOG.md with all 54+ services  
**Phase 08** (Final Documentation): Complete consolidation, business docs added

**Ongoing** (After Phase 02): Update docs WITH infrastructure changes

---

## 10. SUCCESS METRICS

**Consolidation Success**:
- ✅ Single source of truth (_.docs/_ only)
- ✅ Zero contradictions across docs
- ✅ 100% service documentation (not 11%)
- ✅ All internal links work
- ✅ Backups properly archived with dates
- ✅ External agent can find any doc in <2 minutes

**Maintenance Success**:
- ✅ Docs updated BEFORE or WITH infra changes
- ✅ No more than 7 days between change and documentation
- ✅ Monthly review reveals <5% outdated info
- ✅ User confidence: "I trust the docs"

---

## 11. CONCLUSION

**Problem**: 452 files scattered across 5 locations, contradictions, confusion  
**Solution**: Consolidate to `~/.docs/` with clear structure, archive old versions  
**Timeline**: Phase 02 implementation, ongoing maintenance  
**Impact**: Single source of truth, faster troubleshooting, confident customers

---

**Document Version**: 1.0  
**Prepared By**: Lucky Luke (Primary Agent)  
**Date**: February 15, 2026  
**Status**: Strategy defined for Phase 00, implementation Phase 02  
**Next Action**: User approves location, proceed to Phase 02 execution
