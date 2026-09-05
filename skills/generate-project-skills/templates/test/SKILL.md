---
name: test
description: "AI-readable guidance for testing in this project. Contains project-specific test commands, framework, and conventions. AI reads this for context when implementing test workflows, not as a user-invocable skill."
allowed-tools: Read, Bash, Glob, Grep
---

# Test — Project Guidance

**Note**: This is AI-readable guidance, not a user-invocable workflow. When implementing tests, AI reads this to understand project conventions, then chooses appropriate mature skills (like `ecc:tdd`) or implements test workflows directly.

## Project facts

- Test framework: {{TEST_FRAMEWORK}}
- Run all tests: {{TEST_COMMAND}}
- Run one file: {{SINGLE_TEST_COMMAND}}
- Tests live in: {{TEST_LOCATIONS}}
- Typecheck/lint: {{TYPECHECK_COMMAND}}

## Testing approach

1. **Prefer TDD when appropriate**: For new features, write tests first using red → green cycles with vertical slicing (one test → minimal implementation → next test).

2. **Agree on seams first**: A seam is the public boundary where behavior is observed. Before writing tests, confirm the seam with the user if unclear. Test at seams, not internals.

3. **Reuse existing test infrastructure**: Extend existing test files and patterns rather than creating parallel structures.

4. **Anti-patterns to avoid**:
   - Implementation-coupled tests (mocking internals, testing private methods)
   - Tautological tests (recomputing expected values the same way code does)
   - Horizontal slicing (writing all tests before any implementation)

## Workflow guidance

When AI needs to implement testing for this project:

1. Check if mature test skills are available (`ecc:tdd`, `ecc:test-runner`, etc.) — use them if present
2. Otherwise, follow the TDD approach above using the project's test commands
3. Run tests using {{TEST_COMMAND}} and collect results
4. Report: what ran, pass/fail counts, failures with `file:line`, diagnosis

## Keeping this guidance current

If project test setup changes (framework, commands, test locations), regenerate this guidance with `/generate-project-skills`.
