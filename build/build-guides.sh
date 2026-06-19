#!/usr/bin/env bash
# Build the printable Quick-Guide brochures (practical, 2 pages, A4 front/back).
#   Source markdown : outputs/guidelines/<stem>.md   (pandoc 'markdown', so
#                     header classes like {.do} {.dont} {.support} are honoured)
#   Rendered output : outputs/guidelines/<stem>.html  +  <stem>.pdf
# Stems may be passed as args; with no args, every .md in the dir is built.
set -uo pipefail
cd /mnt/2TB/Piero/Work/monotropism

STYLE="build/guide-style.html"
STRIP="build/strip-dup-title.py"
DIR="outputs/guidelines"
mkdir -p "$DIR"

build_guide () {
  local stem="$1" src html pdf title
  src="$DIR/$stem.md"
  html="$DIR/$stem.html"
  pdf="$DIR/$stem.pdf"
  [ -f "$src" ] || { echo "   (skip — $src not found)"; return 0; }

  # HTML <title> = document's first H1.
  title="$(grep -m1 '^# ' "$src" | sed 's/^#[[:space:]]*//; s/[[:space:]]*$//')"
  [ -n "$title" ] || title="$stem"

  # RTL + lang metadata for translated guides (Arabic is right-to-left).
  local langmeta=""
  case "$stem" in
    *_ar) langmeta="--metadata lang=ar --metadata dir=rtl" ;;
    *_zh) langmeta="--metadata lang=zh" ;;
  esac

  echo ">> $stem"
  pandoc "$src" \
    -f markdown+autolink_bare_uris \
    -t html5 \
    -s \
    --metadata title="$title" \
    $langmeta \
    --wrap=preserve \
    -H "$STYLE" \
    -o "$html"

  # Drop pandoc's visible title block (keep <head><title>).
  python3 "$STRIP" "$html" >/dev/null

  chromium \
    --headless=new \
    --no-sandbox \
    --disable-gpu \
    --disable-dev-shm-usage \
    --no-pdf-header-footer \
    --print-to-pdf="$pdf" \
    "file://$(pwd)/$html" >/dev/null 2>&1

  if [ -s "$pdf" ]; then
    echo "   OK pdf=$(du -h "$pdf" | cut -f1)  html=$(du -h "$html" | cut -f1)"
  else
    echo "   FAIL: empty/missing PDF"
    return 1
  fi
}

if [ "$#" -gt 0 ]; then
  stems=("$@")
else
  mapfile -t stems < <(cd "$DIR" && ls -1 *.md 2>/dev/null | sed 's/\.md$//')
fi

for s in "${stems[@]}"; do build_guide "$s"; done

echo
echo "=== Done. Guides in $DIR/ ==="
ls -1 "$DIR"/*.pdf 2>/dev/null | wc -l | xargs echo "PDFs:"
