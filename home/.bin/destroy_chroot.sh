# Define the target environment
CHROOT_DIR="/var/tmp/chroot"

# Recursively detach all mounts inside the target
sudo umount -R "${CHROOT_DIR}"

# Safely delete the directory
sudo rm -rf "${CHROOT_DIR}"
