---
name: core-docs-update
description: "AI-readable guidance for core documentation updates in this project. Contains project-specific doc locations. AI reads this for context when implementing core doc update workflows, not as a user-invocable skill. Core docs: ARCHITECTURE.md, SPEC.md, WORKFLOW.md."
allowed-tools: Read, Bash, Glob, Grep
---

# Core Docs Update — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When updating core documentation, AI reads this to understand project doc structure and conventions, then chooses appropriate mature doc-sync capabilities or implements core doc updates directly based on change scope.

**Core documentation files**: ARCHITECTURE.md (structure), SPEC.md (goals), WORKFLOW.md (process). These are foundational project documents. Other documentation (README, API docs, inline comments) is not covered by this guidance.

## Generation metadata

**Generated at:** {{GENERATION_TIMESTAMP}}
**Facts used for staleness detection:**
- Documentation locations: {{DOC_LOCATIONS}}

**Staleness check:** Before using this guidance, verify:
1. Core docs exist at expected paths (Glob: `**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`)
2. If docs moved and not found, this guidance is stale — prompt user to run `/generate-project-skills`

## Project facts

- Known documentation locations: {{DOC_LOCATIONS}} — plus the repo root (ARCHITECTURE.md, SPEC.md, WORKFLOW.md default there)

## Core documentation approach

There is no central catalog — the repository is the source of truth. Discover core documents dynamically:

1. **Discover core documents**:
   - Glob for core documents: `**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`
   - They default to the repo root, but the user may have moved them

2. **Update affected core documents**:
   - ARCHITECTURE.md (structure changes? module layout? data flow?)
   - SPEC.md (goals/scope changes? requirements?)
   - WORKFLOW.md (commands/process changes? build/test/deploy?)
   - Update each where it lives — never create root duplicates
   - Match each document's existing tone and language

3. **Don't update unless needed**: Only update core docs when implementation changes foundational contracts.

## When to update core documentation

Update core documentation only when implementation changes:

- **ARCHITECTURE.md**: Module structure, dependency flow, architectural patterns, tech stack
- **SPEC.md**: Goals, scope, requirements, implementation decisions, testing strategy
- **WORKFLOW.md**: Build/test/deploy commands, branching strategy, commit conventions, process changes

**Do not** modify core documentation merely to create activity. Most implementations don't need core doc updates.

## Proportionality

- **Trivial changes**: No core doc updates needed
- **Command/path changes**: Update WORKFLOW.md if build/test commands changed
- **New modules/patterns**: Update ARCHITECTURE.md
- **Architecture changes**: Update ARCHITECTURE.md, potentially SPEC.md

## Update guidance

When AI needs to implement core doc updates for this project:

**Check for mature doc-sync capabilities:** Look for environment-provided documentation sync tools. Use them when they exist and are appropriate for the change scope.

**Otherwise, implement updates:**
1. Discover affected core documents via Glob
2. Update each where it lives (no root duplicates)
3. Report per-document edits: path + what changed (one line each)

## Keeping this guidance current

If project doc structure changes (core docs moved), regenerate this guidance with `/generate-project-skills`.
