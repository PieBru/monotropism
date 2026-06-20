# Session Status — 19 June 2026

## Project (PieBru/monotropism)
Repo: `/mnt/2TB/Piero/Work/monotropism` (branch `main`)
Remote tracking: `origin/main` (https://github.com/PieBru/monotropism)

---

## Phase A — Research Brief Translations (ALL DONE)

All 5 research briefs are now fully translated into **all 11 languages** (en, it, fr, es, de, pl, nl, ro, pt, ar, zh) and rendered to HTML + PDF.

| Brief | Languages |
|---|---|
| `monotropism` (foundational) | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** |
| `monotropism-comorbidity-landscape` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** |
| `monotropism-autism-prevalence-global` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** |
| `monotropism-scoring-levels-inertia` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** |
| `monotropism-comorbidities-factcheck` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** |
| `autistic-monotropism-lifespan-guide` | en, it, fr, es, de, pl, nl, ro, pt, ar — **ar done just now (this session)**; zh still **missing** (`.md` doesn't exist yet) |
| `autistic-monotropism-family-guide` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** (pre-existing) |
| `monotropic-kids-guidelines` | en, it, fr, es, de, pl, nl, ro, pt, ar, zh — **all complete** (pre-existing) |

## Phase B — Guideline Brochure Translations (PARTIAL)

| Language | Status | Notes |
|---|---|---|
| **en** (English) | ✅ Complete | Original seed grid |
| **it** (Italian) | ✅ Complete | `_ita`, ~70 brochures |
| **de** (German) | ✅ Complete | `_de`, ~70 brochures |
| **fr** (French) | ✅ Complete | `_fr`, ~70 brochures (done in earlier session) |
| **es** (Spanish) | ✅ Complete | `_es`, ~70 brochures (done in earlier session) |
| **pl** (Polish) | ❌ Not started | |
| **nl** (Dutch) | ❌ Not started | |
| **ro** (Romanian) | ❌ Not started | |
| **pt** (Portuguese) | ❌ Not started | |
| **ar** (Arabic) | ❌ Not started | |
| **zh** (Chinese) | ❌ Not started | |

## Current Working State (uncommitted changes)

The following files are **newly created** (untracked) — NOT in the last commit:

### Phase A — New Arabic brief (this session)
- `outputs/autistic-monotropism-lifespan-guide_ar.md` ✅
- `outputs/autistic-monotropism-lifespan-guide_ar.html` ✅
- `outputs/autistic-monotropism-lifespan-guide_ar.pdf` ✅

### Phase B — New Spanish & French brochures (from earlier sessions, NOT yet committed)
- All `outputs/guidelines/g-*_es.*` files (~70 md + html + pdf) ✅
- All `outputs/guidelines/g-*_fr.*` files (~70 md + html + pdf) ✅

### Modified files (stale timestamps from rebuild)
- `guidelines.html` (needs `GUIDE_LANG_SUFFIX` update to include `fr: "_fr"` and `es: "_es"`; the file may already reflect this from an earlier edit)
- All `outputs/*.pdf` and `outputs/guidelines/*.pdf` show modified timestamps (rebuild artifacts, content unchanged)

### Also uncommitted (Portuguese brief `.md`)
- `outputs/autistic-monotropism-lifespan-guide_pt.md` (this may have been committed already — check git history)

## Blockers / Pending

1. **`autistic-monotropism-lifespan-guide_zh.md`** — missing. Needs translation from the English source. Would complete Phase A for all 11 languages across all briefs.
2. **Phase B full rollout** — translate brochures for pl/nl/ro/pt/ar/zh (6 languages × ~70 brochures each).
3. **`index.html` DOCS array** — needs `ar` and `zh` added to `langs[]` for the 5 newer briefs (once files exist).
4. **MQ multi-language support** — user mentioned the topic but did not confirm proceeding.
5. **MQ item bias concern** — agent recommended not rewriting items; user did not respond.

## Verified Working
- Build pipeline (`build-html.sh` + `build-pdfs.sh`) works for all languages
- Arabic RTL rendering (`--metadata lang=ar --metadata dir=rtl`) works
- Chinese (zh) pandoc warnings about missing translations are cosmetic
- `build-guides.sh` auto-discovers `.md` in `outputs/guidelines/`

## How to Continue
1. `git status` to see all uncommitted files
2. Commit Phase A completion (Arabic brief) + Phase B (French + Spanish brochures)
3. Translate `autistic-monotropism-lifespan-guide_zh.md` for full Phase A
4. Roll out Phase B per language
5. Update `index.html` `DOCS` `langs[]` to include `ar`/`zh` for the 5 newer briefs
