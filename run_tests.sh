#!/usr/bin/env bash
# Run every tests/*_test.q; exit non-zero if any test fails.
# QPATH is colon-separated, and this repo's path contains a colon ("q:kdb+"),
# so we cd to the repo root and use a *relative* module path.
set -euo pipefail
cd "$(dirname "$0")"
export QPATH="mod${QPATH:+:$QPATH}"
exec q tests/run.q -q
