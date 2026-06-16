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
  pandoc "$src" \
    -f gfm+autolink_bare_uris \
    -t html5 \
    -s \
    --metadata title="$title" \
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
md_to_html "outputs/monotropism_de.md"    "outputs/monotropism_de.html"
md_to_html "outputs/monotropism_es.md"    "outputs/monotropism_es.html"
md_to_html "outputs/monotropism_fr.md"    "outputs/monotropism_fr.html"
md_to_html "outputs/monotropism_ita.md"   "outputs/monotropism_ita.html"

# Comorbidity landscape research brief (theory companion, English)
md_to_html "outputs/monotropism-comorbidity-landscape.md" "outputs/monotropism-comorbidity-landscape.html"

# Lifespan practitioner guide (English)
md_to_html "outputs/autistic-monotropism-lifespan-guide.md" \
           "outputs/autistic-monotropism-lifespan-guide.html"

# Family & relatives guide (English + translations)
for lang in "" "_de" "_es" "_fr" "_ita"; do
  md_to_html "outputs/autistic-monotropism-family-guide${lang}.md" \
             "outputs/autistic-monotropism-family-guide${lang}.html"
done

# Monotropic kids guidelines (ages 7-11): English + translations
for lang in "" "_de" "_es" "_fr" "_ita"; do
  md_to_html "outputs/monotropic-kids-guidelines${lang}.md" \
             "outputs/monotropic-kids-guidelines${lang}.html"
done

echo
echo "=== Done. HTML drafts in outputs/: ==="
ls -1 outputs/*.html 2>/dev/null
