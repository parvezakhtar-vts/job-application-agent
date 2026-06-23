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
6. **Cover letter** — on request, research what makes a strong letter for the role,
   then write `cover-letter.md` in the same folder.

Example output folder:

```
applications/stripe__senior-ml-engineer/
  stripe-resume.tex
  cover-letter.md
```

## Safety & guardrails

- The base resume (`parvez-akhtar-base-resume.tex`) is **write-denied** to the agent.
- `write` is restricted to `applications/**` and `.kiro/skills/**`.
- `shell` is limited to `cp`, `mkdir`, `ls`, `pdflatex`, `tectonic`, `which`.
- The agent never invents experience, dates, or metrics — it only re-maps what's
  already true on the base resume to the JD's language.

## Compiling to PDF (optional)

If you have a LaTeX engine installed, ask the agent to compile, or run:

```bash
cd applications/<company>__<position>/
pdflatex <company>-resume.tex     # or: tectonic <company>-resume.tex
```

## Editing the skills

Each skill is a plain Markdown file with YAML frontmatter (`name`, `description`).
Edit the `SKILL.md` files to change the workflow; re-validate the agent with:

```bash
kiro-cli agent validate --path .kiro/agents/job-application.json
```
