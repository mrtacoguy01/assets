#!/bin/bash
set -e

# Configuration
APK_URL="https://hermivore.cat/cdn/swan/changeinvalue"
WORK_DIR="/config/android"
APK_PATH="/config/roblox.apk"
# Bliss OS 14 (Android 11) - stable virtio-gpu & libndk ARM translation
BLISS_ISO_URL="https://sourceforge.net/projects/blissos-dev/files/Android-Generic/PC/gearlock/11/Bliss-OS-14.10-x86_64-20230718.iso/download"
ADB_PORT=5555

echo "=========================================="
echo "[1/5] Installing Arch & QEMU Packages"
echo "=========================================="

pacman -Syu --noconfirm --needed qemu-desktop qemu-ui-gtk android-tools wget curl unzip

# Ensure KVM permissions
if [ -e /dev/kvm ]; then
    chmod 666 /dev/kvm
else
    echo "[!] /dev/kvm not found in container. Start container with: --device /dev/kvm:/dev/kvm"
    exit 1
fi

echo "=========================================="
echo "[2/5] Setting up Storage & Android Image"
echo "=========================================="
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

if [ ! -f "bliss.iso" ]; then
    echo "[*] Downloading Bliss OS..."
    wget -q --show-progress -O bliss.iso "$BLISS_ISO_URL"
fi

if [ ! -f "data.qcow2" ]; then
    echo "[*] Initializing 16GB sparse data drive..."
    qemu-img create -f qcow2 data.qcow2 16G
fi

echo "=========================================="
echo "[3/5] Fetching Target APK"
echo "=========================================="
echo "[*] Downloading APK from $APK_URL..."
curl -L --progress-bar -o "$APK_PATH" "$APK_URL"
chmod 644 "$APK_PATH"

echo "=========================================="
echo "[4/5] Launching Android with VirtIO-GPU"
echo "=========================================="
killall -9 qemu-system-x86_64 2>/dev/null || true

# Launch QEMU with virtio-gpu and serial redirected
runuser -u abc -- env DISPLAY=:1 WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 \
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -device virtio-gpu-pci \
  -display gtk \
  -serial mon:stdio \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::${ADB_PORT}-:5555 \
  -device virtio-tablet \
  -device virtio-keyboard \
  -drive file=${WORK_DIR}/data.qcow2,if=virtio,format=qcow2 \
  -cdrom ${WORK_DIR}/bliss.iso \
  -boot menu=on &

QEMU_PID=$!

echo "=========================================="
echo "[5/5] Polling ADB & Auto-Deploying APK"
echo "=========================================="
echo "[*] Polling ADB bridge on 127.0.0.1:${ADB_PORT}..."
until adb connect 127.0.0.1:${ADB_PORT} 2>/dev/null | grep -q "connected"; do
    sleep 2
done

echo "[*] ADB connection established. Waiting for Android to complete boot..."
until [ "$(adb -s 127.0.0.1:${ADB_PORT} shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = "1" ]; do
    sleep 3
done

echo "[*] Android userland fully online."
echo "[*] Installing APK: $APK_PATH..."
adb -s 127.0.0.1:${ADB_PORT} install -r -g "$APK_PATH"

PACKAGE_NAME="com.roblox.client"

echo "[*] Starting $PACKAGE_NAME..."
adb -s 127.0.0.1:${ADB_PORT} shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1

echo "[*] Sideload complete. Container process tethered to PID $QEMU_PID."
wait $QEMU_PID
