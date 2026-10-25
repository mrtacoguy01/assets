#!/bin/bash
set -e

# Configuration
APK_URL="https://hermivore.cat/cdn/swan/changeinvalue"
WORK_DIR="/config/android"
APK_PATH="/config/roblox.apk"
BLISS_ISO_URL="https://sourceforge.net/projects/blissos-dev/files/Beta/Bliss-v15.8.6-x86_64-OFFICIAL-vanilla-20230628.iso/download"
ADB_PORT=5555

echo "=========================================="
echo "[1/5] Installing Arch & QEMU Packages"
echo "=========================================="
pacman -Syu --noconfirm --needed qemu-desktop edk2-ovmf android-tools wget curl

# Ensure KVM permissions
if [ -e /dev/kvm ]; then
    chmod 666 /dev/kvm
else
    echo "[!] /dev/kvm not found in container. Start container with: --device /dev/kvm:/dev/kvm"
    exit 1
fi

echo "=========================================="
echo "[2/5] Setting up Bliss OS & Virtual Disk"
echo "=========================================="
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

if [ ! -f "bliss15.iso" ]; then
    echo "[*] Downloading Bliss OS 15.8.6..."
    wget -q --show-progress -O bliss15.iso "$BLISS_ISO_URL"
fi

if [ ! -f "data.qcow2" ]; then
    echo "[*] Creating persistent sparse disk..."
    qemu-img create -f qcow2 data.qcow2 16G
fi

echo "=========================================="
echo "[3/5] Downloading and Staging APK"
echo "=========================================="
# Download stream directly as .apk regardless of Content-Disposition / zip headers
echo "[*] Fetching APK from $APK_URL..."
curl -L --progress-bar -o "$APK_PATH" "$APK_URL"
chmod 644 "$APK_PATH"

echo "=========================================="
echo "[4/5] Starting Bliss OS under QEMU (KVM)"
echo "=========================================="
OVMF_PATH="/usr/share/edk2/x64/OVMF.4m.fd"
[ -f "$OVMF_PATH" ] || OVMF_PATH="/usr/share/edk2-ovmf/x64/OVMF.fd"

# Terminate any duplicate running instance
killall -9 qemu-system-x86_64 2>/dev/null || true

# Launch QEMU attached to Webtop's active display session
runuser -u abc -- env DISPLAY=:1 WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 \
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -M q35 \
  -bios "$OVMF_PATH" \
  -vga std \
  -display gtk \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::${ADB_PORT}-:5555 \
  -device virtio-tablet \
  -device virtio-keyboard \
  -drive file=${WORK_DIR}/data.qcow2,if=virtio,format=qcow2 \
  -cdrom ${WORK_DIR}/bliss15.iso \
  -boot menu=on &

QEMU_PID=$!

echo "=========================================="
echo "[5/5] ADB Deployment & Execution"
echo "=========================================="
echo "[*] Polling ADB on 127.0.0.1:${ADB_PORT}..."
until adb connect 127.0.0.1:${ADB_PORT} 2>/dev/null | grep -q "connected"; do
    sleep 2
done

echo "[*] Connected to Android. Waiting for system boot to finish..."
until [ "$(adb -s 127.0.0.1:${ADB_PORT} shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
    sleep 3
done

echo "[*] Android boot complete. Sideloading APK..."
adb -s 127.0.0.1:${ADB_PORT} install -r -g "$APK_PATH"

echo "[*] Resolving package identifier..."
PACKAGE_NAME=$(aapt dump badging "$APK_PATH" 2>/dev/null | awk -F"'" '/package: name=/{print $2}')
[ -z "$PACKAGE_NAME" ] && PACKAGE_NAME="com.roblox.client"

echo "[*] Launching $PACKAGE_NAME..."
adb -s 127.0.0.1:${ADB_PORT} shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1

echo "[*] Sideload complete. Attached to process $QEMU_PID."
wait $QEMU_PID
