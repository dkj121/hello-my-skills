---
name: generate-project-skills
description: "Generate AI-readable project guidance skills (test, code-review, docs-update) tailored to this codebase, and install them into .claude/skills/ and .agents/skills/. These are context documents for AI, not user-invocable workflows. Use when setting up project guidance or when conventions change."
---

# Generate Project Skills

## Overview

Generate three AI-readable guidance skills for the current project — test, code-review, docs-update — tailored to this codebase. These skills provide project-specific context (test commands, standards sources, doc locations) that AI reads when choosing appropriate workflows. They are **not user-invocable** and **not hardcoded into workflows** — AI reads them as needed for context.

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

4. **Set frontmatter for AI-only access**: Ensure each generated skill has:
   - `allowed-tools: Read, Bash, Glob, Grep` (read-only, for AI to verify facts)
   - NO `disable-model-invocation` or similar — let AI read them freely
   - Description should indicate "AI guidance" purpose

5. **Install to both locations**: Write each skill to both:
   - `.claude/skills/<name>/SKILL.md`
   - `.agents/skills/<name>/SKILL.md`
   
   If skill exists, read it first: preserve customizations, then regenerate. Keep locations in sync.

## Report

Provide:
- List of generated guidance skills with installation paths
- Key project facts embedded (test framework, commands, standards sources, doc locations)
- Gaps or assumptions requiring project decision
- Reminder: These are AI-readable guidance, not user-invocable or hardcoded workflows
