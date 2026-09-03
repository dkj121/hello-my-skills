#!/usr/bin/env bash
#
# sync.sh — regenerate the distributable variants from the canonical skill
# sources in skills/.
#
#   skills/                          canonical sources (hand-edited; also the
#                                    generic variant — install as-is)
#   claude-code-plugin/              Claude Code plugin         (generated)
#   codex-plugin/                    Codex / ChatGPT plugin     (generated)
#   .claude-plugin/marketplace.json  root Claude marketplace    (generated)
#
# What differs per variant:
#   - Frontmatter: the Claude variant gains allowed-tools /
#     disable-model-invocation / argument-hint; the Codex variant keeps
#     name+description and gains agents/openai.yaml (invocation policy).
#   - Wording: the "Activating other skills" block inside the canonical
#     bodies (between <!-- activation-guide start/end --> markers) is swapped
#     for variant-specific instructions (Skill tool vs. read-and-follow).
#
# Usage:
#   scripts/sync.sh           regenerate in place (idempotent)
#   scripts/sync.sh --check   diff generated output against what is on disk
#                             (non-zero exit + diff if out of date)
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/skills"

PLUGIN_NAME="hello-my-skills"
PLUGIN_VERSION="0.1.0"
PLUGIN_DESCRIPTION="Self-updating docs-and-workflow skill suite: grill, to-docs, implement, handoff, generate-project-skills"
AUTHOR_NAME="dkj121"

# Skills shipped in the plugins (order = listing order).
SHIPPED_SKILLS=(grill to-docs implement handoff generate-project-skills)

CHECK=0
if [[ "${1:-}" == "--check" ]]; then CHECK=1; shift; fi
if [[ $# -ne 0 ]]; then echo "usage: scripts/sync.sh [--check]" >&2; exit 2; fi

# Scratch space (guide texts, frontmatter fragments) — always cleaned up.
WORK="$(mktemp -d)"
CLEANUP=("$WORK")

# Output root: the real repo, or a throwaway copy for --check. Only ever add
# the check-mode temp dir to CLEANUP — never the repo itself.
OUT="$REPO_ROOT"
if (( CHECK )); then
  OUT="$(mktemp -d)"
  CLEANUP+=("$OUT")
fi
trap 'rm -rf "${CLEANUP[@]}"' EXIT

CLAUDE_DIR="$OUT/claude-code-plugin"
CODEX_DIR="$OUT/codex-plugin"
MARKETPLACE_DIR="$OUT/.claude-plugin"

# ---------------------------------------------------------------------------
# Variant-specific "Activating other skills" guides (replace the marker block)
# ---------------------------------------------------------------------------

cat > "$WORK/guide-claude.md" <<'EOF'
## Activating other skills

When this skill says to activate another skill, invoke the Skill tool:

- Project-level skills (`test`, `code-review`, `docs-update`): invoke with the plain name, e.g. `test`.
- Bundled skills from this plugin: invoke with the plain name (e.g. `to-docs`); if the name is ambiguous, use the plugin-qualified form `hello-my-skills:<skill-name>`.
EOF

cat > "$WORK/guide-codex.md" <<'EOF'
## Activating other skills

When this skill says to activate another skill:

- Project-level skills (`test`, `code-review`, `docs-update`): read and follow `.agents/skills/<skill-name>/SKILL.md` in the project (mirrored at `.claude/skills/<skill-name>/SKILL.md`). If it is missing, ask the user to run `$<skill-name>`.
- Bundled skills: read and follow `../<skill-name>/SKILL.md` (a sibling of this skill's directory), or ask the user to run `$<skill-name>`.
EOF

# ---------------------------------------------------------------------------
# Per-skill metadata (Claude frontmatter extras, Codex openai.yaml)
# ---------------------------------------------------------------------------

claude_tools() {
  case "$1" in
    grill)                   echo "Read, Bash, Glob, Grep, AskUserQuestion" ;;
    to-docs)                 echo "Read, Bash, Glob, Grep, Edit, Write" ;;
    implement)               echo "Read, Bash, Glob, Grep, Edit, Write, Agent" ;;
    handoff)                 echo "Read, Bash, Glob, Grep, Edit, Write" ;;
    generate-project-skills) echo "Read, Bash, Glob, Grep, Edit, Write" ;;
    *) echo "unknown skill: $1" >&2; return 1 ;;
  esac
}

# Skills the model may NOT auto-activate (user-invoked only).
claude_dmi() {
  case "$1" in
    to-docs) return 1 ;;
    *)       return 0 ;;
  esac
}

codex_yaml() {
  local display short implicit
  case "$1" in
    grill)
      display="Grill"
      short="Stress-test a plan or decision through structured rounds of questions."
      implicit="false" ;;
    to-docs)
      display="To Docs"
      short="Write the conversation's shared understanding into ARCHITECTURE, SPEC and WORKFLOW."
      implicit="true" ;;
    implement)
      display="Implement"
      short="Implement a task end-to-end: code, tests, review, docs, one commit."
      implicit="false" ;;
    handoff)
      display="Handoff"
      short="Compact the session into HANDOFF.md for the next agent."
      implicit="false" ;;
    generate-project-skills)
      display="Generate Project Skills"
      short="Generate project-level test, code-review and docs-update skills for this repo."
      implicit="false" ;;
    *) echo "unknown skill: $1" >&2; return 1 ;;
  esac
  cat <<EOF
interface:
  display_name: "$display"
  short_description: "$short"
policy:
  allow_implicit_invocation: $implicit
EOF
}

# ---------------------------------------------------------------------------
# render_skill <src> <dst> <guide-file|-> <extra-frontmatter-file|->
#
# Copies a canonical SKILL.md, optionally injecting extra frontmatter fields
# before the closing --- and swapping the activation-guide marker block for
# the variant guide. Pass "-" to skip either.
# ---------------------------------------------------------------------------
render_skill() {
  local src_file="$1" dst_file="$2" guide_file="$3" extra_fm="$4"
  awk -v guide="$guide_file" -v extra="$extra_fm" '
    BEGIN { in_fm = 0; in_guide = 0 }
    NR == 1 && $0 == "---" { print; in_fm = 1; next }
    in_fm == 1 && $0 == "---" {
      if (extra != "-") {
        while ((getline line < extra) > 0) if (length(line) > 0) print line
        close(extra)
      }
      print; in_fm = 0; next
    }
    in_fm == 1 { print; next }
    $0 == "<!-- activation-guide start -->" {
      print
      if (guide != "-") {
        while ((getline line < guide) > 0) print line
        close(guide)
      }
      in_guide = 1; next
    }
    in_guide == 1 && $0 == "<!-- activation-guide end -->" { in_guide = 0; print; next }
    in_guide == 1 { next }
    { print }
  ' "$src_file" > "$dst_file"
}

# ---------------------------------------------------------------------------
# Generate
# ---------------------------------------------------------------------------

for skill in "${SHIPPED_SKILLS[@]}"; do
  src_file="$SRC/$skill/SKILL.md"
  if [[ ! -f "$src_file" ]]; then
    echo "error: missing canonical skill: $src_file" >&2
    exit 1
  fi

  # --- Claude Code variant ---------------------------------------------
  dst="$CLAUDE_DIR/skills/$skill"
  mkdir -p "$dst"
  {
    echo "allowed-tools: $(claude_tools "$skill")"
    if claude_dmi "$skill"; then echo "disable-model-invocation: true"; fi
    if [[ "$skill" == "handoff" ]]; then
      echo 'argument-hint: "What the next session will be used for"'
    fi
  } > "$WORK/fm-claude.txt"
  render_skill "$src_file" "$dst/SKILL.md" "$WORK/guide-claude.md" "$WORK/fm-claude.txt"

  # --- Codex / ChatGPT variant ------------------------------------------
  dst="$CODEX_DIR/skills/$skill"
  mkdir -p "$dst/agents"
  render_skill "$src_file" "$dst/SKILL.md" "$WORK/guide-codex.md" -
  codex_yaml "$skill" > "$dst/agents/openai.yaml"

  # --- Bundled assets (templates etc.) copied verbatim to both ----------
  for entry in "$SRC/$skill"/*; do
    [[ -e "$entry" ]] || continue
    base="$(basename "$entry")"
    [[ "$base" == "SKILL.md" ]] && continue
    cp -R "$entry" "$CLAUDE_DIR/skills/$skill/"
    cp -R "$entry" "$CODEX_DIR/skills/$skill/"
  done
done

# --- Manifests -----------------------------------------------------------

mkdir -p "$CLAUDE_DIR/.claude-plugin" "$CODEX_DIR/.codex-plugin" "$MARKETPLACE_DIR"

cat > "$CLAUDE_DIR/.claude-plugin/plugin.json" <<EOF
{
  "name": "$PLUGIN_NAME",
  "description": "$PLUGIN_DESCRIPTION",
  "version": "$PLUGIN_VERSION",
  "author": { "name": "$AUTHOR_NAME" }
}
EOF

cat > "$CODEX_DIR/.codex-plugin/plugin.json" <<EOF
{
  "name": "$PLUGIN_NAME",
  "version": "$PLUGIN_VERSION",
  "description": "$PLUGIN_DESCRIPTION",
  "skills": "./skills/"
}
EOF

cat > "$MARKETPLACE_DIR/marketplace.json" <<EOF
{
  "name": "$PLUGIN_NAME",
  "description": "$PLUGIN_DESCRIPTION",
  "owner": { "name": "$AUTHOR_NAME" },
  "plugins": [
    {
      "name": "$PLUGIN_NAME",
      "source": "./claude-code-plugin",
      "description": "$PLUGIN_DESCRIPTION",
      "version": "$PLUGIN_VERSION"
    }
  ]
}
EOF

# ---------------------------------------------------------------------------
# Report / check
# ---------------------------------------------------------------------------

if (( CHECK )); then
  status=0
  for target in claude-code-plugin codex-plugin .claude-plugin; do
    if ! diff -r -u "$REPO_ROOT/$target" "$OUT/$target" >/dev/null 2>&1; then
      echo "out of date: $target" >&2
      diff -r -u "$REPO_ROOT/$target" "$OUT/$target" >&2 || true
      status=1
    fi
  done
  if (( status )); then
    echo "generated variants differ from skills/ — run scripts/sync.sh" >&2
    exit 1
  fi
  echo "OK: generated variants match skills/"
else
  echo "Generated:"
  echo "  claude-code-plugin/  ($(find "$CLAUDE_DIR" -type f | wc -l) files)"
  echo "  codex-plugin/        ($(find "$CODEX_DIR" -type f | wc -l) files)"
  echo "  .claude-plugin/marketplace.json"
fi
