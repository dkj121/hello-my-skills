---
name: handoff
description: "Compact the current conversation into HANDOFF.md so another agent or a future session can pick the work up. Use when the user asks for a handoff, wants to continue work in a new session, or wants a compact summary of where the work stands."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write
disable-model-invocation: true
argument-hint: "What the next session will be used for"
---

# Handoff

## Overview

Compact the conversation into HANDOFF.md, tailored for the next session to pick up the work. Extracts goals, decisions, what was done, what's in progress, and what's blocked. Overwrites the previous handoff since it describes the present state, not history.

## When to use

- When the user asks for a handoff
- When the user wants to continue work in a new session
- End of a work session to preserve context
- When a compact summary of current state is needed

## Steps

1. **Gather from conversation**: Read the conversation and extract:
   - The goal (what this work is ultimately for)
   - What was decided (key decisions with rationales)
   - What was done (files created/changed, commands run, outcomes)
   - What is in progress
   - What is blocked or uncertain

2. **Find project documents**: Use Glob searches for ARCHITECTURE.md, SPEC.md, WORKFLOW.md, HANDOFF.md (`**/HANDOFF.md`, etc.). They default to the repository root but the user may have moved them. The handoff states where each document stands — it does not duplicate their content.

3. **Inspect working tree**: Check uncommitted changes, TODO markers, and branch state for facts the conversation may not have mentioned.

4. **Write HANDOFF.md** with these sections:
   - **Goal** — what this work is ultimately for (one short paragraph)
   - **Where we are** — done / in progress / blocked, in that order
   - **Key decisions** — each with a one-line rationale
   - **Next steps** — concrete, ordered, immediately executable
   - **Suggested skills** — which skills the next session should start with (e.g. implement) and why
   - **Pitfalls** — anything that tripped this session

5. **Follow handoff rules**:
   - Write HANDOFF.md where the existing one lives; create at repository root if none exists
   - Overwrite the previous one — a handoff describes the present, not its own history
   - Redact sensitive values (tokens, credentials, personal data) — describe them, never copy them
   - Don't duplicate content that lives in other project documents; link to it
   - Use full file paths and exact commands; include error messages verbatim

## Report

State where HANDOFF.md was written and provide a one-sentence summary of the current state.
