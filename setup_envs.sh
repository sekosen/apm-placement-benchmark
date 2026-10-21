#!/usr/bin/env bash
# Clone apm at a "before" and "after" ref and install each into its own venv,
# so benchmark.py can invoke both `apm` builds side by side.
#
# Usage: ./setup_envs.sh [repo_url] [before_ref] [after_ref]
set -euo pipefail

REPO_URL="${1:-https://github.com/mukkumayc/apm.git}"
BEFORE_REF="${2:-2e2d0683}"
AFTER_REF="${3:-perf/placement-large-tree-scaling-v3}"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HERE/.work"
rm -rf "$WORK"
mkdir -p "$WORK"

for pair in "before:$BEFORE_REF" "after:$AFTER_REF"; do
    name="${pair%%:*}"
    ref="${pair#*:}"
    echo "== Cloning $REPO_URL @ $ref -> $name =="
    git clone --quiet "$REPO_URL" "$WORK/$name-src"
    git -C "$WORK/$name-src" checkout --quiet "$ref"
    python -m venv "$WORK/$name-venv"
    "$WORK/$name-venv/bin/python" -m pip install --quiet -e "$WORK/$name-src"
done

echo
echo "Done. Binaries:"
echo "  before: $WORK/before-venv/bin/apm"
echo "  after:  $WORK/after-venv/bin/apm"
