#!/usr/bin/env bash
# Clone apm at a "before" and "after" ref and install each into its own venv,
# so benchmark.py can invoke both `apm` builds side by side.
#
# Usage: ./setup_envs.sh [repo_url] [before_ref] [after_ref]
set -euo pipefail

REPO_URL="${1:-https://github.com/sekosen/apm.git}"
BEFORE_REF="${2:-29200432}"
AFTER_REF="${3:-perf/placement-large-tree-scaling-v3}"

# Windows venvs use Scripts/python.exe instead of bin/python.
venv_python() {
    if [ -x "$1/Scripts/python.exe" ]; then echo "$1/Scripts/python.exe"; else echo "$1/bin/python"; fi
}

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
    "$(venv_python "$WORK/$name-venv")" -m pip install --quiet -e "$WORK/$name-src"
done

echo
echo "Done. Interpreters:"
echo "  before: $(venv_python "$WORK/before-venv")"
echo "  after:  $(venv_python "$WORK/after-venv")"
