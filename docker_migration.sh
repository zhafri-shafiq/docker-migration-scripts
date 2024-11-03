#!/bin/bash

echo "WARNING: This script will permanently delete all Docker containers, volumes, and images from Docker Desktop."
echo "Are you sure you want to proceed? This action cannot be undone. (yes/no)"
read -r confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo "Cleanup canceled."
    exit 1
fi

# Function to get Docker's disk usage in megabytes (modify path if using a different OS)
get_docker_disk_usage() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux path for Docker storage
        du -sm /var/lib/docker | awk '{print $1}'
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS path for Docker Desktop storage
        du -sm ~/Library/Containers/com.docker.docker/Data/vms/0 | awk '{print $1}'
    else
        echo "Unsupported OS for automatic disk usage calculation."
        return 0
    fi
}

# Measure disk usage before cleanup
initial_usage=$(get_docker_disk_usage)
echo "Initial Docker disk usage: $initial_usage MB"

# Remove all containers (stopped and running)
echo "Stopping and removing all containers..."
docker rm -f $(docker ps -aq) > /dev/null 2>&1

# Remove all Docker volumes
echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q) > /dev/null 2>&1

# Remove all Docker images
echo "Removing all Docker images..."
docker rmi -f $(docker images -q) > /dev/null 2>&1

# Measure disk usage after cleanup
final_usage=$(get_docker_disk_usage)
echo "Final Docker disk usage: $final_usage MB"

# Calculate and display freed space
freed_space=$((initial_usage - final_usage))
echo "Cleanup completed. Approximately $freed_space MB of disk space has been freed."
