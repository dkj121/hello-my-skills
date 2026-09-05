---
name: to-docs
description: "Turn the shared understanding from this conversation into three living project documents — ARCHITECTURE.md, SPEC.md, and WORKFLOW.md. Use when the user asks to write up, document, or spec the plan or project, or right after a design discussion (e.g. a grill session) reaches confirmed consensus."
---

# To Docs

## Overview

Distill the conversation's confirmed understanding into three project documents: ARCHITECTURE.md (structure), SPEC.md (goals), and WORKFLOW.md (process). Synthesizes what has been agreed without re-interviewing. Updates existing documents in place rather than overwriting them.

## When to use

- After a design discussion reaches confirmed consensus
- When the user asks to "write up", "document", or "spec" the plan
- Right after a grill session completes
- When project understanding needs to be captured in living documents

## Steps

1. **Locate existing documents**: Use Glob searches (`**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`) to find where each document lives. The user may have moved them from the repository root. Update documents where found; create new ones at the repository root. Never create root duplicates of documents that exist elsewhere.

2. **Explore the repository**: 
   - Understand structure, tech stack, existing docs, test setup, build tooling
   - The documents must describe this specific project, not a generic one

3. **Read existing documents**: If any of the three documents already exist (wherever they live), read them first. Update in place — keep what is still accurate and preserve human-written notes. Never blind-overwrite.

4. **Write ARCHITECTURE.md** (the structure):
   - Tech stack and key dependencies (versions where they matter)
   - Module map: what each top-level directory owns
   - How pieces interact: dependency direction, data flow, external interfaces
   - Where new code of each kind belongs

5. **Write SPEC.md** (the goals):
   Use these sections; omit ones with no content yet:
   - **Problem Statement** — the user's problem, in the user's terms
   - **Solution** — the agreed solution, in the user's terms
   - **User Stories** — numbered: "As a <actor>, I want <feature>, so that <benefit>"
   - **Implementation Decisions** — modules, interfaces, schema changes, API contracts. No file paths or code unless a decision is only capturable as one (a state machine, a type shape) — then keep it minimal
   - **Testing Decisions** — which behaviors are tested and at which seams; test external behavior, not internals; note prior art in the codebase
   - **Out of Scope**
   - **Further Notes**

6. **Write WORKFLOW.md** (the process):
   The operational contract that the implement skill executes against:
   - Exact commands: setup, build, run, test, lint/typecheck
   - Workflow conventions: branching, commit style, definition of done
   - Which project-level skills exist (test, code-review, docs-update) and when they run

7. **Follow writing rules**:
   - Write for a competent engineer new to this project
   - Keep each document focused; link out to dedicated docs rather than inlining detail
   - Don't duplicate what git history records (no "last updated" stamps)

## Report

Briefly state:
- What changed in each document (ARCHITECTURE.md, SPEC.md, WORKFLOW.md)
- Where each document lives (file paths)
