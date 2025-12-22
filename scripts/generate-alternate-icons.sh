#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:-}"
OUTPUT_DIR="${2:-}"
TEMPLATE_DIR="App/Assets.xcassets/AppIcon.appiconset"

if [[ -z "${SOURCE}" || -z "${OUTPUT_DIR}" ]]; then
  echo "Usage: $0 <source-1024.png> <output-appiconset-dir>"
  exit 1
fi

if [[ ! -f "${SOURCE}" ]]; then
  echo "Error: source icon not found at ${SOURCE}"
  exit 1
fi

if [[ ! -d "${TEMPLATE_DIR}" ]]; then
  echo "Error: template appiconset not found at ${TEMPLATE_DIR}"
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"
cp "${TEMPLATE_DIR}/Contents.json" "${OUTPUT_DIR}/Contents.json"

# iPhone icons
sips -z 40 40 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-20@2x.png"
sips -z 60 60 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-20@3x.png"
sips -z 58 58 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-29@2x.png"
sips -z 87 87 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-29@3x.png"
sips -z 80 80 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-40@2x.png"
sips -z 120 120 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-40@3x.png"
sips -z 120 120 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-60@2x.png"
sips -z 180 180 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-60@3x.png"

# iPad icons
sips -z 20 20 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-20@1x.png"
sips -z 40 40 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-20~ipad@2x.png"
sips -z 29 29 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-29~ipad@1x.png"
sips -z 58 58 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-29~ipad@2x.png"
sips -z 40 40 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-40~ipad@1x.png"
sips -z 80 80 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-40~ipad@2x.png"
sips -z 76 76 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-76@1x.png"
sips -z 152 152 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-76@2x.png"
sips -z 167 167 "${SOURCE}" --out "${OUTPUT_DIR}/Icon-83.5@2x.png"

# App Store icon (1024x1024)
cp "${SOURCE}" "${OUTPUT_DIR}/Icon-1024.png"
