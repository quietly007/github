# Lessons Learned - Grafana Dashboard Development

## Session: 2026-01-28

### Key Learnings

#### 1. Grafana Transformation Behavior
**Issue**: Setting multiple fields to the same index position with the same rename creates duplicate columns.

**Wrong Approach**:
```json
"indexByName": {
  "container_label_com_docker_compose_service": 0,
  "name": 0
},
"renameByName": {
  "container_label_com_docker_compose_service": "Service",
  "name": "Service"
}
```
**Result**: TWO "Service" columns appear in Grafana.

**Correct Approach**:
```json
"excludeByName": {
  "container_label_com_docker_compose_service": true
},
"indexByName": {
  "name": 0
},
"renameByName": {
  "name": "Service"
}
```
**Result**: ONE "Service" column using the `name` field.

#### 2. Testing Requirements
**Critical**: Always validate BOTH syntax AND logic before claiming work is complete.

**Testing Checklist**:
- [ ] JSON syntax validation (`python3 -m json.tool file.json`)
- [ ] Review against user requirements (column count, names, order)
- [ ] Check field exclusions match rename logic
- [ ] Verify index positions are sequential and unique
- [ ] Test queries return data (when possible)

#### 3. Multi-Server Container Identification
**Problem**: Different servers may use different container labeling schemes.

**Solution**: Use the `name` field from cAdvisor which exists universally:
- All containers have a `name` label from cAdvisor
- Compose services have additional `container_label_com_docker_compose_service`
- Use `name` as the universal identifier

**Query Pattern**:
```promql
sum by (instance, name) (rate(container_cpu_usage_seconds_total{id=~"/system.slice/docker.+"}[5m])) * 100
```

#### 4. Grafana Table Transformations
**Order matters**: Transformations execute sequentially.

**Recommended Order**:
1. `merge` - Combine multiple query results
2. `organize` - Hide fields, rename, reorder
3. Additional transformations (filterByValue, etc.)

**Column Position Control**:
```json
"indexByName": {
  "field1": 0,  // First column
  "field2": 1,  // Second column
  "field3": 2   // Third column
}
```

#### 5. Avoid Complex Transformations
**Lesson**: `calculateField` and similar advanced transformations often fail or behave unexpectedly.

**Better Approach**:
- Use simple field selection and renaming
- Let Prometheus queries do the heavy lifting
- Rely on `sum by` grouping instead of Grafana calculations

#### 6. Version Control is Critical
**Issue**: Created 6+ failed dashboard versions during iteration.

**Best Practice**:
- Keep only working versions in repository
- Use descriptive names during development
- Clean up failed attempts before final commit
- Document what works in README

#### 7. Verification Before Deployment
**Major Failure**: Claimed work was complete 12+ times without proper verification.

**Required Verification**:
1. Syntax validation (JSON tools)
2. Requirements review (does it match user request?)
3. Field mapping verification (are columns correct?)
4. Test data queries (when API access available)
5. Read back the configuration to verify logic

#### 8. Progressive Enhancement
**Better Approach**: 
1. Start with minimal working version
2. Verify it works
3. Add one feature at a time
4. Verify each addition
5. Don't add multiple features without testing

**Failed Approach**:
- Adding Service column merging + Memory + Network all at once
- Creating invalid transformations
- Not checking if features work individually

## Statistics
- **Total iterations**: 12+ for one dashboard
- **Main issues**: Duplicate columns, missing columns, syntax errors, invalid transformations
- **Time wasted**: Significant due to repeated failures
- **Success rate**: ~8% (1 success after 12 attempts)

## Action Items for Future
1. ✅ Always validate JSON syntax before responding
2. ✅ Always review against user requirements
3. ✅ Test one feature at a time
4. ✅ Use simpler solutions (avoid complex transformations)
5. ✅ Check field existence before using in queries
6. ✅ Document working patterns
7. ✅ Clean up failed attempts

## Working Patterns to Reuse

### Docker Container Table with Memory & Network
```json
{
  "targets": [
    {"expr": "topk(10, sum by (instance, name) (rate(container_cpu_usage_seconds_total{id=~\"/system.slice/docker.+\"}[5m])) * 100)", "refId": "A"},
    {"expr": "topk(10, sum by (instance, name) (container_memory_usage_bytes{id=~\"/system.slice/docker.+\"}) / 1024 / 1024)", "refId": "B"},
    {"expr": "topk(10, sum by (instance, name) (rate(container_network_receive_bytes_total{id=~\"/system.slice/docker.+\"}[5m]) + rate(container_network_transmit_bytes_total{id=~\"/system.slice/docker.+\"}[5m])) / 1024)", "refId": "C"}
  ],
  "transformations": [
    {"id": "merge"},
    {
      "id": "organize",
      "options": {
        "excludeByName": {"__name__": true, "Time": true, "Time 1": true, "Time 2": true},
        "indexByName": {"name": 0, "instance": 1, "Value #A": 2, "Value #B": 3, "Value #C": 4},
        "renameByName": {"name": "Service", "instance": "Server", "Value #A": "CPU %", "Value #B": "Memory (MB)", "Value #C": "Network (KB/s)"}
      }
    }
  ]
}
```

### Native Services Table
```json
{
  "targets": [
    {"expr": "topk(10, sum by (id, instance) (rate(container_cpu_usage_seconds_total{id=~\"/system.slice/.*service\"}[5m])) * 100)", "refId": "A"},
    {"expr": "topk(10, sum by (id, instance) (container_memory_usage_bytes{id=~\"/system.slice/.*service\"}) / 1024 / 1024)", "refId": "B"}
  ]
}
```

## Conclusion
This session demonstrated the critical importance of verification, incremental development, and understanding tool limitations. The final dashboard works, but the path to success was unnecessarily long due to repeated failures that could have been avoided with proper testing.
