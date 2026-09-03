---
name: generate-project-skills
description: "Generate the three project-level skills (test, code-review, docs-update) for the current project, tailored to its codebase, and install them into .claude/skills/ and .agents/skills/. Use when setting up this workflow in a project for the first time or regenerating the project skills after major changes."
---

# Generate Project Skills

Generate three project-level skills for the current project — test, code-review, docs-update — tailored to this codebase, and install them into the project at both `.claude/skills/` and `.agents/skills/` (identical content; Claude Code reads the former, Codex and other agents read the latter).

## 1. Study the project

Build a fact sheet before writing anything:

- Tech stack: languages, frameworks, key dependencies (manifests, lockfiles, configs)
- Test setup: framework, test command(s), single-file test command, where tests live
- Build / lint / typecheck / format commands
- Documents: which of ARCHITECTURE.md / SPEC.md / WORKFLOW.md / HANDOFF.md exist and where (Glob for them — the user may have moved them off the root); other docs (README, docs/, ADRs, CONTRIBUTING)
- Repo layout: the main modules and their roles

Read the templates bundled with this skill: `templates/test/SKILL.md`, `templates/code-review/SKILL.md`, `templates/docs-update/SKILL.md` (relative to this skill's directory).

## 2. Fill the templates

Each template contains `{{PLACEHOLDER}}` markers. Replace every placeholder with a fact from step 1 — never leave a placeholder behind, and never guess: if the project has no answer (e.g. no test framework), write the convention the project should adopt and flag it in your report.

Keep each template's **Self-maintenance** section intact — it is what keeps the generated skills aligned with the codebase over time.

## 3. Install

Write each filled skill to both locations:

- `.claude/skills/<name>/SKILL.md`
- `.agents/skills/<name>/SKILL.md`

If a skill already exists in either location, read it first: preserve project-specific customizations that are still accurate, then regenerate. Never leave the two locations out of sync.

## 4. Report

List the skills generated, the key project facts embedded in each, and anything left for the project to decide (e.g. "no test framework found — template assumes `node --test`").
