---
name: to-docs
description: "Turn the shared understanding from this conversation into three living project documents at the repo root: ARCHITECTURE.md, SPEC.md, and WORKFLOW.md. Use when the user asks to write up, document, or spec the plan or project, or right after a design discussion (e.g. a grill session) reaches confirmed consensus."
---

# To Docs

Distill the conversation's confirmed understanding into three documents at the repository root. Synthesize what has been agreed — do not re-interview. If something essential is still undecided, ask about it once, concisely, then proceed.

## Before writing

1. Explore the repository: structure, tech stack, existing docs, test setup, build tooling. The documents must describe this project, not a generic one.
2. If ARCHITECTURE.md, SPEC.md, or WORKFLOW.md already exist, read them first. Update in place — keep whatever is still accurate and any human-written notes. Never blind-overwrite.

## The three documents

### ARCHITECTURE.md — the structure

- Tech stack and key dependencies (versions where they matter)
- Module map: what each top-level directory owns
- How the pieces interact: dependency direction, data flow, external interfaces
- Where new code of each kind belongs

### SPEC.md — the goals

Use these sections; omit the ones with no content yet:

- **Problem Statement** — the user's problem, in the user's terms
- **Solution** — the agreed solution, in the user's terms
- **User Stories** — numbered: "As a \<actor\>, I want \<feature\>, so that \<benefit\>"
- **Implementation Decisions** — modules, interfaces, schema changes, API contracts. No file paths or code, unless a decision is only capturable as one (a state machine, a type shape) — then keep it minimal.
- **Testing Decisions** — which behaviors are tested and at which seams; test external behavior, not internals; note prior art in the codebase.
- **Out of Scope**
- **Further Notes**

### WORKFLOW.md — the process

The operational contract that the implement skill executes against:

- Exact commands: setup, build, run, test, lint/typecheck
- Workflow conventions: branching, commit style, definition of done
- Which project-level skills exist (test, code-review, docs-update) and when they run

## Writing rules

- All three documents live at the repository root — nowhere else.
- Write for a competent engineer who is new to this project.
- Keep each document focused; link out to dedicated docs rather than inlining detail.
- Don't duplicate what git history records (no "last updated" stamps).

## After writing

Report what changed in each document, briefly. INDEX.md (the document catalog) is owned by the project-level docs-update skill — do not create it here.
