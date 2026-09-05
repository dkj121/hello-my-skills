---
name: code-review
description: "AI-readable guidance for code review in this project. Contains project-specific standards sources and review approach. AI reads this for context when implementing code review workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Code Review — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When reviewing code, AI reads this to understand project standards and conventions, then chooses appropriate mature review capabilities or implements review workflows directly based on task risk and complexity.

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

## When to perform explicit review

Perform explicit review when any of these apply:

- Multiple modules changed
- Public API changes
- Architecture changes
- Security-sensitive code (auth, authorization, data access, crypto)
- Concurrency / persistence / migration changes
- High-risk business logic
- Task is large or difficult to reason about

For small, low-risk changes, self-check against standards and smell baseline may suffice.

## Review guidance

When AI needs to implement code review for this project:

**Check for mature review capabilities:** Look for environment-provided review tools or workflows. Use them when they exist and are appropriate for the change risk.

**Otherwise, implement review:**
1. Read the full diff once end-to-end before judging
2. Provide findings grouped by Standards and Spec
3. Each finding: `file:line`, what's wrong, why it matters (which rule/requirement), suggested fix
4. End with verdict: **approve** or **changes needed**

## Keeping this guidance current

If project standards change (new CONTRIBUTING.md, style guides), regenerate this guidance with `/generate-project-skills`.
