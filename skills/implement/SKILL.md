---
name: implement
description: "Implement a piece of work described by a spec, ticket, or the conversation — orienting on the project docs, choosing appropriate workflow and mature skills, and landing everything in one commit. Use when the user asks to implement, build, or fix something substantial."
---

# Implement

## Overview

Implement a piece of work by reading project context, then choosing the appropriate workflow and skills based on the task nature and available mature skills. The goal is one commit containing code, tests, review fixes, and doc updates — but the path to get there is flexible.

## When to use

- When the user asks to implement, build, or fix something substantial
- When a spec, ticket, or conversation describes work to be done
- For any feature or fix that needs tests, review, and documentation

## Steps

1. **Orient on project context**: 
   - Locate and read WORKFLOW.md, ARCHITECTURE.md, SPEC.md with Glob searches (`**/WORKFLOW.md`, etc.) — they default to the repository root but may have been moved
   - Check for project guidance documents in `.claude/project-guide/` or `.agents/project-guide/` (created by generate-project-skills) — these contain project-specific test commands, standards sources, and documentation locations
   - If the task changes how the project gets built, tested, or developed, update WORKFLOW.md first

2. **Choose appropriate workflow**: Based on the task nature, project context, and available skills, select the workflow. Examples:
   
   **For TDD-suitable features:**
   - Check if `ecc:tdd` or similar mature TDD skill is available → use it
   - Otherwise: implement test-first at pre-agreed seams (red → green cycles, vertical slices)
   - Run tests frequently; collect results for review
   
   **For bug fixes:**
   - Write reproduction test first
   - Fix the code
   - Run full suite
   
   **For refactoring:**
   - Ensure tests exist and pass
   - Make changes
   - Verify tests still pass
   
   **For documentation-only changes:**
   - Update affected documents
   - No test/review cycle needed

3. **Run tests**: Execute the project's test suite using:
   - Test command from WORKFLOW.md or project guidance
   - Mature test skill if available (e.g., `ecc:test-runner`)
   - Collect results for the review step

4. **Review changes**: Check the implementation against standards and spec:
   - Use `ecc:code-review` or similar mature review skill if available
   - Otherwise: self-review against ARCHITECTURE.md, SPEC.md, and WORKFLOW.md conventions
   - Provide test results as input to the review
   - Fix any issues found; re-run tests if code changed

5. **Update documentation**: Discover and update affected documents:
   - Use `ecc:docs-sync` or similar if available
   - Otherwise: Glob/Grep to find affected docs (ARCHITECTURE.md, SPEC.md, WORKFLOW.md, README, API docs)
   - Update each where it lives (don't create root duplicates)
   - HANDOFF.md is owned by /handoff — don't edit it

6. **Commit everything**: Create a single commit on the current branch with:
   - Code changes
   - Tests (new or updated)
   - Review fixes
   - Doc updates
   - Follow commit conventions from WORKFLOW.md

## Report

State what was implemented, which workflow/skills were used, and confirm the commit was created with all outputs included.

<!-- activation-guide start -->
## Activating other skills

When choosing skills to use:

- Prefer mature, battle-tested skills when available (e.g., `ecc:tdd`, `ecc:code-review`)
- If your harness provides a Skill tool, invoke skills with it
- Otherwise, read skill's SKILL.md and follow it directly
- Bundled skills live in sibling directories: `../<skill-name>/SKILL.md`
- Where your harness supports subagents (e.g. an Agent tool), run complex skills as subagents to keep context clean
<!-- activation-guide end -->
