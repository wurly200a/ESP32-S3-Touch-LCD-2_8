#!/usr/bin/env bash
# get-source.sh - Fetch Waveshare demo and place it into src/
# Behavior:
#   - Works whether run from project root or scripts/
#   - If src/ already exists, print a message and exit without changes
#   - Auto-detects the actual "*-Test" folder under ESP-IDF in the ZIP
# Dependencies: unzip, and either wget or curl

set -euo pipefail

URL="https://files.waveshare.com/wiki/ESP32-S3-Touch-LCD-2.8/ESP32-S3-Touch-LCD-2.8-Demo.zip"
ZIP_NAME="ESP32-S3-Touch-LCD-2.8-Demo.zip"

# --- Resolve project root from script location ---
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
if [[ "$(basename "$SCRIPT_DIR")" == "scripts" ]]; then
  ROOT_DIR="$(dirname "$SCRIPT_DIR")"
else
  ROOT_DIR="$SCRIPT_DIR"
fi
DEST_DIR="$ROOT_DIR/src"

# --- If src/ exists, do nothing ---
if [[ -d "$DEST_DIR" ]]; then
  echo "[INFO] '$DEST_DIR' already exists. Nothing to do."
  exit 0
fi

# --- Check basic deps ---
command -v unzip >/dev/null 2>&1 || { echo "ERROR: 'unzip' is required."; exit 1; }
DL=""
if command -v wget >/dev/null 2>&1; then
  DL="wget -O"
elif command -v curl >/dev/null 2>&1; then
  DL="curl -L -o"
else
  echo "ERROR: Need either 'wget' or 'curl'." >&2
  exit 1
fi

# --- Work in a temp dir ---
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

ARCHIVE_PATH="$WORKDIR/$ZIP_NAME"
UNZIP_DIR="$WORKDIR/unzip"
mkdir -p "$UNZIP_DIR"

echo "[INFO] Downloading demo archive..."
$DL "$ARCHIVE_PATH" "$URL"

echo "[INFO] Unzipping..."
unzip -q "$ARCHIVE_PATH" -d "$UNZIP_DIR"

# --- Auto-detect "*-Test" under ESP-IDF ---
# Accept patterns like:
#   .../ESP32-S3-*-Demo/ESP-IDF/ESP32-S3-*-Test
TEST_DIR="$(find "$UNZIP_DIR" -type d -path '*/ESP-IDF/*-Test' -print | head -n 1 || true)"

if [[ -z "$TEST_DIR" ]]; then
  echo "ERROR: Could not find '*-Test' directory under 'ESP-IDF' in the archive." >&2
  echo "       Please inspect the ZIP structure manually." >&2
  exit 1
fi

echo "[INFO] Installing into '$DEST_DIR' from: $TEST_DIR"
mkdir -p "$DEST_DIR"
cp -a "$TEST_DIR"/. "$DEST_DIR"/

echo "[DONE] Sources installed to: $DEST_DIR"
