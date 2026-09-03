---
name: test
description: "Create, maintain, and run this project's tests for the current task — test-first where possible — and report results to the caller. Use when a task needs tests written or updated, or when the test suite needs to run."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write, Agent
---

# Test

Own this project's tests for the current task: write them test-first where possible, run the suite, and report the results.

## Self-maintenance — run this first

This skill is a living artifact of this codebase. Before starting:

1. Verify the facts below still hold (check the manifest/config they came from).
2. If the codebase has drifted — test command changed, framework swapped, tests moved — update this SKILL.md first (both copies: `.claude/skills/test/` and `.agents/skills/test/`), then proceed against the new reality.

## Project facts

- Test framework: {{TEST_FRAMEWORK}}
- Run all tests: {{TEST_COMMAND}}
- Run one file: {{SINGLE_TEST_COMMAND}}
- Tests live in: {{TEST_LOCATIONS}}
- Typecheck/lint: {{TYPECHECK_COMMAND}}

## Workflow

1. **Orient.** Read WORKFLOW.md and ARCHITECTURE.md at the repo root if present. Use the project's domain vocabulary when naming tests and interfaces.
2. **Agree the seam.** A seam is the public boundary where behavior is observed without reaching into internals. Before writing tests, state the seam(s) under test. No test at an unconfirmed seam — if the shape of the interface itself is uncertain, settle that first (with the user if needed).
3. **Red → green.** Write one failing test, then the minimal code that makes it pass. Repeat in vertical slices: one test → one implementation → the next test. Each test is a tracer bullet; let each cycle shape the next.
4. **Reuse the existing setup.** If the project already has tests or a test entry script, extend them — don't build a parallel structure. If a root-level entry script is genuinely needed and none exists, create `scripts/test` wrapping {{TEST_COMMAND}}.
5. **Run and report.** Run the suite and wait for it to finish. Report: what ran, pass/fail counts, each failure verbatim with `file:line`, and your diagnosis.

## Anti-patterns — banned

- **Implementation-coupled tests**: mocking internals, testing private methods, asserting through side channels. The tell: a test breaks on a refactor that changed no behavior.
- **Tautological tests**: assertions that recompute the expected value the same way the code does. Expected values come from an independent source — a known-good literal, a worked example, or the spec.
- **Horizontal slicing**: writing all tests before any implementation. That tests imagined behavior; vertical slices test real behavior.

## Returning results

If activated by another skill (e.g. implement), return the full report to the caller — they relay it onward (e.g. into code review). If running standalone, report to the user.
