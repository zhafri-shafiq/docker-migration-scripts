#!/bin/bash

# Create backup directory for images if it doesn't exist
mkdir -p backups/images

# Backup all Docker images
echo "Backing up Docker images..."
docker save -o backups/images/images.tar $(docker images -q | uniq)
echo "All Docker images have been backed up to backups/images/images.tar."
