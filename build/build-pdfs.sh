#!/usr/bin/env bash
# Build clean PDFs from Markdown via pandoc -> HTML -> Chromium print.
# Layout: outputs/ holds all .md and .pdf; English source brief lives at repo root.
set -uo pipefail
cd /mnt/2TB/Piero/Work/monotropism

STYLE="build/style.html"
mkdir -p build/tmp

md_to_pdf () {
  local src="$1"        # source .md
  local pdf="$2"        # output .pdf
  local name html
  name="$(basename "$src" .md)"
  html="build/tmp/${name}.html"

  [ -f "$src" ] || { echo "   (skip — $src not found)"; return 0; }

  echo ">> $src  ->  $pdf"

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
    --metadata title="$name" \
    $langmeta \
    --wrap=preserve \
    -H "$STYLE" \
    -o "$html"

  chromium \
    --headless=new \
    --no-sandbox \
    --disable-gpu \
    --disable-dev-shm-usage \
    --no-pdf-header-footer \
    --print-to-pdf="$pdf" \
    "file://$(pwd)/$html" >/dev/null 2>&1

  if [ -s "$pdf" ]; then
    echo "   OK ($(du -h "$pdf" | cut -f1))"
  else
    echo "   FAIL: empty/missing PDF"
    return 1
  fi
}

# Source-brief family (English original at root; translations in outputs/)
md_to_pdf "monotropism.md"               "outputs/monotropism.pdf"
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_pdf "outputs/monotropism${lang}.md" "outputs/monotropism${lang}.pdf"
done

# Comorbidity landscape research brief (theory companion, English)
md_to_pdf "outputs/monotropism-comorbidity-landscape.md" "outputs/monotropism-comorbidity-landscape.pdf"

# Research briefs (theory, English)
md_to_pdf "outputs/monotropism-autism-prevalence-global.md" "outputs/monotropism-autism-prevalence-global.pdf"
md_to_pdf "outputs/monotropism-scoring-levels-inertia.md" "outputs/monotropism-scoring-levels-inertia.pdf"
md_to_pdf "outputs/monotropism-comorbidities-factcheck.md" "outputs/monotropism-comorbidities-factcheck.pdf"

# Lifespan practitioner guide (English)
md_to_pdf "outputs/autistic-monotropism-lifespan-guide.md" \
          "outputs/autistic-monotropism-lifespan-guide.pdf"

# Family & relatives guide (English + translations)
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_pdf "outputs/autistic-monotropism-family-guide${lang}.md" \
            "outputs/autistic-monotropism-family-guide${lang}.pdf"
done

# Monotropic kids guidelines (ages 7-11): English + translations
for lang in "" "_de" "_es" "_fr" "_ita" "_nl" "_pl" "_pt" "_ro" "_ar" "_zh"; do
  md_to_pdf "outputs/monotropic-kids-guidelines${lang}.md" \
            "outputs/monotropic-kids-guidelines${lang}.pdf"
done

rm -rf build/tmp
echo
echo "=== Done. PDFs in outputs/ and root: ==="
ls -la outputs/*.pdf 2>/dev/null
