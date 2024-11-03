#!/bin/bash

# Restore Docker images
echo "Restoring Docker images..."
if [ -f backups/images/images.tar ]; then
    docker load -i backups/images/images.tar
    echo "All Docker images have been restored from backups/images/images.tar."
else
    echo "No images.tar file found in backups/images. Skipping image restore."
fi
