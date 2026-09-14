# hello-my-skills — Claude Code Plugin

This is the Claude Code plugin variant of hello-my-skills, optimized for the Claude Code harness with platform-specific features.

## Installation

### From GitHub (recommended)

```bash
claude plugin marketplace add dkj121/hello-my-skills
claude plugin install hello-my-skills@hello-my-skills
```

### Local development

```bash
claude --plugin-dir /path/to/hello-my-skills/claude-code-plugin
```

## Skills Included

- **`/grill`** — Stress-test plans and designs through structured questioning with frontier-based rounds
- **`/to-docs`** — Turn shared understanding into ARCHITECTURE.md, SPEC.md, and WORKFLOW.md
- **`/implement`** — Personal workflow router with optional workflow arguments (`tdd`, `direct`, `review`)
- **`/handoff`** — Compress conversation into handoff file for session transitions
- **`/generate-project-skills`** — Generate project-specific guidance skills (test, code-review, core-docs-update)

## Claude Code-Specific Features

### Argument Hints

The `/implement` skill includes `argument-hint` frontmatter to guide users:
- `/implement tdd focus on auth endpoints`
- `/implement direct simple config fix`
- `/implement review security-sensitive changes`

### Tool Permissions

Skills declare `allowed-tools` in frontmatter to match Claude Code's permission system.

### Activation Control

Skills use `disable-model-invocation` where appropriate to prevent unwanted auto-activation.

## Differences from Generic Variant

1. **Frontmatter extensions**: Claude Code-specific metadata (`allowed-tools`, `argument-hint`, `disable-model-invocation`)
2. **Skill invocation syntax**: Uses `Skill` tool for cross-skill activation
3. **Optimized for harness**: Takes advantage of Claude Code's structured question tools, permission gates, and agent system

## Development

This directory is generated from `skills/` by `scripts/sync.sh`. Do not edit files here directly — edit the canonical source in `skills/` and regenerate:

```bash
cd /path/to/hello-my-skills
./scripts/sync.sh
```

## Documentation

See main [README.md](../README.md) for full documentation, design philosophy, and usage patterns.
