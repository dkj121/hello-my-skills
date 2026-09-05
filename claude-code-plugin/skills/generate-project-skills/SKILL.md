---
name: generate-project-skills
description: "Generate AI-readable project guidance skills (test, code-review, docs-update) tailored to this codebase, and install them into .claude/skills/ and .agents/skills/. These provide context for AI to choose appropriate workflows, not hardcoded execution chains."
allowed-tools: Read, Bash, Glob, Grep, Edit, Write
disable-model-invocation: true
---

# Generate Project Skills

## Overview

Generate three AI-readable guidance skills for the current project — test, code-review, docs-update — tailored to this codebase. These skills capture project-specific facts (test commands, standards sources, doc locations) that AI reads when choosing appropriate workflows. They are **guidance documents for AI context**, not user-invocable workflows or hardcoded execution chains.

## When to use

- Setting up workflow guidance in a project for the first time
- When project conventions change (new test framework, moved documents, updated standards)
- When AI needs project-specific context to work effectively

## Steps

1. **Study the project**: Build a fact sheet:
   - Tech stack: languages, frameworks, key dependencies (manifests, lockfiles, configs)
   - Test setup: framework, test command(s), single-file test command, where tests live
   - Build / lint / typecheck / format commands
   - Documents: which of ARCHITECTURE.md / SPEC.md / WORKFLOW.md / HANDOFF.md exist and where (Glob for them); other docs (README, docs/, ADRs, CONTRIBUTING)
   - Standards sources: style guides, CONTRIBUTING.md, convention documents
   - Repo layout: main modules and their roles

2. **Read the templates**: Read bundled guidance templates:
   - `templates/test/SKILL.md`
   - `templates/code-review/SKILL.md`
   - `templates/docs-update/SKILL.md`

3. **Fill the templates**: Replace all `{{PLACEHOLDER}}` markers with facts from step 1:
   - Never leave placeholders behind
   - If project has no answer (e.g. no test framework), write the convention project should adopt and flag in report
   - These filled skills are **AI-readable guidance**, not executable workflows

4. **Set guidance frontmatter**: Ensure each generated skill has:
   ```yaml
   description: "AI-readable guidance for [domain] in this project..."
   allowed-tools: Read, Bash, Glob, Grep
   ```
   
   This signals:
   - AI can read them for context (not user-invocable)
   - Read-only tools (verify facts, don't execute workflows)
   - Guidance documents, not workflow executors

5. **Install to both locations**: Write each skill to both:
   - `.claude/skills/<name>/SKILL.md`
   - `.agents/skills/<name>/SKILL.md`
   
   If skill exists, read it first: preserve customizations, then regenerate. Keep locations in sync.

## Report

Provide:
- List of generated guidance skills with installation paths
- Key project facts embedded (test framework, commands, standards sources, doc locations)
- Gaps or assumptions requiring project decision
- Reminder: **These are AI-readable guidance documents**. AI uses them as context when choosing mature capabilities (like ECC skills) or implementing workflows directly. They do not prescribe hardcoded workflow chains.
