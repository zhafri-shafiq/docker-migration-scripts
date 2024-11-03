# Docker Migration and Cleanup Scripts

This repository contains scripts to assist with migrating from Docker Desktop to Colima, including cleanup, backup, and restore processes.

## Scripts

1. **`backup_volumes.sh`**: Backs up all Docker volumes to `backups/volumes`.
2. **`restore_volumes.sh`**: Restores all Docker volumes from `backups/volumes`.
3. **`backup_images.sh`**: Backs up all Docker images to `backups/images/images.tar`.
4. **`restore_images.sh`**: Restores all Docker images from `backups/images/images.tar`.
5. **`cleanup_docker_desktop.sh`**: Cleans up Docker Desktop by removing all containers, volumes, images, and residual data.
6. **`configure_colima_docker.sh`**: Configures Docker CLI to use Colima as the Docker environment.

## Usage

### 1. Backup and Restore

These scripts allow you to back up Docker volumes and images and restore them in a new environment (e.g., Colima).

- **To Back Up Volumes**:

```bash
  bash backup_volumes.sh
```

- **To Restore Volumes**:

```bash
  bash restore_volumes.sh
```

- **To Back Up Images**:

```bash
  bash backup_images.sh
```

- **To Restore Images**:

```bash
  bash restore_images.sh
```

### 2. Full Cleanup of Docker Desktop

The `cleanup_docker_desktop.sh` script fully removes Docker Desktop data, including:

- **All Containers**: Stops and deletes any running or stopped containers.
- **All Volumes**: Deletes all Docker volumes, freeing up associated storage.
- **All Images**: Removes all Docker images from Docker Desktop.
- **Residual Data**: Cleans up Docker Desktop’s configuration and cache files.

This script is helpful if you're migrating to Colima or another Docker alternative and no longer need Docker Desktop or its data.

#### Usage

To run the full cleanup script, use:

```bash
    bash cleanup_docker_desktop.sh
```

> **Note**: On macOS, this script also includes an option to uninstall Docker Desktop if it was installed via Homebrew.

> **Important**:
>
> - **Irreversible Action**: This operation permanently deletes all Docker Desktop data. Ensure you’ve backed up any necessary volumes or images before running this script.
> - **macOS Only**: The optional Docker Desktop uninstallation works only for Homebrew-installed versions on macOS.

### 3. Configure Docker CLI to use Colima

After migrating to Colima, you may want to configure the Docker CLI to work with Colima instead of Docker Desktop. Use the configure_colima_docker.sh script for this:

```bash
  bash configure_colima_docker.sh
```

This script will:

- Restart Colima to ensure it is running.
- Set the Docker CLI context to Colima.
- Unset any DOCKER_HOST environment variable that might conflict with Colima.
- Verify the Docker connection to ensure it’s properly configured.

## Requirements

To use these scripts effectively, ensure the following tools are installed:

- **Docker CLI**: Required to interact with Docker containers, images, and volumes. [Docker installation guide](https://docs.docker.com/get-docker/).

- **Colima**: An alternative to Docker Desktop for macOS and Linux, providing a lightweight VM environment for running containers. [Install Colima via Homebrew](https://github.com/abiosoft/colima):

  ```bash
  brew install colima
  ```

> **Note**: BusyBox is used within the Docker containers in the scripts, so no additional installation is required on the host system.

## Example Workflow

```bash
# On Docker Desktop
bash backup_volumes.sh
bash backup_images.sh

# Transfer backup files to the Colima environment

# On Colima
bash restore_volumes.sh
bash restore_images.sh

# Configure Docker CLI to use Colima
bash configure_colima_docker.sh
```
