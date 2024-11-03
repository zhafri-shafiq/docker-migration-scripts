#!/bin/bash

echo "Configuring Docker CLI to use Colima..."

# Step 1: Stop and start Colima to ensure it's running
echo "Restarting Colima to ensure it’s active..."
colima stop
colima start

# Step 2: Set Docker context to Colima
echo "Setting Docker CLI context to 'colima'..."
docker context use colima

# Step 3: Unset DOCKER_HOST variable if set
if [[ -n "$DOCKER_HOST" ]]; then
    echo "Unsetting DOCKER_HOST environment variable..."
    unset DOCKER_HOST
else
    echo "DOCKER_HOST is not set. Skipping unset step."
fi

# Step 4: Verify Docker connection
echo "Verifying Docker connection to Colima..."
docker_version_output=$(docker version 2>&1)
if echo "$docker_version_output" | grep -q "Server:"; then
    echo "Docker is successfully connected to Colima."
else
    echo "ERROR: Unable to connect to Docker. Output was:"
    echo "$docker_version_output"
    exit 1
fi

echo "Configuration complete. Docker CLI is now set up to use Colima."
