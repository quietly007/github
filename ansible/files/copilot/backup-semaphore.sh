#!/bin/bash
# Backup Semaphore database and configuration
# Usage: ./backup-semaphore.sh

set -e

BACKUP_DIR="/home/qui3tly/.copilot/backups/semaphore"
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_NAME="semaphore_${TIMESTAMP}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Stop semaphore briefly for consistent backup
echo "Stopping Semaphore..."
docker stop semaphore

# Backup database
echo "Backing up database..."
cp /home/qui3tly/.docker/semaphore/database.boltdb "${BACKUP_DIR}/${BACKUP_NAME}.boltdb"

# Start semaphore
echo "Starting Semaphore..."
docker start semaphore

# Create tarball with ansible repo too
echo "Creating full backup..."
tar czf "${BACKUP_DIR}/${BACKUP_NAME}.tar.gz" \
    -C /home/qui3tly \
    .docker/semaphore \
    .ansible \
    .secrets/semaphore

# Keep only last 5 backups
echo "Cleaning old backups..."
ls -t "${BACKUP_DIR}"/*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

echo "✅ Backup complete: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
ls -lh "${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
