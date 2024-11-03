#!/bin/bash

# Restore Docker volumes
echo "Restoring Docker volumes..."
for archive in $(ls backups/volumes/*.tar.gz); do
    volume_name=$(basename $archive .tar.gz)  # Extract volume name from file name
    echo "Restoring volume: $volume_name"
    
    # Create the volume if it doesn't exist
    docker volume create $volume_name
    
    # Restore the contents from the archive
    docker run --rm -v $volume_name:/volume_data -v $(pwd)/backups/volumes:/backup busybox sh -c "tar -xzvf /backup/$volume_name.tar.gz -C /volume_data"
done
echo "All volumes have been restored from backups/volumes."
