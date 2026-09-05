---
name: docs-update
description: "AI-readable guidance for documentation updates in this project. Contains project-specific doc locations and update approach. AI reads this for context when implementing doc update workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Docs Update — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When updating documentation, AI reads this to understand project doc structure and conventions, then chooses appropriate mature skills (like `ecc:docs-sync`) or implements doc updates directly.

## Project facts

- Known documentation locations: {{DOC_LOCATIONS}} — plus the repo root (ARCHITECTURE.md, SPEC.md, WORKFLOW.md, HANDOFF.md default there)

## Documentation approach

There is no central catalog — the repository is the source of truth. Discover documents dynamically:

1. **Discover documents**:
   - Glob for skill-owned documents: `**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`, `**/HANDOFF.md`
   - Glob for project docs using known locations above: `*.md`, `docs/**/*.md`, `**/CONTRIBUTING.md`, ADR folders
   - Grep discovered docs to find which mention what changed

2. **Update affected documents**:
   - Skill-owned documents first: ARCHITECTURE.md (structure changes?), SPEC.md (goals/scope changes?), WORKFLOW.md (commands/process changes?)
   - Update each where it lives — never create root duplicates
   - Skip HANDOFF.md (owned by /handoff skill)
   - Then human-written docs affected by changes (README, API docs, etc.)
   - Match each document's existing tone and language

3. **Don't rewrite untouched documents**: Only update docs the changes actually affect.

## Workflow guidance

When AI needs to implement doc updates for this project:

1. Check if mature doc-sync skills are available (`ecc:docs-sync`, etc.) — use them if present
2. Otherwise, follow the discovery and update approach above
3. Report per-document edits: path + what changed (one line each)

## Keeping this guidance current

If project doc structure changes (new `docs/` tree, ADR folders), regenerate this guidance with `/generate-project-skills`.
