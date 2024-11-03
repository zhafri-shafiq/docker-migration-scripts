#!/bin/bash

# Define backup directories
VOLUME_BACKUP_DIR="backups/volumes"
IMAGE_BACKUP_DIR="backups/images"

# Function to perform backup of volumes and images
backup_all() {
    echo "Starting full backup process..."

    # Ensure backup directories exist
    mkdir -p $VOLUME_BACKUP_DIR
    mkdir -p $IMAGE_BACKUP_DIR

    # Run volume backup
    echo "Backing up Docker volumes..."
    ./backup_volumes.sh

    # Run image backup
    echo "Backing up Docker images..."
    ./backup_images.sh

    echo "Backup process completed. Check the backups/ directory for results."
}

# Function to perform restore of volumes and images
restore_all() {
    echo "Starting full restore process..."

    # Run volume restore
    echo "Restoring Docker volumes..."
    ./restore_volumes.sh

    # Run image restore
    echo "Restoring Docker images..."
    ./restore_images.sh

    echo "Restore process completed. Docker volumes and images are now restored."
}

# Main script logic
if [ "$1" == "backup" ]; then
    backup_all
elif [ "$1" == "restore" ]; then
    restore_all
else
    echo "Usage: $0 {backup|restore}"
    echo "  backup  - Backup all Docker volumes and images to the backups/ directory."
    echo "  restore - Restore all Docker volumes and images from the backups/ directory."
fi
