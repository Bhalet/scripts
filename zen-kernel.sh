#!/usr/bin/env bash
#
# Arch Linux → Zen Kernel migration script (safe version)
# Avoids full system upgrade and repo replacements.
#
# Run as root: sudo ./install-zen-kernel.sh

set -euo pipefail

echo "=== Arch Linux → Zen Kernel Migration (Safe Mode) ==="

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root (using sudo)."
    exit 1
fi

# Quick connectivity and pacman check
command -v pacman >/dev/null || {
    echo "Error: pacman not found!"
    exit 1
}

if ! ping -c 1 archlinux.org >/dev/null 2>&1; then
    echo "Warning: No internet connection detected, proceeding may fail."
fi

# Sync only package databases (no upgrade)
echo "[*] Refreshing package database (no upgrade)..."
pacman -Sy --noconfirm

# Show kernel version before install
echo "[i] Current kernel version:"
uname -r

# Install Zen kernel and headers without upgrading everything
echo "[*] Installing linux-zen kernel and headers..."
pacman -S --needed linux-zen linux-zen-headers --noconfirm --overwrite='*'

# Optional microcode installation
if ! pacman -Q | grep -q "amd-ucode\|intel-ucode"; then
    echo "[*] CPU microcode not found."
    read -rp "Install CPU microcode (recommended)? [y/N] " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        if lscpu | grep -q "AMD"; then
            pacman -S --noconfirm amd-ucode
        else
            pacman -S --noconfirm intel-ucode
        fi
    fi
fi

# Regenerate initramfs for all installed kernels
echo "[*] Regenerating initramfs..."
mkinitcpio -P

# Detect and update bootloader
if [[ -d /boot/grub ]]; then
    echo "[*] Updating GRUB configuration..."
    grub-mkconfig -o /boot/grub/grub.cfg
elif bootctl status &>/dev/null; then
    echo "[*] Updating systemd-boot entries..."
    bootctl update
else
    echo "⚠️ Bootloader not detected. Please update manually!"
fi

echo
echo "✅ linux-zen installed successfully!"
echo "Reboot and select 'Arch Linux (linux-zen)' in your boot menu."
echo
read -rp "After reboot and confirming stability, remove old kernel? [y/N] " remove_old

if [[ "$remove_old" =~ ^[Yy]$ ]]; then
    echo "[*] Removing old linux kernel..."
    pacman -Rns --noconfirm linux linux-headers || echo "Old kernel not found or already removed."
    echo "[*] Updating bootloader..."
    if [[ -d /boot/grub ]]; then
        grub-mkconfig -o /boot/grub/grub.cfg
    elif bootctl status &>/dev/null; then
        bootctl update
    fi
    echo "✅ Old kernel removed."
else
    echo "Keeping old kernel as fallback (recommended)."
fi

echo "🎉 Migration complete. Reboot when ready."

