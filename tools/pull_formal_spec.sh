#!/bin/sh
# Build docs/formal-spec.md from tools/formal_spec_head.md and the READMEs of
# an m68k-formal-spec checkout.
#   tools/pull_formal_spec.sh path/to/m68k-formal-spec
set -eu
SPEC=${1:?usage: tools/pull_formal_spec.sh path/to/m68k-formal-spec}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=$ROOT/docs/formal-spec.md

# Demote a README's headings one level (outside code fences) so they nest
# under this page's title.
demote() {
    awk '/^```/ { f = !f } !f && /^#/ { $0 = "#" $0 } { print }' "$1"
}

REV=$(git -C "$SPEC" rev-parse --short HEAD)
{
    cat "$ROOT/tools/formal_spec_head.md"
    printf '\n'
    demote "$SPEC/README.md"
    printf '\n'
    demote "$SPEC/nqthm/README.md"
    printf '\n---\n\n*Pulled from [dsheffie/m68k-formal-spec](https://github.com/dsheffie/m68k-formal-spec/tree/%s) %s.*\n' "$REV" "$REV"
} > "$OUT"
echo "docs/formal-spec.md <- m68k-formal-spec $REV"
