---
name: handoff
description: "Compact the current conversation into HANDOFF.md at the repo root so another agent or a future session can pick the work up. Use when the user asks for a handoff, wants to continue work in a new session, or wants a compact summary of where the work stands."
---

# Handoff

Compact the conversation into HANDOFF.md at the repository root, tailored to what the next session will be used for. If the user stated a purpose when invoking this skill, optimize the document for it; otherwise write for a session that continues this work.

## Gather

1. Read the conversation. Extract: the goal; what was decided; what was done (files created/changed, commands run, outcomes); what is in progress; what is blocked or uncertain.
2. Read the project's root documents if present (ARCHITECTURE.md, SPEC.md, WORKFLOW.md, INDEX.md, HANDOFF.md). The handoff states where each stands — it does not duplicate their content.
3. Inspect the working tree (uncommitted changes, TODO markers, branch state) for facts the conversation may not have mentioned.

## Write HANDOFF.md

- **Goal** — what this work is ultimately for (one short paragraph)
- **Where we are** — done / in progress / blocked, in that order
- **Key decisions** — each with a one-line rationale
- **Next steps** — concrete, ordered, immediately executable
- **Suggested skills** — which skills the next session should start with (e.g. implement) and why
- **Pitfalls** — anything that tripped this session

## Rules

- Redact sensitive values (tokens, credentials, personal data) — describe them, never copy them.
- Don't duplicate content that lives in other project documents; link to it.
- Full file paths and exact commands; error messages verbatim.
- Overwrite any previous HANDOFF.md — a handoff describes the present, not its own history.
