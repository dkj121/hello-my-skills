---
name: test
description: "AI-readable guidance for testing in this project. Contains project-specific test commands, framework, and conventions. AI reads this for context when implementing test workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Test — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When implementing tests, AI reads this to understand project conventions, then chooses appropriate mature capabilities or implements test workflows directly based on task risk and complexity.

## Generation metadata

**Generated at:** {{GENERATION_TIMESTAMP}}
**Facts used for staleness detection:**
- Test command: `{{TEST_COMMAND}}`
- Test framework: {{TEST_FRAMEWORK}}
- Test locations: {{TEST_LOCATIONS}}

**Staleness check:** Before using this guidance, verify:
1. Test command exists: `command -v {{TEST_COMMAND_BINARY}} >/dev/null 2>&1`
2. Test locations exist: Check paths above with Glob/Bash
3. If checks fail, this guidance is stale — prompt user to run `/generate-project-skills`

## Project facts

- Test framework: {{TEST_FRAMEWORK}}
- Run all tests: {{TEST_COMMAND}}
- Run one file: {{SINGLE_TEST_COMMAND}}
- Tests live in: {{TEST_LOCATIONS}}
- Typecheck/lint: {{TYPECHECK_COMMAND}}

## Testing approach

**Prefer TDD when appropriate and practical:**
- For new features where behavior is well-understood: write tests first using red → green cycles with vertical slicing
- For bug fixes: prefer reproducing the failure as a test when practical
- For refactoring: ensure tests exist and pass before changes

**Agree on seams first:** A seam is the public boundary where behavior is observed. Before writing tests, confirm the seam if unclear. Test at seams, not internals.

**Reuse existing test infrastructure:** Extend existing test files and patterns rather than creating parallel structures.

**Anti-patterns to avoid:**
- Implementation-coupled tests (mocking internals, testing private methods)
- Tautological tests (recomputing expected values the same way code does)
- Horizontal slicing (writing all tests before any implementation)

## Proportionality

Match test effort to risk and complexity:

- **Trivial changes** (typo, config): Verify behavior, may not need new tests
- **Small changes** (add parameter, simple logic): Focused unit tests
- **Feature additions**: Test-first when practical, cover key behaviors
- **Architecture changes**: Broader test coverage, integration tests

## Validation guidance

When AI needs to validate work in this project:

**Run sufficient validation for the risk level:**
1. Focused checks for changed area: `{{SINGLE_TEST_COMMAND}}`
2. Relevant unit/integration tests when risk warrants
3. Full suite when appropriate: `{{TEST_COMMAND}}`

**Do not** run full 2-hour CI for a typo fix. Match validation to risk.

**Check for mature test capabilities:** Look for environment-provided test runners or TDD workflows. Use them when they exist and materially improve the workflow.

## Keeping this guidance current

If project test setup changes (framework, commands, test locations), regenerate this guidance with `/generate-project-skills`.
