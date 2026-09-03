---
name: implement
description: "Implement a piece of work described by a spec, ticket, or the conversation — orienting on the project docs, driving the work through test, code review, and doc updates, and landing everything in one commit. Use when the user asks to implement, build, or fix something substantial."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write, Agent
disable-model-invocation: true
---

# Implement

Implement a piece of work, then run the closing chain so that code, tests, review fixes, doc updates, and skill self-updates land together in a single commit.

## 1. Orient

1. Read WORKFLOW.md and ARCHITECTURE.md at the repo root (if present) — they are the execution contract.
2. Before writing any code, decide whether this task changes how the project gets built, tested, or developed. If it does, update WORKFLOW.md first, so the rest of the work runs against the new reality.
3. Read SPEC.md if the task references it, plus any tickets or files the user pointed at.

## 2. Implement

- Implement the work described by the user, the spec, or the tickets.
- Prefer test-driven development at pre-agreed seams: settle the seam (the public boundary where behavior is observed) before writing the test; one failing test, then the minimal code to pass it; repeat in vertical slices.
- Run typechecking frequently and single test files as you go. The full suite runs in the closing chain.

## 3. Closing chain

Run the project-level skills in this order. Activate each one and wait for its result before starting the next:

1. **test** — writes/updates and runs the project's tests. Collect its results.
2. **code-review** — reviews the changes, with the test results as input. Fix what it finds; if fixes touch code, re-run test.
3. **docs-update** — refreshes INDEX.md and the documents affected by the changes.

If the project-level skills are not installed (no `test`, `code-review`, or `docs-update` in `.agents/skills/` or `.claude/skills/`), offer to run generate-project-skills first. If the user declines, degrade gracefully: run the test command from WORKFLOW.md, self-review the diff against ARCHITECTURE.md and SPEC.md, and update the root documents yourself.

## 4. Commit

Commit everything — code, tests, review fixes, doc updates, and any skill self-updates from the chain — as a single commit on the current branch, following the commit conventions in WORKFLOW.md.

## Subagents

Where your harness supports subagents (e.g. an Agent tool), run each closing-chain skill as a subagent to keep context clean, and relay the test results into the code-review subagent yourself. Without subagent support, run each skill inline, in order — the result flow is identical.

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill, invoke the Skill tool:

- Project-level skills (`test`, `code-review`, `docs-update`): invoke with the plain name, e.g. `test`.
- Bundled skills from this plugin: invoke with the plain name (e.g. `to-docs`); if the name is ambiguous, use the plugin-qualified form `hello-my-skills:<skill-name>`.
<!-- activation-guide end -->
