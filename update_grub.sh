#!/bin/bash

# Define the GRUB configuration file path
GRUB_CONFIG_FILE="/etc/default/grub"

# Check if the script is run with sudo/root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Backup the original GRUB configuration file
echo "Backing up the original GRUB configuration file..."
cp $GRUB_CONFIG_FILE "${GRUB_CONFIG_FILE}.backup"
echo "Backup saved as ${GRUB_CONFIG_FILE}.backup"

# Add the i915.enable_dc=0 parameter if it's not already present
if grep -q "i915.enable_dc=0" $GRUB_CONFIG_FILE; then
  echo "The parameter i915.enable_dc=0 is already present in the GRUB configuration."
else
  echo "Adding i915.enable_dc=0 to GRUB_CMDLINE_LINUX..."
  sed -i 's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1 i915.enable_dc=0"/' $GRUB_CONFIG_FILE
  echo "Parameter added successfully."
fi

# Update the GRUB configuration
echo "Updating the GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# Prompt the user to reboot the system
echo "GRUB configuration updated. Please reboot your system for the changes to take effect."
