#!/bin/bash

# A script to clean and optimize Ubuntu 22.04

echo "Starting system cleanup and optimization..."

# 1. Update and Upgrade the System
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# 2. Remove Unused Packages
echo "Removing unused packages..."
sudo apt autoremove --purge -y

# 3. Clean Package Cache
echo "Cleaning package cache..."
sudo apt clean
sudo apt autoclean

# 4. Remove Unnecessary Dependencies
echo "Removing unnecessary dependencies..."
sudo apt install -y deborphan
sudo apt-get purge -y $(deborphan)

# 5. Clear Log Files
echo "Clearing old log files..."
sudo journalctl --vacuum-time=7d
sudo truncate -s 0 /var/log/*.log
sudo truncate -s 0 /var/log/*/*.log

# 6. Free Up Disk Space
echo "Freeing up temporary files..."
sudo rm -rf /var/tmp/*

# 7. Remove Old Kernel Versions
echo "Removing old kernel versions..."
sudo apt --purge autoremove -y

# 8. Optimize Memory
echo "Clearing cached memory..."
sudo sysctl vm.drop_caches=3

# 9. Check Disk Health
echo "Checking and repairing disk file system..."
sudo fsck -Af -M

# 10. Optional: Install Preload
echo "Installing and enabling preload for faster application loading..."
sudo apt install -y preload
sudo systemctl enable preload

# 11. Reboot Prompt
echo "Cleanup complete! It is recommended to reboot your system."
read -p "Would you like to reboot now? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Reboot skipped. Please reboot later for changes to take full effect."
fi
