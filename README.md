# ATS Killer — Job Application Agent

Paste a job description (JD) and get back an ATS-tailored resume plus a matching
cover letter, organized per application.

## What's here

```
.kiro/
  agents/
    job-application.json        # the orchestrating agent
  skills/
    resume-tailor/SKILL.md      # JD -> tailored LaTeX resume workflow
    cover-letter/SKILL.md       # research-backed cover letter drafting
    professional-writing/SKILL.md  # reusable prose polishing rules
parvez-akhtar-base-resume.tex   # source of truth (never edited by the agent)
applications/                   # generated per-application folders
```

## Usage

Start a chat with the agent from this directory:

```bash
kiro-cli chat --agent job-application
```

Then paste the JD (or a JD URL). The agent will:

1. **Parse** the JD — company, position, requirements, keywords (echoed back).
2. **Create** `applications/<company>__<position>/` and copy the base resume in.
3. **Research** role keywords + ATS best practices via web search.
4. **Tailor** the copied `.tex` — reorder/reword to mirror the JD, add genuine
   missing keywords, drop clutter. Metrics are preserved; nothing is fabricated.
5. **Report** a change summary plus a list of gaps (JD asks the resume can't back).
6. **Build** both a PDF (`tectonic`) and an ATS-clean DOCX (`pandoc` + filter).
7. **Cover letter** — mandatory for every application: research what makes a strong
   letter for the role, write `cover-letter.md`, and build `cover-letter.pdf` + `.docx`.
8. **Push** — automatically commits the application folder and pushes to the remote.

Example output folder:

```
applications/stripe__senior-ml-engineer/
  stripe-resume.tex
  stripe-resume.pdf
  stripe-resume.docx
  cover-letter.md
  cover-letter.pdf
  cover-letter.docx
```

## Safety & guardrails

- The base resume (`parvez-akhtar-base-resume.tex`) is **write-denied** to the agent.
- `write` is restricted to `applications/**` and `.kiro/skills/**`.
- `shell` is limited to `cp`, `mkdir`, `ls`, `pandoc`, `pdflatex`, `tectonic`, `which`.
- The agent never invents experience, dates, or metrics — it only re-maps what's
  already true on the base resume to the JD's language.

## Building PDF + DOCX

The agent builds both formats from the single tailored `.tex`. Dependencies:
`tectonic` (PDF), `pandoc` (DOCX), and optionally `poppler` (`pdfinfo`, for a
deterministic page-count check). To build manually from an application folder:

```bash
cd applications/<company>__<position>/

# PDF — self-contained engine, no Overleaf needed
tectonic <company>-resume.tex

# DOCX — ATS-clean; the Lua filter flattens heading tables into linear text
pandoc <company>-resume.tex \
  --lua-filter=../../.kiro/skills/resume-tailor/flatten-tables.lua \
  -o <company>-resume.docx
```

DOCX is preferred for Workday/Taleo (they parse it most reliably); PDF is fine for
AI-native systems (Ashby/Lever/Greenhouse). Send DOCX when the portal accepts it.

## Editing the skills

Each skill is a plain Markdown file with YAML frontmatter (`name`, `description`).
Edit the `SKILL.md` files to change the workflow; re-validate the agent with:

```bash
kiro-cli agent validate --path .kiro/agents/job-application.json
```
