#!/bin/bash

# Create backup directory for volumes if it doesn't exist
mkdir -p backups/volumes

# Backup all Docker volumes
echo "Backing up Docker volumes..."
for volume in $(docker volume ls -q); do
    echo "Backing up volume: $volume"
    docker run --rm -v $volume:/volume_data -v $(pwd)/backups/volumes:/backup busybox sh -c "tar -czvf /backup/${volume}.tar.gz -C /volume_data ."
done
echo "All volumes have been backed up to backups/volumes."
