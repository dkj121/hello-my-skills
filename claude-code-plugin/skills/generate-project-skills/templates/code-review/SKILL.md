---
name: code-review
description: "AI-readable guidance for code review in this project. Contains project-specific standards sources and review approach. AI reads this for context when implementing code review workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Code Review — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When reviewing code, AI reads this to understand project standards and conventions, then chooses appropriate mature skills (like `ecc:code-review`) or implements review workflows directly.

## Project facts

Recorded at generation time — re-verify paths with Glob search before relying on them:

- Standards sources: {{STANDARDS_SOURCES}} — plus WORKFLOW.md wherever it lives in this repo
- Spec source: SPEC.md (wherever it lives), the task/ticket text, or the conversation

## Review approach

Review changes along two axes:

**Standards axis** — Does the code follow the rules?
- Check against each standards source listed above
- Check against smell baseline below
- Pre-existing issues get one summary line, not a lecture

**Spec axis** — Does the code do what was asked?
- Check against spec source: every requirement met, nothing extra, no requirement silently dropped
- Test results are review input: failing suite is a Spec finding

## Smell baseline

Non-exhaustive — investigate when triggered:

- An abstraction introduced for a single caller
- Duplicated logic that could share a seam
- Dead code, commented-out code, leftover debug output
- Error handling that swallows errors or re-derives them
- Tests that mock what they claim to test; fixtures that hide the scenario
- Naming that misleads about intent
- Two levels of abstraction mixed in one function

## Workflow guidance

When AI needs to implement code review for this project:

1. Check if mature review skills are available (`ecc:code-review`, etc.) — use them if present
2. Otherwise, follow the two-axis approach above
3. Read the full diff once end-to-end before judging
4. Provide findings grouped by Standards and Spec
5. Each finding: `file:line`, what's wrong, why it matters (which rule/requirement), suggested fix
6. End with verdict: **approve** or **changes needed**

## Keeping this guidance current

If project standards change (new CONTRIBUTING.md, style guides), regenerate this guidance with `/generate-project-skills`.
