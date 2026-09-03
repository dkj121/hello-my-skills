---
name: docs-update
description: "Keep the project's documentation in sync with the codebase — discover the project's documents with Glob/Grep, then update the ones affected by recent changes. Use after changes land, when the user asks to update docs, or when documents have drifted from the code."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write, Agent
---

# Docs Update

Find the project's documents, then update the ones the recent changes affected.

## Self-maintenance — run this first

This skill is a living artifact of this codebase. Before starting:

1. Verify the document locations below still match reality (Glob for them — the user may have moved documents since this skill was written).
2. If new documentation areas appeared (a `docs/` subtree, an ADR folder), record them in this SKILL.md first (both copies: `.claude/skills/docs-update/` and `.agents/skills/docs-update/`), then include them in your discovery.

## Project facts

- Known documentation locations: {{DOC_LOCATIONS}} — plus the repo root (ARCHITECTURE.md, SPEC.md, WORKFLOW.md, HANDOFF.md default there)

## Step 1 — Discover the documents

There is no central catalog — the repository is the source of truth. Discover documents dynamically every run:

- Glob for the skill-owned documents wherever they live: `**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`, `**/HANDOFF.md`. They default to the repo root, but the user may have moved them.
- Glob for the project's other documentation, guided by the known locations above and the repo layout: `*.md`, `docs/**/*.md`, `**/CONTRIBUTING.md`, ADR folders.
- Grep the discovered documents when you need to know which ones mention what changed — a renamed command, a moved file, a changed endpoint.

## Step 2 — Update affected documents

From the change context (conversation, recent diffs) and your discovery:

- Skill-owned documents first: ARCHITECTURE.md (did structure change?), SPEC.md (did goals or scope change?), WORKFLOW.md (did commands or process change?). Update each where it lives — never create a duplicate at the root when the document exists elsewhere.
- HANDOFF.md is owned by the handoff skill — don't edit it.
- Then any human-written document the changes affect — a README section referencing a renamed command, an API doc for a changed endpoint. Match each document's existing tone and language.
- Don't rewrite documents the changes don't touch. Don't create documents nobody asked for.

## Output

Report per-document edits — one line each: path + what changed.
