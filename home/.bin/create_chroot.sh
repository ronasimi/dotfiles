#!/usr/bin/env dash

# Define shell variables for configuration
# Utilizing /var/tmp to build on the physical disk and avoid RAM (tmpfs) limits
BASE_DIR="/var/tmp"
CHROOT_DIR_NAME="chroot"
CHROOT_PATH="${BASE_DIR}/${CHROOT_DIR_NAME}"
BOOTSTRAP_TOOL="arch-install-scripts"
# Added git and python to the base packages
BASE_PACKAGES="base base-devel nano git python"

# Verify root privileges (using POSIX compliant id -u)
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Please run this script as root or with sudo."
    exit 1
fi

echo "Initializing generic chroot environment at ${CHROOT_PATH}..."

# Ensure the bootstrapping host tools are installed
if ! command -v pacstrap >/dev/null 2>&1; then
    echo "Required tool 'pacstrap' not found. Installing ${BOOTSTRAP_TOOL}..."
    pacman -S --noconfirm --needed "${BOOTSTRAP_TOOL}"
fi

# Clean up existing directory if it exists to ensure a fresh environment
if [ -d "${CHROOT_PATH}" ]; then
    echo "Removing existing directory at ${CHROOT_PATH}..."
    # Attempt to unmount first in case it was previously bind-mounted
    umount "${CHROOT_PATH}" >/dev/null 2>&1 || true
    rm -rf "${CHROOT_PATH}"
fi

# Create the fresh directory
mkdir -p "${CHROOT_PATH}"

# Trick the system into seeing this directory as a proper mountpoint to silence warnings
mount --bind "${CHROOT_PATH}" "${CHROOT_PATH}"

# Bootstrap the base system into the target directory
echo "Bootstrapping Arch Linux base system (this may take a moment)..."
pacstrap -K "${CHROOT_PATH}" ${BASE_PACKAGES}

echo "=================================================="
echo "Success! The chroot environment is ready."
echo "To enter the chroot, run: sudo arch-chroot ${CHROOT_PATH}"
echo "=================================================="
