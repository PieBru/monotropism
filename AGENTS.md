# AGENTS.md

Guidance for AI coding agents (Claude, GPT, local assistants, etc.) working in
this repository. Read this before editing content, code, or the build.

> **TL;DR** — This is a *content* repository, not a typical software project. The
> "source" is Markdown research drafts about **monotropism** (a cognitive theory
> of autism). We render them to standalone HTML + print-ready PDF with `pandoc`,
> and serve a single-file, multi-language landing page (`index.html`) on GitHub
> Pages. Most "code" changes are really **content + metadata** changes.

---

## 1. What this project is

**Monotropism** is a cognitive theory of autism, developed by autistic
researchers **Dinah Murray, Wenn Lawson, and Mike Lesser** from the early 1990s
onward. It explains autistic experience through differences in *attention* and
*interest* (a few interests aroused at once, each held deeply — "attention
tunnels"), in a unified, **non-pathologising** frame.

This repo publishes a **growing catalogue of research drafts and neuroaffirming
guides**, each authored in **English** and made available in **automated
translations** (Italian, French, Spanish, German), as both **standalone HTML**
and **print-ready PDF**. A live landing page is served at
**<https://piebru.github.io/monotropism/>**.

---

## 2. Repository layout

```
monotropism/
├── README.md                 # Human-facing catalogue + "at a glance" table (source of truth for the published list)
├── AGENTS.md                 # This file
├── LICENSE
├── .nojekyll                 # Tells GitHub Pages to serve raw files (no Jekyll)
├── .gitignore                # Ignores .* dirs, *.provenance.md, build/tmp/
│
├── index.html               # ★ The landing page — single-file HTML+CSS+JS, data-driven (see §6)
├── guidelines.html         # ★ Quick Guides grid hub — self-contained, data-driven (see §7 "Guidelines")
│
├── monotropism.md           # English source of the foundational brief (only EN brief lives at root)
│
├── build/
│   ├── style.html           # Shared <style> injected into every rendered HTML/PDF via pandoc -H
│   ├── guide-style.html     # Printer-friendly practical <style> for the quick-guide brochures
│   ├── build-html.sh        # md → standalone HTML (for landing-page "Read" links)
│   ├── build-pdfs.sh        # md → HTML → Chromium print → PDF
│   ├── build-guides.sh      # md → HTML → PDF for the quick-guide brochures (uses guide-style.html)
│   ├── strip-dup-title.py   # post-step: drop pandoc's visible title block when it dupes the H1
│   └── tmp/                 # transient build intermediates (gitignored)
│
└── outputs/                 # ★ All published drafts live here
    ├── <stem>.md            #   Markdown source (English)
    ├── <stem>_ita.md        #   …and translations (it/fr/es/de/pl/nl/ro/pt)
    ├── <stem>.html          #   rendered standalone HTML
    ├── <stem>.pdf           #   rendered print-ready PDF
    ├── guidelines/          #   ★ printable quick-guide brochures: g-<row>-<col>.{md,html,pdf}
    ├── <stem>.provenance.md #   research-provenance sidecar (gitignored — never commit)
    ├── .plans/              #   per-document research plans (gitignored)
    └── .drafts/             #   research workflow artifacts (gitignored)

└── sources/                 # ★ Local full-text copies of the sources cited in monotropism.md
    ├── NN-slug.html         #   served HTML page or rendered article (archived as-is)
    └── NN-slug.pdf          #   OA PDF (OSF / figshare / institutional repo / journal)
```

> **`README.md` is the source of truth for the *published* catalogue.** The
> `DOCS` array in `index.html` must stay in sync with it. A draft is "published"
> only once it is listed in both the README table and the landing page.

> **`sources/` is a static archive** of the primary sources cited by the
> foundational brief (`monotropism.md`). It is referenced by the `SOURCES` array
> in `index.html`, which renders a "References" section on the landing page (see
> §6). Committed (not gitignored).

---

## 3. Content model & naming conventions (read carefully)

Every published document is identified by a **`stem`** (file basename) and
belongs to one **category** and one or more **languages**.

### Languages & suffixes ⚠️ gotcha

| Code | Name      | File suffix | Flag |
|------|-----------|-------------|------|
| `en` | English   | *(none)*    | 🇬🇧   |
| `it` | Italiano  | `_ita`      | 🇮🇹   |
| `fr` | Français  | `_fr`       | 🇫🇷   |
| `es` | Español   | `_es`       | 🇪🇸   |
| `de` | Deutsch   | `_de`       | 🇩🇪   |
| `pl` | Polski    | `_pl`       | 🇵🇱   |
| `nl` | Nederlands| `_nl`       | 🇳🇱   |
| `ro` | Română    | `_ro`       | 🇷🇴   |
| `pt` | Português | `_pt`       | 🇵🇹   |

> **Italian uses `_ita`, not `_it`.** Match this exactly in filenames *and* in
> the landing page's `LANG_SUFFIX` map. English uses **no suffix**.

The English source of the foundational theory brief is the one exception to the
"everything in `outputs/`" rule: it lives at the **repo root** as
`monotropism.md` (its translations still live in `outputs/`).

### Categories

Four category slugs, displayed in this fixed order on the landing page
(`CAT_ORDER`):

| slug           | Audience                                  |
|----------------|-------------------------------------------|
| `theory`       | General / academic                        |
| `practitioner` | Practitioners & health-care professionals |
| `family`       | Parents, relatives, caregivers            |
| `kids`         | Adults around autistic children (ages 7–11) |

### Currently published (must stay mirrored: README ↔ `index.html` DOCS)

| Stem                                   | Cat            | Languages                       |
|----------------------------------------|----------------|--------------------------------|
| `monotropism`                          | `theory`       | en, it, fr, es, de, pl, nl, ro, pt |
| `monotropism-comorbidity-landscape`    | `theory`       | en                             |
| `autistic-monotropism-lifespan-guide`  | `practitioner` | en                             |
| `autistic-monotropism-family-guide`    | `family`       | en, it, fr, es, de, pl, nl, ro, pt |
| `monotropic-kids-guidelines`           | `kids`         | en, it, fr, es, de, pl, nl, ro, pt |

> **Two English-only drafts** (`monotropism-comorbidity-landscape`,
> `autistic-monotropism-lifespan-guide`) have no translations yet. Add languages
> per §8B when translations are produced.

---

## 4. Content lifecycle & provenance

A document is produced through a research workflow whose intermediate artifacts
are **gitignored** (they live under `outputs/.drafts/` and `outputs/.plans/`).
The only workflow artifact that matters for publishing is the **final Markdown**
plus its **`.provenance.md` sidecar**.

Typical per-document artifact set (all gitignored except the final `.md`):

```
outputs/.plans/<stem>.md                 # research plan
outputs/.drafts/<stem>-research-direct.md # raw research notes
outputs/.drafts/<stem>-draft.md           # first draft
outputs/.drafts/<stem>-cited.md           # draft with citations
outputs/.drafts/<stem>-verification.md    # source verification
outputs/<stem>.provenance.md              # provenance sidecar (gitignored)
outputs/<stem>.md                         # ★ final published Markdown (committed)
```

When producing a **new** draft, follow the same pattern: author in English, keep
the provenance sidecar alongside it, and **do not commit** the sidecar or any
`.drafts/`/`.plans/` files (`.gitignore` already excludes them — verify with
`git status`).

### Provenance sidecar

Each final `.md` has a `<stem>.provenance.md` recording: date, rounds, sources
consulted/accepted/rejected, verification status (e.g. `PASS WITH NOTES`), and
pointers to the research files. **Never invent sources, results, figures, or
benchmarks.** Every factual claim should trace to a real, reachable source
listed in the provenance file. DOIs that 302-redirect count as reachable.

---

## 5. Voice, tone & language rules (apply to all content & UI text)

- **Identity-first language** by default: **"autistic person"**, not "person
  with autism." Reflects the preference of the majority of the autistic
  community and the source theory's framing. Follow an individual's own stated
  preference where it differs.
- **Neuroaffirming / non-pathologising.** Monotropic vs. polytropic is a
  *difference in attention allocation*, not a deficit. Avoid clinical/deficit
  framing unless directly quoting a source.
- **Translations are AI-assisted** and must be disclosed as such (the landing
  page footer says so in every language). Don't claim human translation.
- **Informational, not medical advice** — no diagnostic claims. The README and
  footer state this; preserve it.
- Tone: plain language for family/kids guides; more academic register is fine
  for the theory brief.
- **Locked caregiver terminology** (no loanword "caregiver" in non-English
  drafts — use the established native term, singular / plural):

  | Lang | Caregiver term |
  |------|----------------|
  | `it` | assistente / assistenti |
  | `pl` | opiekun / opiekunowie |
  | `nl` | verzorger / verzorgers |
  | `ro` | îngrijitor / îngrijitori |
  | `pt` | cuidador / cuidadores |

  Keep this consistent across the `.md`, rendered `.html`/`.pdf`, and the
  landing page's per-language UI strings.

---

## 6. The landing page (`index.html`)

A **single, self-contained HTML+CSS+JS file** (no external CSS/JS/fonts; uses
system font stacks and emoji flags). It is **data-driven** — to change what's
shown you edit the data arrays in the `<script>`, not the markup.

### Architecture

- **Hash-routed "sites":** `#/` shows a **language picker** (home);
  `#/en`, `#/it`, `#/fr`, `#/es`, `#/de`, `#/pl`, `#/nl`, `#/ro`, `#/pt` show a **fully-localised landing page**
  for that language (title, tagline, intro, category headings, audience labels,
  descriptions, buttons and footer are all in the chosen language).
- **Only drafts available in a language are shown** on that language's page
  (e.g. the practitioner guide appears only on `#/en`).
- **Theme:** dark by default, toggle top-right of every view, persisted in
  `localStorage` (`mono-theme`), with a no-flash inline script in `<head>`.
- **Language switcher** (globe dropdown, top-right) appears on language pages;
  the home page has a back/chevron + wordmark only.

### The data you edit

Three structures drive everything (search for them in `index.html`):

```js
const LANGS       = [ { code: "en", flag: "🇬🇧" }, /* it, fr, es, de, pl, nl, ro, pt */ ];
const LANG_SUFFIX = { en: "", it: "_ita", fr: "_fr", es: "_es", de: "_de", pl: "_pl", nl: "_nl", ro: "_ro", pt: "_pt" };
const I18N        = { /* per-language UI strings: name, tagline, intro, headings,
                         read/pdf/open labels, category names (cat.theory…),
                         footer, aiNote, github link … */ };
const DOCS = [
  {
    cat: "theory",                       // one of: theory | practitioner | family | kids
    stem: "monotropism",                 // file basename; paths auto-built
    langs: ["en","it","fr","es","de","pl","nl","ro","pt"],   // which languages this draft is published in
    content: {
      en: { title, audience, desc },     // per-language display metadata
      it: { title, audience, desc },
      // …
    }
  },
  // …
];
const CAT_ORDER = ["theory", "practitioner", "family", "kids"];
```

Artifact paths are **derived, never hardcoded** — `outputs/<stem><suffix>.html`
and `.pdf`, where `suffix = LANG_SUFFIX[lang]`. So if filenames and the `DOCS`
data agree, the links are correct.

### Landing-page editing rules

- **Keep it single-file.** Do not split into separate CSS/JS files or add
  external dependencies (fonts, CDNs, JS frameworks). The whole point is one
  portable `index.html`.
- **Escape user/content strings.** Display text flows through an `esc()`
  helper; keep using it for any dynamic string.
- **Sync three things when publishing:** the Markdown in `outputs/`, the README
  "at a glance" table, and the `DOCS` array (+ `I18N` if a new language).
- Keep `data-theme="dark"` as the default in `<html>` and in the no-flash script.

### Source archive (`SOURCES` + `sources/`)

The home view also renders a collapsible **"References"** section listing the
primary sources cited by the foundational brief (`monotropism.md`). It is driven
by a `SOURCES` array (next to `DOCS`) plus committed static copies in
`sources/`:

```js
const SOURCES = [
  { n:"1", cite:"…", local:"sources/01-….html", kind:"html", url:"https://…", access:"open" },
  { n:"6", cite:"…", url:"https://doi.org/…", access:"oapublisher" }, // no local copy
  // …
];
```

- `n` matches the brief's footnote number (the source skips `[4]` and `[7]`).
- `local` / `kind` (`"html"`|`"pdf"`) point at a committed copy in `sources/`
  when one exists; the item then shows an **HTML/PDF** button.
- `access` marks the tier:
  - `"open"` — local full-text copy archived.
  - `"oapublisher"` — free to read on the publisher site but not downloadable
    here (e.g. SAGE bot-walls). Renders a "free to read (publisher)" badge and a
    DOI link only.
  - `"closed"` — paywalled; renders an "abstract / paywalled" badge + DOI link.

When adding a source: download a legitimate OA/repository copy into `sources/`
(prefer PMC / OSF / figshare / institutional repos / open web), give it an
`NN-slug.ext` name, and add a `SOURCES` entry. **Never** bypass paywalls or
publisher bot protection to obtain a copy; if only the publisher page is
reachable, set `access` accordingly and omit `local`.

---

## 7. Build & render pipeline

Both builders are plain `bash` + `pandoc`. `pandoc` and `chromium` must be on
`PATH` (they are in this environment). All rendering shares `build/style.html`
injected via pandoc's `-H` (include-in-header).

```bash
# Render every published draft to standalone HTML (what the landing page links to)
bash build/build-html.sh

# Render every published draft to print-ready PDF
bash build/build-pdfs.sh
```

Pipeline detail:
- **HTML:** `pandoc <stem>.md -f gfm+autolink_bare_uris -t html5 -s -H build/style.html -o <stem>.html`
  (the document's first `# H1` is used as the `<title>`). After pandoc,
  `build/strip-dup-title.py` removes pandoc's visible page-title block
  (`<header id="title-block-header">`) **when it duplicates the document's own
  first H1** (same or similar), so the title isn't shown twice. `<head><title>`
  for the browser tab is always kept. The strip is conditional — it only fires
  on a match, so a genuinely distinct title block is preserved.
- **PDF:** the same `pandoc` HTML step produces a temp file in `build/tmp/`,
  then `chromium --headless=new --no-pdf-header-footer --print-to-pdf=…` prints
  it to A4. `build/tmp/` is gitignored. (The PDF title block currently uses the
  file stem, not the document H1 — see "Known follow-ups" below.)

> Always run **both** builders after changing Markdown or `build/style.html`,
> so `.html` and `.pdf` stay in sync with the sources.

**Known follow-ups (not yet done):**
- `build-pdfs.sh` sets `--metadata title="$name"` (the file stem, e.g.
  `monotropism_ita`), so a PDF's visible title block shows the filename rather
  than the document title, and is not de-duplicated. Aligning it with the HTML
  pipeline (title = first H1 + `strip-dup-title.py`) would make both outputs
  consistent — do this if you touch the PDF build.

### `build/style.html`

The shared stylesheet for rendered drafts (print + screen). It targets A4,
defines serif body / sans headings, blockquote, table, code, and `@page` footer
pagination. If you restyle drafts, edit this one file — do **not** inject styles
into individual Markdown files.

### Guidelines (Quick Guides) — a second content track

Separate from the long-form drafts, the repo has a grid of **printable,
two-page practical quick guides** (`guidelines.html` hub).

- **Hub page:** `guidelines.html` (self-contained, dark-by-default, data-driven).
  Linked as *“Quick guides”* in `index.html`’s top bar.
- **Sources & renders:** `outputs/guidelines/g-<row>-<col>.{md,html,pdf}` (cells),
  `g-row-<row>.*` (row summaries), `g-col-<col>.*` (column summaries).
- **Grid taxonomy** (locked for the English seed):
  - **Rows** (the autistic person, by life stage): `preschool` · `primary` ·
    `secondary` · `university` · `worker` · `parent` · `senior` · `assisted`.
  - **Columns** (the reader/counterpart): `parents` · `teachers` · `coaches` ·
    `doctor` · `caregivers` · `colleagues` · `eldercare` · `peers`.
  - **Gender** (male/female) is a **cross-cutting callout** inside each sheet
    (`## If the person is a girl / a woman {.gender}`), *not* a separate axis.
  - Some cells are **N/A** (e.g. a primary child has no *colleagues*); these are
    listed in the hub’s `NA` set and rendered dimmed, never authored.
- **Build:** `bash build/build-guides.sh` (or `build/build-guides.sh <stem> …`).
  Uses `build/guide-style.html` (printer-friendly, light, practical) and renders
  with **`-f markdown`** (not `gfm`) so header **classes** are honoured:
  `{.lead}` (one-idea box), `{.do}` / `{.dont}` (green/red sections),
  `{.support}` (amber callout), `{.gender}` (violet note), `{.foot}` (footer).
  Same pandoc→chromium PDF pipeline as the main docs. Cell guides must fit
  **2 pages** (A4 front/back); row/column summaries are *extended* (3–4 pp).
- **Adding guides:** (1) author the `.md` in `outputs/guidelines/` using the
  established structure and deriving content from the research drafts (monotropism
  brief, lifespan practitioner guide, family guide, kids guidelines) +
  `sources/`; (2) `bash build/build-guides.sh <stem>`; (3) add the stem to the
  `READY` set in `guidelines.html`; (4) verify the cell still prints to 2 pages.
- **Localization:** build the **English grid first**, fine-tune the template,
  then produce localized grids per language (English grid is the source of truth).

---

## 8. Common tasks

### A. Publish a new research draft (English)

1. Author `outputs/<stem>.md` in English (identity-first, neuroaffirming,
   cited). Keep a `<stem>.provenance.md` sidecar (do not commit it).
2. Add the document to the **README.md** "at a glance" table (new row, EN cell).
3. Add a `DOCS` entry in `index.html` (`cat`, `stem`, `langs: ["en"]`,
   `content.en`).
4. Add the `md_to_html` / `md_to_pdf` call for the new stem in **both**
   `build/build-html.sh` and `build/build-pdfs.sh`.
5. Run both builders; verify `outputs/<stem>.html` and `<stem>.pdf` exist.
6. `git status` — confirm no `.provenance.md`, `.drafts/`, or `.plans/` files
   are staged.

### B. Add a translation to an existing draft

1. Create `outputs/<stem>_<suffix>.md` (use the correct suffix from §3;
   `_ita`, `_fr`, `_es`, `_de`). Translate from the English source.
2. In the README table, fill that language's cell for the row.
3. In `index.html`, add the language code to the draft's `langs[]` **and** add a
   matching `content.<code>` block (localized `title`/`audience`/`desc`).
4. Add the new language variant to both build scripts (mirror the existing
   `for lang in …` loops).
5. Run both builders; confirm `outputs/<stem>_<suffix>.{html,pdf}` exist.

### C. Add a brand-new language

1. Add to `LANGS` (with flag), `LANG_SUFFIX` (with suffix), and a full `I18N`
   block (every key, including `cat.theory…cat.kids`).
2. For each draft that gets translated, add the suffix file, the README cell,
   the `langs[]` entry, and the `content.<code>` block.
3. Add each new variant to both build scripts.
4. Rebuild.

### D. Restyle drafts (HTML + PDF)

Edit **`build/style.html`** only, then re-run both builders. Do not put
presentation in the Markdown.

### E. Restyle the landing page

Edit `index.html` directly (it is one file). Verify with the checks in §9.

---

## 9. Verification checklist (run before committing)

```bash
# 1. Landing-page JS parses cleanly
awk '/<script>/{f=1;next} /<\/script>/{f=0} f' index.html > /tmp/c.js && node --check /tmp/c.js

# 2. Every artifact referenced by the landing page actually exists
#    (16 docs × {html,pdf} = 32 files for the current catalogue)
ls outputs/*.html outputs/*.pdf

# 3. Render sanity check (headless Chromium DOM dump), strip <script>, grep counts
chromium --headless=new --no-sandbox --disable-gpu --dump-dom \
  --virtual-time-budget=1500 "file://$PWD/index.html#/it" 2>/dev/null \
  | perl -0777 -pe 's/<script\b.*?<\/script>//gs'

# 4. No provenance / drafts / plans leaked into git
git status --short | grep -E 'provenance|\.drafts|\.plans' && echo "LEAK!" || echo "clean"
```

Key things to confirm after edits:
- Home (`#/`) shows **5** language cards; **no** language switcher; theme toggle present.
- A language page (e.g. `#/it`) shows only that language's drafts (Italian = 3
  of 4; English = all 4), with localized title/category/footer and a working
  language switcher + back button.
- `<title>` and `<html lang>` update per route.
- "Read" links point to `outputs/<stem><suffix>.html`; "PDF" to `.pdf`.

---

## 10. Deployment (GitHub Pages)

- Branch **`main`** is published. The site is served **raw** (`.nojekyll`
  disables Jekyll), so `index.html`, `outputs/*.html`, and `outputs/*.pdf` are
  served as-is at <https://piebru.github.io/monotropism/>.
- **Commit the rendered artifacts.** Unlike a typical site, the `.html`/`.pdf`
  outputs in `outputs/` *are* part of the published site and should be committed
  (they are not build artifacts in the CI sense — there is no CI).
- Relative paths in `index.html` (`outputs/…`) resolve correctly both locally
  (`file://`) and on Pages.
- Do not remove `.nojekyll`.

---

## 11. Git conventions

- **`.gitignore`** excludes: all dotfiles/dot-directories (`.*`, which covers
  `.drafts/`, `.plans/`, `.git/`), all `*.provenance.md`, and `build/tmp/`.
- **Never commit:** provenance sidecars, `.drafts/`, `.plans/`, or `build/tmp/`.
- **Always commit:** `outputs/*.md` (final sources), `outputs/*.html`,
  `outputs/*.pdf`, `index.html`, `README.md`, `build/*.sh`, `build/style.html`.
- Commit messages: short imperative summary; for content, prefix with the doc,
  e.g. `family-guide: add French translation` or `landing: add comorbidity draft`.

---

## 12. Hard rules / "don'ts"

- ❌ Don't add external dependencies to `index.html` (no CDNs, fonts, frameworks).
- ❌ Don't split `index.html` into multiple files.
- ❌ Don't hardcode artifact paths in the landing page — derive them from `stem`
  + `LANG_SUFFIX`.
- ❌ Don't use `_it` for Italian — it's `_ita` (in filenames **and** `LANG_SUFFIX`).
- ❌ Don't invent sources/results/figures; don't remove the AI-translation or
  "not medical advice" disclosures.
- ❌ Don't commit `*.provenance.md`, `.drafts/`, `.plans/`, or `build/tmp/`.
- ❌ Don't introduce pathologising/deficit framing or person-first language by
  default.
- ❌ Don't publish a draft in `DOCS`/README without first generating its `.html`
  and `.pdf` via the build scripts.

---

## 13. Quick reference

| Need to…                | Do this                                                            |
|-------------------------|--------------------------------------------------------------------|
| Render all HTML         | `bash build/build-html.sh`                                         |
| Render all PDFs         | `bash build/build-pdfs.sh`                                         |
| Preview locally         | open `index.html` (or `index.html#/it`) in a browser               |
| Add a draft             | §8A — md → README → `DOCS` → both build scripts → build            |
| Add a translation       | §8B — `_suffix.md` → README cell → `langs`+`content` → scripts → build |
| Add a language          | §8C — `LANGS`/`LANG_SUFFIX`/`I18N` + per-draft data + scripts → build |
| Restyle drafts          | edit `build/style.html` only, then rebuild                         |
| Restyle landing page    | edit `index.html`, then §9 checks                                  |
