---
name: resume-tailor
description: Tailor a base LaTeX resume to a specific job description. Use when the user pastes a JD and wants an ATS-optimized resume. Parses the JD for company and role, creates a per-application folder, copies the base resume, web-researches role keywords and ATS best practices, then adds/removes keywords in the .tex without fabricating experience.
---

# Resume Tailor

Turn a pasted job description (JD) into a tailored, ATS-friendly copy of the base
resume — without inventing experience. You reword, reorder, and surface what is
already true on the base resume so it maps onto the JD's language.

## Inputs

- **Base resume**: `parvez-akhtar-base-resume.tex` (LaTeX, in the project root).
- **JD**: pasted by the user as plain text, or a URL the user asks you to fetch.

If the JD is a URL, fetch it first (`web_fetch`, truncated mode) before parsing.

## Workflow

### 1. Parse the JD
Extract and echo back to the user a short summary:
- **Company name** (e.g., "Stripe").
- **Position / title** (e.g., "Senior ML Engineer").
- **Seniority** and any location/remote signal.
- **Hard requirements** (must-have skills, years, tools, certs).
- **Nice-to-haves**.
- **Recurring keywords / phrases** — capture exact wording (ATS matches on terms,
  e.g., "RAG", "LangGraph", "distributed systems", "LLMOps").

If company or position cannot be confidently determined, ask the user once rather
than guessing.

### 2. Create the application folder
- Slugify company and position: lowercase, spaces/punct → hyphens.
- Create `applications/<company-slug>__<position-slug>/`.
  Example: `applications/stripe__senior-ml-engineer/`.
- Copy the base resume into it as `<company-slug>-resume.tex`.
  Use the `read` + `write` tools (read the base .tex, write the copy) or `cp` via
  shell. Never edit the base resume in place — it is the source of truth.

### 3. Web-research keywords & ATS best practices
Run a small parallel fan-out (see global Web Research conventions) before editing:
- `"<role title> resume keywords <current year>"`
- `"<role title> ATS keywords skills"`
- `"<key tech from JD> resume best practices"`
Goal: confirm the high-signal terms and synonyms ATS parsers and recruiters expect
for this specific role, and any phrasing conventions. Note 5–15 target keywords.
Keep this lightweight — 3–5 searches, fetch the 2–3 best sources.

### 4. Tailor the .tex (the core edit)
Edit only the copied .tex, never the base. Rules:

- **Truthfulness first.** Only surface skills/experience that already exist on the
  base resume. Rephrase to match JD vocabulary; do NOT fabricate tools, years, or
  outcomes. If the JD wants something the candidate lacks, leave it out and flag it
  to the user as a gap.
- **Mirror JD language.** If the resume says "vector databases" and the JD says
  "vector stores / embeddings", align the wording (within truth).
- **Professional Summary**: rewrite the 2–3 sentence summary to lead with the role's
  top 2–3 requirements that the candidate genuinely meets.
- **Technical Skills**: reorder so the JD's must-have stack appears first. Add
  genuine-but-missing keywords; remove or de-emphasize clutter irrelevant to this JD.
- **Experience bullets**: reorder bullets so the most JD-relevant impact leads each
  role. Lightly re-word to include target keywords. Preserve all metrics/numbers
  exactly — never alter quantified results.
- **Keep it ATS-safe**: plain section names, no tables/graphics for skills, standard
  fonts. The base template is already ATS-friendly — don't introduce parsing hazards.

### 5. Build both formats (PDF + DOCX)
From the application folder, produce both outputs from the single tailored `.tex`.
The candidate shares DOCX often (more readable; Workday/Taleo parse it best) and
PDF for AI-native systems (Ashby/Lever/Greenhouse).

```bash
# PDF (self-contained engine, no Overleaf needed)
tectonic <company-slug>-resume.tex

# DOCX — ATS-clean: the Lua filter flattens heading tables into linear text
pandoc <company-slug>-resume.tex \
  --lua-filter=../../.kiro/skills/resume-tailor/flatten-tables.lua \
  -o <company-slug>-resume.docx
```

Why the filter: pandoc expands the resume's custom macros fine, but turns each
job-heading `tabular*` into a 2-column table — exactly what strict ATS parsers
(Workday/Taleo) mangle. `flatten-tables.lua` converts those into plain
`Company — Location` / `Title — Dates` lines so parsing stays linear.

### 6. Parse self-check (don't skip)
After building, verify the DOCX an ATS would read is clean:
```bash
pandoc <company-slug>-resume.docx -t plain | grep -c -- "----"   # must be 0 (no tables)
```
Spot-check that target keywords survived extraction (ligature-prone words like
"fine-tuning", "classifier", "efficient" must appear intact). If the base `.tex`
lacks `\usepackage[T1]{fontenc}` + `\usepackage{lmodern}` + `\usepackage{cmap}`,
recommend adding them — they fix ligature breakage in extracted PDF text.

### 7. Report
Output a concise diff-style summary:
- Keywords added / removed / reordered.
- Sections changed.
- **Gaps**: JD requirements not supported by the resume (so the user can decide).
- Paths to both the `.pdf` and `.docx`.
- Result of the parse self-check.

## Guardrails
- Do not fabricate experience, employers, dates, or metrics.
- Do not modify `parvez-akhtar-base-resume.tex`.
- Keep the resume to one page unless the user asks otherwise — trim, don't pad.
- Preserve valid LaTeX (balanced braces, escaped `%`, `&`, `$`, `#`, `_`).

## After tailoring
Hand off to the `cover-letter` skill when the user wants a cover letter, and use the
`professional-writing` skill for any prose polishing along the way.
