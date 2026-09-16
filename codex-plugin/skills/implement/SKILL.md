---
name: implement
description: "Personal engineering router that classifies work, assesses risk, and selects appropriate workflows. User specifies workflow via arguments when needed. Use when the user asks to implement, build, or fix something."
argument-hint: "[workflow (tdd, direct, review, refactor, exploratory, minimal, comprehensive or others)]|[details]"
allowed-tools: Read, Bash, Glob, Grep, Edit, Write, Agent
---

# Implement

## Overview

A personal workflow router that understands the task, classifies its nature and risk, then selects the appropriate workflow to complete it. User can optionally specify workflow preference via arguments.

## When to use

- When the user asks to implement, build, or fix something
- When a spec, ticket, or conversation describes work to be done
- As the entry point for substantial engineering work

## Arguments

**Format:** `/implement [workflow]|[detail]`

- **[workflow]** (optional): Single keyword suggesting workflow approach
- **[detail]** (optional): Free-form text providing task context

**Example workflows:**
- `tdd` — Test-driven development: write tests first, then implement
- `direct` — Direct implementation: implement then verify
- `review` — Include explicit code review step
- `refactor` — Behavior-preserving restructure
- Custom keywords — AI interprets based on context

**Examples:**
- `/implement tdd focus on auth endpoints`
- `/implement direct simple config fix`
- `/implement review security-sensitive changes`
- `/implement` (no args — AI chooses based on classification)

AI analyzes both workflow and detail to understand intent. Unknown workflows are interpreted flexibly.

## Workflow semantics

The workflow argument gives a high-level approach hint. The AI interprets these flexibly based on task context:

- **tdd / test-first**: Write tests before implementation. Red → Green → Refactor cycle.
- **direct / implement-first**: Implement first, then verify. Add tests after working code exists.
- **review**: Include an explicit code review step before committing.
- **refactor**: Behavior-preserving changes. Tests must pass before and after.
- **exploratory / spike**: Quick prototype to understand problem space. May not need full test coverage.
- **quick / minimal**: Lightest possible validation. For trivial changes only.
- **thorough / comprehensive**: Maximum validation and review. For high-risk changes.

Custom keywords are interpreted based on context. When in doubt, AI chooses based on task classification.

## Steps

### 0. Pre-flight validation

**Before starting, validate project guidance skills if they exist:**

Check for project skills in `.claude/skills/` or `.agents/skills/`. If found, verify basic facts:
- Test command exists and is executable
- Documented files (ARCHITECTURE.md, SPEC.md, WORKFLOW.md) exist at expected paths
- Key project facts from generation time are still valid

**On staleness detected:**
- Block and prompt: "Project skills are stale. Run /generate-project-skills to update?"
- Wait for user to regenerate or override
- Do not proceed with stale guidance

**Skip pre-flight if:**
- No project skills exist (`.claude/skills/` and `.agents/skills/` both missing)
- User explicitly bypassed validation

### 1. Orient on context

Locate and read project documents to understand the execution contract:
- WORKFLOW.md, ARCHITECTURE.md, SPEC.md (use Glob: `**/WORKFLOW.md`, etc.)
- Project guidance skills in `.claude/skills/` or `.agents/skills/` (if exist, read for context)
- Task description, tickets, or referenced files

### 2. Classify the work

Before choosing a workflow, determine:

**Change characteristics:**
- Size: trivial / small / medium / large
- Behavioral impact: none / local / module / system-wide
- Architectural impact: none / refactor / new pattern / architecture change
- Uncertainty: clear / some unknowns / exploratory
- Testability: easily testable / integration needed / hard to test
- Security sensitivity: routine / touches auth/data / security-critical
- Documentation impact: none / inline / core docs needed
- Reversibility: trivial rollback / needs migration / irreversible

**Task type** (may be multiple):
- Trivial/local change (typo, config, simple fix)
- Bug fix (regression / flaky test / production issue / dependency vuln)
- Behavioral change (modify existing feature)
- New feature (add capability)
- Refactor (same behavior, better structure)
- Architecture change (cross-cutting, foundational)
- Documentation-only
- Operational/configuration
- Security-sensitive

### 3. Select workflow

Consider user-provided workflow argument first. If provided, interpret it:
- `tdd` or `test-first` → Test-driven: write tests first, implement to pass
- `direct` or `implement-first` → Implementation-first: code then verify
- `review` → Include explicit review step
- `refactor` → Behavior-preserving changes, tests must pass before and after
- Other keywords → Interpret flexibly based on context

If no workflow specified, choose based on classification:

**For trivial/local changes:**
- Implement directly
- Focused verification
- Done

**For bug fixes:**
- Prefer reproducing the failure before changing behavior when practical
- Add regression test when failure can be expressed as stable automated test
- Choose verification scope based on risk

**For new features:**
- Prefer test-first when practical: agree seam → red → green cycles
- Otherwise: implement → verify → test coverage where needed

**For refactoring:**
- Ensure tests exist and pass before changes
- Make changes
- Verify tests still pass
- Add tests if coverage was insufficient

**For architecture changes:**
- Update WORKFLOW.md or ARCHITECTURE.md first if foundational contracts change
- Consider broader validation and review
- Document decisions

**For documentation-only:**
- Update affected documents
- No test/review cycle needed unless changing runbooks or critical procedures

**Proportionality principle:**
Do not introduce process overhead disproportionate to risk or complexity. Small, low-risk changes get focused verification. Larger or riskier changes progressively add: planning → tests → review → documentation → broader verification.

### 4. Execute the workflow

Follow the workflow selected in step 3. Use project guidance (test commands, standards sources, doc locations) from project skills as context when available.

**Apply appropriate engineering practices for the task type:**
- For TDD: Agree on seams → write failing tests → implement to pass → refactor
- For direct implementation: Code → verify → add tests where needed
- For refactoring: Verify tests pass → make changes → verify still pass
- For architecture changes: Update foundational docs first → implement → validate broadly

### 5. Validate

Run sufficient validation for the risk level:

**Prefer, in order:**
1. Focused checks for the changed area (fast feedback)
2. Relevant unit/integration tests (confidence in change)
3. Broader project tests when risk warrants (regression confidence)
4. Full suite before completion when appropriate (high-risk changes)

Use test commands from WORKFLOW.md or project guidance when available.

**Do not:** Run 2-hour CI for a typo fix. Match validation to risk.

### 6. Review

Perform explicit review when any of these apply:

- Multiple modules changed
- Public API changes
- Architecture changes
- Security-sensitive code (auth, authorization, data access, crypto)
- Concurrency / persistence / migration changes
- High-risk business logic
- Task is large or difficult to reason about
- User requested review (via workflow argument or task context)

**Review against:**
- ARCHITECTURE.md, SPEC.md, WORKFLOW.md conventions
- Project code-review guidance (if exists)
- Smell baseline:
  - Abstraction for single caller
  - Duplicated logic that could share a seam
  - Dead code, leftover debug output
  - Error swallowing
  - Misleading names
  - Mixed abstraction levels

Fix issues found. Re-run validation if code changed.

**If errors or mistakes found during review:**
- **STOP** — do not proceed to commit
- Report all findings clearly to the user with file:line references
- Explain what needs to be fixed
- Wait for user to fix the issues or explicitly approve proceeding despite errors
- Never commit code with known errors from review

### 7. Update core documentation (only when needed)

Update core documentation only when implementation changes foundational contracts:

**Check if core docs need updates:**
- **ARCHITECTURE.md** — Did module structure, data flow, or architectural patterns change?
- **SPEC.md** — Did goals, scope, or core requirements change?
- **WORKFLOW.md** — Did build/test/deploy commands or process change?

**If any core doc needs updating:** Check for mature core-docs-update capability or update directly:
- Glob for each doc: `**/ARCHITECTURE.md`, `**/SPEC.md`, `**/WORKFLOW.md`
- Update each where it lives — never create root duplicates
- Match existing tone and language

**Do not** update documentation merely to create activity. Most implementations don't need core doc updates.

### 8. Land the work

**Before committing:** Verify all review findings are addressed. If any errors remain:
- **STOP and remind user:** "Review found errors that must be fixed before committing"
- List the specific errors
- Wait for user to fix or explicitly approve
- Do not proceed with commit

Commit according to repository conventions found in WORKFLOW.md.

**Prefer a clean, coherent commit history.**

Create a single commit when the repository workflow or task context calls for it. For larger tasks, consider whether intermediate commits aid review, bisect, or understanding. Let project commit policy guide this decision, not a blanket rule.

## Report

State:
- Task classification (type, size, risk factors)
- Workflow selected (user-specified or AI-chosen) and why
- Implementation approach
- Validation performed
- Review outcome — **if errors found, clearly state "COMMIT BLOCKED: errors must be fixed first" and list them**
- Core documentation updated (if applicable)
- Commit status (completed, or blocked pending fixes)
- Commit status (completed, or blocked pending fixes)

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill:

- Project-level skills (`test`, `code-review`, `docs-update`): read and follow `.agents/skills/<skill-name>/SKILL.md` in the project (mirrored at `.claude/skills/<skill-name>/SKILL.md`). If it is missing, ask the user to run `$<skill-name>`.
- Bundled skills: read and follow `../<skill-name>/SKILL.md` (a sibling of this skill's directory), or ask the user to run `$<skill-name>`.
<!-- activation-guide end -->
