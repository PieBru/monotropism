#!/usr/bin/env bash
# Build standalone, readable HTML for each draft (for the "Read" links on the
# landing page). Mirrors the document list in build-pdfs.sh. Outputs land in
# outputs/<name>.html next to the matching .pdf.
set -uo pipefail
cd /mnt/2TB/Piero/Work/monotropism

STYLE="build/style.html"
STRIP="build/strip-dup-title.py"
mkdir -p outputs

md_to_html () {
  local src="$1"        # source .md
  local out="$2"        # output .html
  local name title
  name="$(basename "$src" .md)"
  [ -f "$src" ] || { echo "   (skip — $src not found)"; return 0; }

  # Use the document's first H1 as the HTML <title>.
  title="$(grep -m1 '^# ' "$src" | sed 's/^#[[:space:]]*//; s/[[:space:]]*$//')"
  [ -n "$title" ] || title="$name"

  echo ">> $src  ->  $out"
  # RTL + lang metadata for translated drafts (Arabic is right-to-left)
  local langmeta=""
  case "$name" in
    *_ar) langmeta="--metadata lang=ar --metadata dir=rtl" ;;
    *_zh) langmeta="--metadata lang=zh" ;;
  esac
  pandoc "$src" \
    -f gfm+autolink_bare_uris \
    -t html5 \
    -s \
    --metadata title="$title" \
    $langmeta \
    --wrap=preserve \
    -H "$STYLE" \
    -o "$out"

  # Drop pandoc's visible page-title block when it duplicates the document's
  # own first H1 (keeps <head><title> for the browser tab).
  python3 "$STRIP" "$out" >/dev/null

  if [ -s "$out" ]; then
    echo "   OK ($(du -h "$out" | cut -f1))"
  else
    echo "   FAIL: empty/missing HTML"
    return 1
  fi
}

# Source-brief family (English original at root; translations in outputs/)
md_to_html "monotropism.md"               "outputs/monotropism.html"
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_html "outputs/monotropism${lang}.md" "outputs/monotropism${lang}.html"
done

# Comorbidity landscape research brief (theory companion, English)
md_to_html "outputs/monotropism-comorbidity-landscape.md" "outputs/monotropism-comorbidity-landscape.html"

# Research briefs (theory, English)
md_to_html "outputs/monotropism-autism-prevalence-global.md" "outputs/monotropism-autism-prevalence-global.html"
md_to_html "outputs/monotropism-scoring-levels-inertia.md" "outputs/monotropism-scoring-levels-inertia.html"
md_to_html "outputs/monotropism-comorbidities-factcheck.md" "outputs/monotropism-comorbidities-factcheck.html"

# Lifespan practitioner guide (English)
md_to_html "outputs/autistic-monotropism-lifespan-guide.md" \
           "outputs/autistic-monotropism-lifespan-guide.html"

# Family & relatives guide (English + translations)
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_html "outputs/autistic-monotropism-family-guide${lang}.md" \
             "outputs/autistic-monotropism-family-guide${lang}.html"
done

# Monotropic kids guidelines (ages 7-11): English + translations
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_html "outputs/monotropic-kids-guidelines${lang}.md" \
             "outputs/monotropic-kids-guidelines${lang}.html"
done

echo
echo "=== Done. HTML drafts in outputs/: ==="
ls -1 outputs/*.html 2>/dev/null
