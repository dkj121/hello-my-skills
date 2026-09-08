---
name: implement
description: "Personal engineering router that classifies work, assesses risk, and selects appropriate workflows. Delegates to mature capabilities when available, implements directly when needed. Use when the user asks to implement, build, or fix something."
---

# Implement

## Overview

A personal workflow router that understands the task, classifies its nature and risk, then selects the appropriate workflow and capabilities to complete it. Acts as a supervisor layer above project-specific workflows and mature skill libraries, not as a fixed execution chain.

## When to use

- When the user asks to implement, build, or fix something
- When a spec, ticket, or conversation describes work to be done
- As the entry point for substantial engineering work

## Steps

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

Based on classification, choose the narrowest workflow that provides sufficient confidence:

**For trivial/local changes:**
- Implement directly
- Focused verification
- Done

**For bug fixes:**
- Prefer reproducing the failure before changing behavior when practical
- Add regression test when failure can be expressed as stable automated test
- Choose verification scope based on risk

**For new features:**
- Check if mature TDD capability exists and is materially useful
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

### 4. Execute with appropriate capabilities

**Check for mature capabilities first:**
- Look for project-installed or environment-provided mature skills
- Examples: TDD guidance, test runners, review tools, security scanners, doc sync
- Prefer mature capabilities when they exist and materially improve the workflow

**If mature capabilities available:**
- Use them according to their guidance
- Example: A project may have mature TDD workflow — follow it
- Example: An environment may provide review capability — use it

**If implementing directly:**
- Follow the workflow selected in step 3
- Use project guidance (test commands, standards sources, doc locations) as context
- Apply appropriate engineering practices for the task type

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

**Check for mature review capability:**
- Project may have review workflow or standards
- Environment may provide review tools
- Use when available and appropriate

**Otherwise:** Self-review against ARCHITECTURE.md, SPEC.md, WORKFLOW.md conventions and smell baseline:
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
- Workflow selected and why
- Capabilities used (mature skills invoked or direct implementation)
- Validation performed
- Review outcome — **if errors found, clearly state "COMMIT BLOCKED: errors must be fixed first" and list them**
- Core documentation updated (if applicable)
- Commit status (completed, or blocked pending fixes)

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill:

- Project-level skills (`test`, `code-review`, `docs-update`): read and follow `.agents/skills/<skill-name>/SKILL.md` in the project (mirrored at `.claude/skills/<skill-name>/SKILL.md`). If it is missing, ask the user to run `$<skill-name>`.
- Bundled skills: read and follow `../<skill-name>/SKILL.md` (a sibling of this skill's directory), or ask the user to run `$<skill-name>`.
<!-- activation-guide end -->
