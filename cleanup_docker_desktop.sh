#!/bin/bash

echo "WARNING: This script will permanently delete all Docker containers, volumes, images, and residual data from Docker Desktop."
echo "Are you sure you want to proceed? This action cannot be undone. (yes/no)"
read -r confirmation

if [[ "$confirmation" != "yes" ]]; then
    echo "Cleanup canceled."
    exit 1
fi

# Function to get Docker's disk usage if the data directory exists
get_docker_disk_usage() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -d /var/lib/docker ]]; then
            du -sm /var/lib/docker | awk '{print $1}'
        else
            echo "0"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ -d ~/Library/Containers/com.docker.docker/Data ]]; then
            du -sm ~/Library/Containers/com.docker.docker/Data | awk '{print $1}'
        else
            echo "0"
        fi
    else
        echo "Unsupported OS for automatic disk usage calculation."
        return 0
    fi
}

# Measure disk usage before cleanup
initial_usage=$(get_docker_disk_usage)
echo "Initial Docker disk usage: ${initial_usage} MB"

# Step 1: Remove all containers, volumes, and images
echo "Stopping and removing all containers..."
docker rm -f $(docker ps -aq) > /dev/null 2>&1

echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q) > /dev/null 2>&1

echo "Removing all Docker images..."
docker rmi -f $(docker images -q) > /dev/null 2>&1

# Step 2: Prune all unused Docker data
echo "Pruning unused Docker data (networks, build cache, etc.)..."
docker system prune -a --volumes -f

# Step 3: Remove Docker Desktop residual data
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Removing Docker Desktop residual files on macOS..."
    rm -rf ~/Library/Containers/com.docker.docker
    rm -rf ~/Library/Group\ Containers/group.com.docker
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Removing Docker data directory on Linux..."
    sudo rm -rf /var/lib/docker
fi

# Step 4: Optional uninstall of Docker Desktop (macOS Homebrew only)
if [[ "$OSTYPE" == "darwin"* && -x "$(command -v brew)" ]]; then
    echo "Do you want to uninstall Docker Desktop as well? (Only works if installed via Homebrew) (yes/no)"
    read -r uninstall_confirmation
    if [[ "$uninstall_confirmation" == "yes" ]]; then
        brew uninstall --cask docker
        echo "Docker Desktop has been uninstalled."
    else
        echo "Docker Desktop uninstallation skipped."
    fi
fi

# Measure disk usage after cleanup if directory still exists
final_usage=$(get_docker_disk_usage)
echo "Final Docker disk usage: ${final_usage} MB"

# Calculate and display freed space
freed_space=$((initial_usage - final_usage))
echo "Cleanup completed. Approximately ${freed_space} MB of disk space has been freed."
