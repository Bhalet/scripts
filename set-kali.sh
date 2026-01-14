#!/usr/bin/env bash
set -euo pipefail

# ------------- CONFIG -------------
ISO_PATH="/home/shraddha/Downloads/kali-linux.iso"
MENU_NAME="Kali Linux Installer"
WORKDIR="/boot/iso"   # location to store iso
UUID="b1081da8-97c9-420c-b67a-70603ba56daf"
# ----------------------------------

echo "[*] Installing required packages..."
sudo pacman -Sy --needed --noconfirm grub os-prober wget rsync coreutils

echo "[*] Preparing ISO workspace..."
sudo mkdir -p "$WORKDIR"
sudo cp "$ISO_PATH" "$WORKDIR/"

ISO_BASENAME=$(basename "$ISO_PATH")

#echo "[*] Adding GRUB menu entry..."
#sudo tee -a /etc/grub.d/40_custom >/dev/null <<EOF

#menuentry "$MENU_NAME" {
#    insmod part_gpt
#    insmod ext2
#    set iso_path="$WORKDIR/$ISO_BASENAME"
#    search --no-floppy --fs-uuid --set=root $UUID
#    loopback loop (\$root)\$iso_path
#    linux (loop)/install.amd/vmlinuz boot=install.amd iso-scan/filename=\$iso_path quiet
#    initrd (loop)/install.amd/initrd.gz
#}
#EOF

echo "[*] Updating GRUB config..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "[✔] Done. Reboot and select '$MENU_NAME' from GRUB."

