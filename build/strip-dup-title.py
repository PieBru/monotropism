#!/usr/bin/env python3
"""Strip pandoc's visible page-title block when it duplicates the document title.

pandoc with `-s --metadata title=...` emits the title in two visible places:
  1. <head><title>...</title></head>            (browser tab — KEEP)
  2. <header id="title-block-header"><h1 class="title">…</h1></header>  (REMOVE if dup)

The document body already begins with its own `# H1`. When that H1 is the same
as (or similar to) the pandoc title block, the title block is redundant, so this
script removes it. "Similar" = equal after normalising case, accents,
punctuation and whitespace, or one being a substring of the other.

Usage:  python3 build/strip-dup-title.py <file.html> [<file.html> ...]
"""
import re
import sys
import html
import unicodedata


def norm(s: str) -> str:
    """Lowercase, drop accents/punctuation, collapse whitespace."""
    s = html.unescape(s).lower()
    s = unicodedata.normalize("NFKD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))
    s = re.sub(r"[^a-z0-9 ]", " ", s)
    return re.sub(r"\s+", " ", s).strip()


def strip_text(s: str) -> str:
    return re.sub(r"<[^>]+>", "", s).strip()


for path in sys.argv[1:]:
    with open(path, encoding="utf-8") as f:
        doc = f.read()

    m = re.search(
        r'<header id="title-block-header">.*?</header>\s*', doc, re.S
    )
    if not m:
        continue

    block_text = strip_text(m.group(0))
    # the document's own first H1 (search after removing the title block)
    rest = doc[: m.start()] + doc[m.end():]
    h1 = re.search(r"<h1[^>]*>.*?</h1>", rest, re.S)
    if not h1:
        continue

    a, b = norm(block_text), norm(strip_text(h1.group(0)))
    similar = bool(a) and (a == b or a in b or b in a)

    if similar:
        doc = doc[: m.start()] + doc[m.end():]
        with open(path, "w", encoding="utf-8") as f:
            f.write(doc)
        print(f"   stripped duplicate title block: {path}")
