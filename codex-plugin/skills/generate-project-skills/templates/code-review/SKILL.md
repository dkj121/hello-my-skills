---
name: code-review
description: "Review the current changes along two axes — Standards (does the code follow this project's conventions) and Spec (does it do what was asked) — incorporating test results when provided. Use after implementing changes, before committing, or when the user asks for a review."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write, Agent
---

# Code Review

Review changes along two axes and report findings grouped by axis. You review — you don't fix (unless asked).

## Self-maintenance — run this first

This skill is a living artifact of this codebase. Before starting:

1. Verify the standards sources below still exist.
2. If the project adopted new convention documents (a CONTRIBUTING.md, a style guide), add them to this SKILL.md first (both copies: `.claude/skills/code-review/` and `.agents/skills/code-review/`), then review against the full set.

## Project facts

- Standards sources: {{STANDARDS_SOURCES}} — plus WORKFLOW.md at the repo root whenever it exists
- Spec source: SPEC.md at the repo root, the task/ticket text, or the conversation — identify which, and say so in the report

## Inputs

- **Test results**: if the caller passes test results (e.g. from the test skill), they are review input — a failing suite is a Spec-axis finding. If the caller says a test run is in flight, wait for its results before reviewing.
- **Scope**: the caller usually names the change set. Otherwise pin a fixed point yourself — the working tree against HEAD (uncommitted changes), or HEAD against its merge-base with the main branch — and state which in the report.

## The two axes

**Standards — does the code follow the rules?**
Check the diff against each standards source, plus the smell baseline below.

**Spec — does the code do what was asked?**
Review the change against the spec source: every requirement met, nothing extra smuggled in, no requirement silently dropped.

## Method

- Read the full diff once end-to-end before judging anything; then walk it file by file.
- Where your harness supports subagents, dispatch parallel reviewers (one per axis, or split by module) and aggregate their findings; otherwise review sequentially.
- Judge only what changed and what it touches. Pre-existing issues get one summary line — not a lecture.

## Smell baseline

Non-exhaustive — investigate when triggered:

- An abstraction introduced for a single caller
- Duplicated logic that could share a seam
- Dead code, commented-out code, leftover debug output
- Error handling that swallows errors or re-derives them
- Tests that mock what they claim to test; fixtures that hide the scenario
- Naming that misleads about intent
- Two levels of abstraction mixed in one function

## Output

Findings under two headings — **Standards** and **Spec**. Each finding: `file:line`, what is wrong, why it matters (which rule or requirement), and a suggested fix. End with a verdict: **approve** or **changes needed**.
