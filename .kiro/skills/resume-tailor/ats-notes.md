# ATS Notes (reference)

Durable reference for how modern applicant tracking systems read resumes, loaded
on demand by the resume-tailor skill. Role-specific keywords are still researched
live per JD; this file holds the stable principles.

## Contents
- Semantic matching (ATS 2.0)
- Prove skills in bullets
- Acronym expansion
- Anti-manipulation (what gets you rejected)
- Format kill-list
- Platform & file-format guidance

## Semantic matching (ATS 2.0)
Modern systems (and the AI summarizer layered on Workday/Greenhouse/Lever/Ashby)
use NLP, not just keyword counting. They infer whether a skill is genuinely
demonstrated from surrounding context, score fit against the JD, and recruiters
read that AI summary first. Implication: context and evidence beat raw keyword
frequency.

## Prove skills in bullets
An isolated Skills list reads as "unverified" to semantic screeners. Every
high-priority keyword in the Skills section should also appear, in context with a
result, in an experience bullet. Treat Skills as a table of contents, not a
substitute for evidence.

## Acronym expansion
Spell out an acronym once with its expansion, e.g. "RAG (Retrieval-Augmented
Generation)". This captures both the abbreviation and the expanded phrase for
keyword and semantic matching. Applies to RAG, MCP, RBAC, LoRA, NDCG, etc.

## Anti-manipulation (what gets you rejected)
These are detected and trigger rejection or blacklisting — never do them:
- Hidden/white-on-white text or invisible keywords.
- Keyword stuffing / unnatural repetition.
- Metadata or off-screen keyword dumps.
Optimization means genuine matching, not tricks.

## Format kill-list
- Multi-column layouts (parsers interleave columns).
- Tables/text boxes for content (strict parsers garble cells).
- Images/icons of text, skill bars, charts.
- Contact info in the header/footer region (some parsers skip it).
- Non-standard section names ("My Journey" → use "Experience").
- Decorative fonts; ligature-prone PDF output (see preamble fixes below).

## Platform & file-format guidance
- Workday (most Fortune 100) and Taleo: strict; prefer DOCX, exact keyword match.
- Greenhouse/Lever: forgiving parser, recruiter reads early — human-readability matters.
- Ashby and AI-native: PDF fine; the AI summary/headline is most influential.
- Default: send DOCX where the portal accepts it; PDF for AI-native systems.

## LaTeX/PDF text-extraction note
The base resume's formatting is canonical: do not change its preamble, fonts, or
page geometry to chase extraction "fixes" — visual consistency with the base matters
more. pdflatex/CM ligatures (`fi`/`fl`) can occasionally drop in extracted text; if a
specific role needs guaranteed extraction, the only no-visual-change addition is
`\usepackage{cmap}` (adds a ToUnicode map). Do not add `fontenc`/`lmodern`/`microtype`
or switch paper size, as those visibly alter the layout.
