---
name: resume-tailor
description: Tailors a base LaTeX resume to a specific job description and builds ATS-clean PDF + DOCX. Use when the user pastes a job description (JD) or JD URL and wants an ATS-optimized resume. Parses the JD for company and role, creates a per-application folder, copies the base resume, researches role keywords, rewrites the .tex to mirror the JD without fabricating experience, builds both formats, and auto-commits the result.
---

# Resume Tailor

Turn a pasted job description (JD) into a tailored, ATS-clean copy of the base
resume — without inventing experience. Reword, reorder, and surface what is already
true so it maps onto the JD's language, then build PDF + DOCX.

For how modern ATS parse and rank resumes (semantic matching, format kill-list,
platform/file-format guidance), see [ats-notes.md](ats-notes.md). Read it before
the tailoring edit.

## Inputs
- **Base resume**: `parvez-akhtar-base-resume.tex` (LaTeX, project root). Never edit it.
- **JD**: pasted text, or a URL to fetch first (`web_fetch`, truncated mode).

## Workflow checklist
Copy this into your reply and check items off as you go:
```
- [ ] 1. Parse JD (company, role, requirements, exact keywords) and echo summary
- [ ] 2. Create applications/<company>__<position>/ and copy base resume in
- [ ] 3. Research role keywords (3-5 parallel searches) + read ats-notes.md
- [ ] 4. Tailor the copied .tex (mirror JD, prove skills in bullets, no fabrication)
- [ ] 5. Build PDF (tectonic) + DOCX (pandoc + flatten-tables.lua)
- [ ] 6. Parse self-check; if it fails, fix and rebuild
- [ ] 7. Report changes + gaps
- [ ] 8. Auto-commit & push the application folder
```

### 1. Parse the JD
Echo a short summary: company, position/title, seniority, location/remote, hard
requirements, nice-to-haves, and recurring keywords (capture exact wording). If
company or position is unclear, ask once rather than guessing.

### 2. Create the application folder
Slugify company and position (lowercase, non-alphanumeric → hyphens). Create
`applications/<company-slug>__<position-slug>/` and copy the base resume in as
`<company-slug>-resume.tex` (`cp`). The base resume stays untouched.

### 3. Research keywords
Run a small parallel fan-out (3-5 searches): `"<role> resume keywords <current year>"`,
`"<role> ATS keywords skills"`, `"<key tech> resume best practices"`. Note 5-15 target
keywords and synonyms. Read [ats-notes.md](ats-notes.md) for the durable rules.

### 4. Tailor the .tex (core edit)
Edit only the copied .tex. Rules:
- **Truthful.** Only surface skills/experience already on the base resume. Rephrase to
  match JD vocabulary; never fabricate tools, years, or outcomes. Flag what's missing
  as a gap instead of inventing it.
- **Mirror JD language.** Align wording to the JD's exact terms (within truth).
- **Prove skills in bullets.** Every high-priority Skills keyword should also appear,
  with a result, in an experience bullet — semantic screeners treat unproven skills as
  noise. (See ats-notes.md → Prove skills in bullets.)
- **Expand acronyms once**, e.g. "RAG (Retrieval-Augmented Generation)".
- **Summary**: lead with the role's top 2-3 requirements the candidate genuinely meets.
- **Technical Skills**: reorder so the JD's must-have stack is first; add genuine
  missing keywords; drop irrelevant clutter.
- **Experience**: reorder bullets so the most JD-relevant impact leads. Preserve every
  metric exactly.
- **No manipulation.** No hidden text, no keyword stuffing (see ats-notes.md).
- **Valid LaTeX**: balanced braces; escape `% & $ # _`.

### 5. Build PDF + DOCX
From the application folder, build both from the single tailored `.tex`:
```bash
tectonic <company-slug>-resume.tex

pandoc <company-slug>-resume.tex \
  --lua-filter=../../.kiro/skills/resume-tailor/flatten-tables.lua \
  -o <company-slug>-resume.docx
```
The Lua filter flattens the job-heading `tabular*` blocks into plain
`Company — Location` / `Title — Dates` lines so strict parsers read them linearly.

### 6. Parse self-check (feedback loop)
```bash
pandoc <company-slug>-resume.docx -t plain | grep -c -- "----"   # expect 0
```
Confirm target keywords (and ligature-prone words like "fine-tuning", "classifier",
"efficient") survive extraction. **If the count is not 0 or keywords are missing or
broken, fix the cause and rebuild before continuing** — do not report a failing build.

### 7. Report
Concise diff-style summary: keywords added/removed/reordered; sections changed;
**Gaps** (JD asks the resume can't back); paths to the `.pdf` and `.docx`; self-check result.

### 8. Auto-commit & push
Commit just this application folder and push so the user never has to:
```bash
git add applications/<company-slug>__<position-slug>/
git commit -m "Add tailored application: <Company> — <Position>"
git push
```
If `git push` fails (e.g. no network/auth), report it and leave the commit in place.

## Guardrails
- Never fabricate experience, employers, dates, or metrics.
- Never modify `parvez-akhtar-base-resume.tex`.
- Keep the resume to one page unless the user asks otherwise — trim, don't pad.

## After tailoring
Hand off to the `cover-letter` skill when the user wants a cover letter; use the
`professional-writing` skill to polish prose.
