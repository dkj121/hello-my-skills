---
name: docs-update
description: "AI-readable guidance for documentation updates in this project. Contains project-specific doc locations and update approach. AI reads this for context when implementing doc update workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Docs Update — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When updating documentation, AI reads this to understand project doc structure and conventions, then chooses appropriate mature doc-sync capabilities or implements doc updates directly based on change scope.

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

## When to update documentation

Update documentation only when implementation changes:

- Documented behavior
- Architecture or structure
- Public interfaces or APIs
- Workflows or operational procedures
- Build/test/deployment commands

**Do not** modify documentation merely to create activity.

## Proportionality

- **Trivial changes**: May not need doc updates
- **Command/path changes**: Update specific references
- **New features**: Add to relevant docs (README, API docs)
- **Architecture changes**: Update ARCHITECTURE.md, potentially SPEC.md

## Update guidance

When AI needs to implement doc updates for this project:

**Check for mature doc-sync capabilities:** Look for environment-provided documentation sync tools. Use them when they exist and are appropriate for the change scope.

**Otherwise, implement updates:**
1. Discover affected documents via Glob/Grep
2. Update each where it lives (no root duplicates)
3. Report per-document edits: path + what changed (one line each)

## Keeping this guidance current

If project doc structure changes (new `docs/` tree, ADR folders), regenerate this guidance with `/generate-project-skills`.
