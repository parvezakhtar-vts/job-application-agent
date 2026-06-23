---
name: cover-letter
description: Drafts a tailored, compelling cover letter for a specific job description. Use after a resume has been tailored, or whenever the user asks for a cover letter. Researches what makes a strong cover letter for the role, then produces a concise, specific, non-generic letter grounded in the candidate's real resume, and auto-commits it.
---

# Cover Letter

Write a focused cover letter that connects the candidate's real experience to a
specific role and company. The goal is specific and earned, never generic filler.

## Inputs
- The **JD** (company, role, priorities) — reuse the parse from `resume-tailor` if
  already done in this session.
- The **tailored resume** (or base resume) as the source of truth for claims.
- Optional: anything the user shares about why they want this role/company.

## Workflow

### 1. Research what makes a strong cover letter
Run a light parallel fan-out before drafting (see global Web Research conventions):
- `"what makes a great cover letter <current year>"`
- `"cover letter structure tips software engineer"` (swap in the actual role)
- `"<company name> cover letter tips"` or recent company news for a hook.
Extract: ideal length, structure, opening-hook patterns, and common mistakes to
avoid. Keep it to 3–5 searches and 2–3 fetches.

### 2. Gather the raw material
From the resume, pick the **2–3 strongest, most relevant** proof points for this JD
(quantified impact preferred). Identify the company's stated priorities and one
genuine reason to be interested in *this* company (mission, product, recent news).

### 3. Draft
Structure (keep to ~250–350 words, 3–4 short paragraphs, one page):
1. **Hook (1–2 sentences):** who you are + why this specific role/company. No
   "I am writing to apply for...".
2. **Proof (1–2 paragraphs):** 2–3 concrete achievements mapped directly to the JD's
   top needs, with metrics. Show, don't claim.
3. **Fit / motivation (short):** why this company specifically — grounded, not flattery.
4. **Close:** confident, forward-looking call to action.

### 4. Output
- Write to the application folder as
  `applications/<company-slug>__<position-slug>/cover-letter.md`
  (plain Markdown so it's easy to paste/edit). Offer a `.tex` version on request.
- Include a `[Hiring Manager Name]` placeholder if the name is unknown; suggest the
  user look it up on LinkedIn.
- Weave in 2-3 of the JD's target keywords naturally (many ATS parse the letter too).

### 5. Commit & push
In the normal flow, a cover letter is written for every application and the
resume-tailor skill commits the whole folder once at the end (resume + formats +
this letter). **If this skill is run standalone** (no resume tailoring in this run),
commit and push yourself:
```bash
git add applications/<company-slug>__<position-slug>/cover-letter.md
git commit -m "Add cover letter: <Company> — <Position>"
git push
```
If `git push` fails, report it and leave the commit in place.

## Guardrails
- Every claim must be backed by the resume — no invented projects or numbers.
- No em dashes (`—`): use commas, colons, parentheses, or split into two sentences.
- No clichés ("team player", "fast-paced environment", "I am passionate about").
- Specific > generic: a letter that could be sent to any company has failed.
- Match the company's tone (formal vs. startup-casual) based on the JD's voice.
- Apply the `professional-writing` skill to tighten the final prose.
