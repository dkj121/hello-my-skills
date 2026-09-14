# hello-my-skills — Codex Plugin

This is the Codex/ChatGPT plugin variant of hello-my-skills, optimized for the Codex harness with platform-specific features.

## Installation

### From GitHub (recommended)

```bash
codex plugin marketplace add dkj121/hello-my-skills
codex plugin add hello-my-skills@hello-my-skills
```

### Local development

```bash
codex plugin marketplace add /path/to/hello-my-skills
codex plugin add hello-my-skills@hello-my-skills
```

## Skills Included

- **`/grill`** — Stress-test plans and designs through structured questioning with frontier-based rounds
- **`/to-docs`** — Turn shared understanding into ARCHITECTURE.md, SPEC.md, and WORKFLOW.md
- **`/implement`** — Personal workflow router with optional workflow arguments (`tdd`, `direct`, `review`)
- **`/handoff`** — Compress conversation into handoff file for session transitions
- **`/generate-project-skills`** — Generate project-specific guidance skills (test, code-review, core-docs-update)

## Codex-Specific Features

### OpenAI Agent Configuration

Each skill includes `agents/openai.yaml` with:
- `policy.allow_implicit_invocation` — Controls whether AI can auto-activate the skill
- Tool permissions tailored to Codex's permission model
- Natural language argument handling

### Skill Invocation

Skills use Codex-native invocation patterns:
- Read skill definitions from `.agents/skills/`
- Execute skill instructions directly
- Use `$skill` variable syntax for skill references

### Natural Argument Format

The `/implement` skill accepts natural language arguments that Codex interprets flexibly:
- `/implement tdd focus on auth endpoints`
- `/implement direct simple config fix`
- `/implement review security-sensitive changes`

## Differences from Generic Variant

1. **Agent configuration**: Each skill has `agents/openai.yaml` for Codex-specific behavior
2. **Skill invocation syntax**: Uses Codex-native skill execution patterns
3. **Policy control**: `allow_implicit_invocation` controls auto-activation per skill
4. **Optimized for harness**: Takes advantage of Codex's natural language processing and agent system

## Development

This directory is generated from `skills/` by `scripts/sync.sh`. Do not edit files here directly — edit the canonical source in `skills/` and regenerate:

```bash
cd /path/to/hello-my-skills
./scripts/sync.sh
```

## Documentation

See main [README.md](../README.md) for full documentation, design philosophy, and usage patterns.
