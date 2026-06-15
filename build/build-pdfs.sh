#!/usr/bin/env bash
# Build clean PDFs from Markdown via pandoc -> HTML -> Chromium print.
set -euo pipefail
cd /mnt/2TB/Piero/Work/monotropism

STYLE="build/style.html"
mkdir -p build/tmp

md_to_pdf () {
  local src="$1"        # source .md
  local pdf="$2"        # output .pdf (path)
  local name
  name="$(basename "$src" .md)"
  local html="build/tmp/${name}.html"

  echo ">> $src  ->  $pdf"

  # Strip emoji that Chromium/DejaVu can't always render cleanly; keep it simple.
  pandoc "$src" \
    -f gfm+autolink_bare_uris \
    -t html5 \
    -s \
    --metadata title="$name" \
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

# Source-brief family: English original + translations
md_to_pdf "monotropism.md"     "monotropism.pdf"
md_to_pdf "monotropism_de.md"  "monotropism_de.pdf"
md_to_pdf "monotropism_es.md"  "monotropism_es.pdf"
md_to_pdf "monotropism_fr.md"  "monotropism_fr.pdf"
md_to_pdf "monotropism_ita.md" "monotropism_ita.pdf"

# Lifespan practitioner guide (English)
md_to_pdf "outputs/autistic-monotropism-lifespan-guide.md" \
          "outputs/autistic-monotropism-lifespan-guide.pdf"

# Family & relatives guide (English + translations)
for lang in "" "_de" "_es" "_fr" "_ita"; do
  src="outputs/autistic-monotropism-family-guide${lang}.md"
  pdf="outputs/autistic-monotropism-family-guide${lang}.pdf"
  [ -f "$src" ] && md_to_pdf "$src" "$pdf" || echo "   (skip — $src not found yet)"
done

echo
echo "=== Done. Built PDFs: ==="
ls -la monotropism*.pdf outputs/*.pdf 2>/dev/null
