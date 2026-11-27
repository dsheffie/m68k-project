#!/bin/sh
# Build the Formal spec pages from an m68k-formal-spec checkout:
#   docs/formal-spec/index.md       tools/formal_spec_head.md + README.md + nqthm/README.md
#   docs/formal-spec/background.md  BACKGROUND.md
#   docs/formal-spec/pla.md         pla/README.md
#   docs/formal-spec/examples.md    EXAMPLES.md
#   tools/pull_formal_spec.sh path/to/m68k-formal-spec
set -eu
SPEC=${1:?usage: tools/pull_formal_spec.sh path/to/m68k-formal-spec}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=$ROOT/docs/formal-spec
mkdir -p "$OUT"
REV=$(git -C "$SPEC" rev-parse --short HEAD)
BLOB=https://github.com/dsheffie/m68k-formal-spec/blob/$REV

# Relative links in the repo's Markdown: the files this site has pages for
# point at those pages; anything else points at the file on GitHub. $2 is the
# file's directory in the repo ("", "nqthm/" or "pla/").
links() {
    sed -E -e "s#\]\(([^):\#]+)\)#]($BLOB/$2\1)#g" \
           -e "s#($BLOB)/[^/)]+/\.\./#\1/#g" \
           -e "s#\]\($BLOB/BACKGROUND\.md\)#](background.md)#g" \
           -e "s#\]\($BLOB/EXAMPLES\.md\)#](examples.md)#g" \
           -e "s#\]\($BLOB/pla/README\.md\)#](pla.md)#g" "$1"
}
# Demote headings one level (outside code fences) to nest under the page title.
demote() {
    awk '/^```/ { f = !f } !f && /^#/ { $0 = "#" $0 } { print }'
}
stamp() {
    printf '\n---\n\n*Pulled from [dsheffie/m68k-formal-spec](https://github.com/dsheffie/m68k-formal-spec/tree/%s) %s.*\n' "$REV" "$REV"
}

{
    cat "$ROOT/tools/formal_spec_head.md"
    printf '\n'
    links "$SPEC/README.md" "" | demote
    printf '\n'
    links "$SPEC/nqthm/README.md" "nqthm/" | demote
    stamp
} > "$OUT/index.md"

{
    links "$SPEC/BACKGROUND.md" ""
    stamp
} > "$OUT/background.md"

{
    links "$SPEC/pla/README.md" "pla/"
    stamp
} > "$OUT/pla.md"

{
    links "$SPEC/EXAMPLES.md" ""
    stamp
} > "$OUT/examples.md"

echo "docs/formal-spec/ <- m68k-formal-spec $REV"
