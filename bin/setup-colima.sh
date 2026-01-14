#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.colima/default"
CONFIG_FILE="$CONFIG_DIR/colima.yaml"

mkdir -p "$CONFIG_DIR"

# -----------------------------
# Dynamic values (variables)
# -----------------------------

# CPU count
CPU_COUNT="$(sysctl -n hw.ncpu)"

# Memory (GB): half system RAM, capped at 8GB
TOTAL_MEM_BYTES="$(sysctl -n hw.memsize)"
TOTAL_MEM_GB="$(( TOTAL_MEM_BYTES / 1024 / 1024 / 1024 ))"
HALF_MEM_GB="$(( TOTAL_MEM_GB / 2 ))"
MEMORY_GB=$(( HALF_MEM_GB > 8 ? 8 : HALF_MEM_GB ))
(( MEMORY_GB < 1 )) && MEMORY_GB=1

# Architecture detection
ARCH_RAW="$(uname -m)"
ARCH="x86_64"
ROSETTA="false"
NESTED_VIRT="false"

if [[ "$ARCH_RAW" == "arm64" ]]; then
  ARCH="aarch64"
  ROSETTA="true"

  # Enable nested virtualization only on M3+
  CPU_BRAND="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || true)"
  if [[ "$CPU_BRAND" =~ Apple\ M([3-9]|[1-9][0-9]) ]]; then
    NESTED_VIRT="true"
  fi
fi

# -----------------------------
# Static defaults (Colima-style)
# -----------------------------

DISK_GB=100
RUNTIME="docker"
VM_TYPE="vz"
MOUNT_TYPE="virtiofs"

# -----------------------------
# Write config atomically
# -----------------------------

TMP_FILE="$(mktemp)"

cat > "$TMP_FILE" <<EOF
cpu: $CPU_COUNT
disk: $DISK_GB
memory: $MEMORY_GB
arch: $ARCH
runtime: $RUNTIME
hostname: ""

kubernetes:
  enabled: false
  version: v1.33.4+k3s1
  k3sArgs:
    - --disable=traefik
  port: 0

autoActivate: true

network:
  address: false
  mode: shared
  interface: en0
  preferredRoute: false
  dns: []
  dnsHosts: {}
  hostAddresses: false

forwardAgent: false
docker: {}

vmType: $VM_TYPE
portForwarder: ssh
rosetta: $ROSETTA
binfmt: false
nestedVirtualization: $NESTED_VIRT

mountType: $MOUNT_TYPE
mountInotify: true
cpuType: host
provision: []

sshConfig: true
sshPort: 0

mounts:
  - location: /Users
    writable: true
  - location: /Volumes
    writable: true

diskImage: ""
rootDisk: 20
env: {}
EOF

mv "$TMP_FILE" "$CONFIG_FILE"

echo "Colima config written successfully:"
echo "  $CONFIG_FILE"
echo
echo "Resolved values:"
echo "  CPUs: $CPU_COUNT"
echo "  Memory: ${MEMORY_GB}GB"
echo "  Disk: ${DISK_GB}GB"
echo "  Architecture: $ARCH"
echo "  Rosetta: $ROSETTA"
echo "  Nested virtualization: $NESTED_VIRT"