#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== PrismCalc automation =="
echo "Repo: ${ROOT_DIR}"

cd "${ROOT_DIR}"

echo "-- Swift build + tests"
swift build
swift test

echo "-- Website build"
cd "${ROOT_DIR}/website"
npm install
npm run build

if [[ "${RUN_PLAYWRIGHT:-1}" == "1" ]]; then
  echo "-- Playwright install + smoke tests"
  npx playwright install
  npm run test:e2e
else
  echo "-- Skipping Playwright (RUN_PLAYWRIGHT=0)"
fi
