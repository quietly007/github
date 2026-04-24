#!/usr/bin/env bash
# build-deck.sh — assemble an HTML deck from one Markdown file per slide.
#
# Usage:
#   ./build-deck.sh <slides-dir> [output.html]
#
# Convention:
#   <slides-dir>/01-cover.md
#   <slides-dir>/02-problem.md
#   ...
#   Files are processed in filename sort order. First filename component
#   (before the dash) must be a zero-padded number.
#
# Frontmatter (YAML, optional) per slide:
#   ---
#   class: cover            # adds CSS class "cover" to the section
#   kicker: "the problem"   # small uppercase line above h2
#   ---
#
# Output: a single HTML file linking to ../deck.css (sibling to the template dir)
# or to deck.css if placed next to the output file.

set -euo pipefail

SLIDES_DIR="${1:?usage: $0 <slides-dir> [output.html]}"
OUT="${2:-deck.html}"

if [[ ! -d "$SLIDES_DIR" ]]; then
  echo "error: $SLIDES_DIR is not a directory" >&2; exit 2
fi

command -v pandoc >/dev/null || { echo "error: pandoc not found" >&2; exit 3; }
command -v python3 >/dev/null || { echo "error: python3 not found" >&2; exit 3; }

# Discover slides in sort order
mapfile -t SLIDES < <(find "$SLIDES_DIR" -maxdepth 1 -type f -name '*.md' | sort)
TOTAL="${#SLIDES[@]}"
if (( TOTAL == 0 )); then echo "error: no .md slides in $SLIDES_DIR" >&2; exit 4; fi

TITLE="$(awk -F'"' '/^title:/{print $2; exit}' "${SLIDES[0]}" 2>/dev/null || true)"
TITLE="${TITLE:-qui3tly.cloud deck}"

TMP="$(mktemp -d)"; trap "rm -rf $TMP" EXIT
N=0
for md in "${SLIDES[@]}"; do
  N=$((N+1))
  PAD="$(printf '%02d' "$N")"
  python3 - "$md" "$PAD" "$TOTAL" "$TMP/$PAD.html" <<'PY'
import sys, re, subprocess, pathlib
src, pad, total, out = sys.argv[1:5]
text = pathlib.Path(src).read_text()

# YAML frontmatter
meta = {}
m = re.match(r'^---\n(.*?)\n---\n', text, re.S)
if m:
    for line in m.group(1).splitlines():
        if ':' in line:
            k, v = line.split(':', 1)
            meta[k.strip()] = v.strip().strip('"').strip("'")
    text = text[m.end():]

cls   = meta.get('class', '').strip()
kick  = meta.get('kicker', '').strip()

html_body = subprocess.run(
    ['pandoc', '--from=markdown', '--to=html5', '--no-highlight'],
    input=text, text=True, capture_output=True, check=True).stdout

section_cls = ('slide ' + cls).strip()
kicker_html = f'<div class="kicker">{kick}</div>\n' if kick else ''
total_str = str(total)
# data-n pattern "NN" and CSS already does " / TOTAL" suffix; we inject TOTAL via data attr
section = (f'<section class="{section_cls}" data-n="{pad}" data-total="{total_str}">\n'
           f'{kicker_html}{html_body}</section>\n')
pathlib.Path(out).write_text(section)
PY
done

# Compose final HTML
{
  cat <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>$TITLE</title>
<link rel="stylesheet" href="deck.css" />
<style>
/* Total-slides injected by generator so CSS counter reflects actual deck length */
.slide::after { content: attr(data-n) " / $TOTAL"; }
</style>
</head>
<body>
HTML
  cat "$TMP"/*.html
  echo "</body></html>"
} > "$OUT"

SIZE=$(wc -c < "$OUT")
echo "built: $OUT  ($TOTAL slides, $SIZE bytes)"
