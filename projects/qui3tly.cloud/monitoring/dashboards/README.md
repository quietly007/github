# Grafana Dashboards

## Dashboard Overview

### 1. Infrastructure Overview (`1-infrastructure-overview.json`)
**Main monitoring dashboard** - Complete infrastructure overview with:
- Server status table (UP/DOWN status for all servers)
- Docker containers status (total count)
- Native services status (total count) 
- Total processes and servers online stats
- CPU, Memory, Disk usage graphs across all servers
- **Top 10 Docker Containers** table with: Service | Server | CPU % | Memory (MB) | Network (KB/s)
- **Top 10 Native Services** table with: Service | Server | CPU % | Memory (MB)
- **Top 10 All Processes** table with: Service | Server | CPU % | Memory (MB) | Network (KB/s)

**Key Features**:
- Shows containers from BOTH master and lady servers
- Single "Service" column (uses `name` field from cadvisor)
- Color-coded CPU and Memory metrics
- Network usage tracking for Docker containers
- Auto-refresh every 30 seconds

### 2. Server Details (`2-server-details.json`)
Detailed metrics for individual servers.

### 3. Container Monitoring (`3-container-monitoring.json`)
Deep dive into Docker container metrics.

### 4. Service Health (`4-service-health.json`)
System service health monitoring.

### 5. Log Analysis (`5-log-analysis.json`)
Log aggregation and analysis dashboard.

### 6. Performance Trends (`6-performance-trends.json`)
Long-term performance trend analysis.

### 7. Alerting (`7-alerting.json`)
Alert management and visualization.

## Data Sources

- **Prometheus**: Metrics collection from node-exporter and cadvisor
- **Loki**: Log aggregation from promtail
- **cAdvisor**: Container metrics (provides `name` field used for service identification)

## Important Notes

### Service Name Resolution
The infrastructure overview dashboard uses the `name` field from cAdvisor metrics for service identification:
- Master containers: Shows container name from compose labels
- Lady containers: Shows container name from cAdvisor
- Both appear in the same "Service" column

### Metric Queries
- **Docker containers**: `id=~"/system.slice/docker.+"`
- **Native services**: `id=~"/system.slice/.*service"`
- **All processes**: `id=~".+/.+", id!="/"`

### Column Order
All tables follow this structure:
1. Service (position 0)
2. Server (position 1)
3. CPU % (position 2)
4. Memory (MB) (position 3)
5. Network (KB/s) (position 4, where applicable)

## Importing Dashboards

Import dashboards in order (1-7) through Grafana UI:
1. Go to Dashboards → Import
2. Upload JSON file or paste content
3. Select Prometheus data source
4. Click Import

## Troubleshooting

### Empty Service Column
- Check if cAdvisor is running: `docker ps | grep cadvisor`
- Verify Prometheus is scraping: Check Prometheus targets at http://prometheus:9090/targets
- Ensure `name` label exists in metrics: Query `container_cpu_usage_seconds_total` in Prometheus

### Duplicate Columns
- Verify transformation excludes unused fields
- Check `indexByName` positions are unique
- Only one field should be renamed to each column name

### Missing Data
- Check time range (dashboards default to last 1 hour)
- Verify data retention in Prometheus
- Confirm exporters are running on all servers

## Last Updated
2026-01-28 - Complete infrastructure overview dashboard with multi-server support
