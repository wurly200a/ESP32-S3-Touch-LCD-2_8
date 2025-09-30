#!/usr/bin/env bash

HOST_DIR="$PWD"
CONT_DIR="/workspaces/ESP32-S3-Touch-LCD-2_8"
MAP="${HOST_DIR}=${CONT_DIR}"

exec docker run --rm -i \
  -v "$HOST_DIR":"$CONT_DIR" \
  -w "$CONT_DIR" \
  ghcr.io/wurly200a/builder-esp32/esp-idf-v5.3:latest \
  bash -lc 'source /opt/esp-idf/export.sh >/dev/null 2>&1; \
            exec clangd --background-index --header-insertion-decorators=0 \
            --path-mappings='${MAP}' \
            --compile-commands-dir='"$CONT_DIR"'/src/build'
