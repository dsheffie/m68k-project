#!/bin/sh
# Regenerate uisa's docs in a uisa checkout and copy them into docs/uisa/.
#   tools/pull_uisa.sh path/to/uisa
# Needs python3 + PyYAML and pdflatex (tikz, listings, enumitem, fancyhdr,
# titlesec, changepage, longtable, hyperref) for `make pdf`.
set -eu
UISA=${1:?usage: tools/pull_uisa.sh path/to/uisa}
OUT=$(cd "$(dirname "$0")/.." && pwd)/docs/uisa

# -B: a fresh clone gives every file the same mtime, so make would skip the stale ones
make -B -C "$UISA" gen flows pdf

cp "$UISA/doc/uisa.pdf"                  "$OUT/uisa.pdf"
# doc/uisa.md is doc/intro.md + the generated reference; one page each, so
# each gets its own table of contents. GitHub tables escape | in code spans
# as \|; Python-Markdown keeps code spans whole, so it needs no escape.
cp "$UISA/doc/intro.md"                  "$OUT/rationale.md"
sed -n '/^# Reference (generated)/,$p' "$UISA/doc/uisa.md" | sed 's/\\|/|/g' > "$OUT/reference.md"
cp "$UISA/doc/flows.md"                  "$OUT/flows.md"
cp "$UISA/compiler/README.md"            "$OUT/ucc.md"
cp "$UISA/millicode/softfloat/README.md" "$OUT/softfloat.md"

# Stamp each generated page with the uisa commit it came from.
REV=$(git -C "$UISA" rev-parse --short HEAD)
BRANCH=$(git -C "$UISA" rev-parse --abbrev-ref HEAD)
for f in rationale reference flows ucc softfloat; do
    printf '\n---\n\n*Generated from [dsheffie/uisa](https://github.com/dsheffie/uisa/tree/%s) %s (%s).*\n' \
        "$REV" "$REV" "$BRANCH" >> "$OUT/$f.md"
done
echo "docs/uisa/ <- uisa $REV ($BRANCH)"
