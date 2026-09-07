---
name: handoff
description: "Compact the current conversation into a structured handoff file with a descriptive name and save it to the OS temporary directory so another agent or future session can pick the work up. Use when the user asks for a handoff, wants to continue work in a new session, or wants a compact summary of where the work stands."
---

# Handoff

## Overview

Compact the conversation into a structured handoff document and save it to the OS temporary directory, outside the current workspace. Uses a 4-part template with YAML frontmatter. Filename is descriptive rather than timestamped.

## When to use

- When the user asks for a handoff
- When the user wants to continue work in a new session
- End of a work session to preserve context
- When a compact summary of current state is needed

## Steps

1. **Gather from conversation**: Read the conversation and extract:
   - The goal (what this work is ultimately for)
   - What was decided (key decisions with rationales)
   - What was done (files created/changed, commands run, outcomes)
   - What is in progress
   - What is blocked or uncertain
   - Things AI generated that may need human review or fixing

2. **Find project documents**: Use Glob searches for ARCHITECTURE.md, SPEC.md, WORKFLOW.md (`**/ARCHITECTURE.md`, etc.) in the current workspace. The handoff states where each document stands — it does not duplicate their content.

3. **Inspect working tree**: Check uncommitted changes, TODO markers, and branch state for facts the conversation may not have mentioned.

4. **Generate handoff filename**: Create a descriptive filename:
   - If user provides description, use it: `handoff-{user-description}.md`
   - Otherwise, generate 2-4 word description from the work: `handoff-{generated-description}.md`
   - Example: `handoff-skill-restructuring.md`, `handoff-api-auth-impl.md`
   - Lowercase with hyphens, no spaces

5. **Write handoff to OS temp directory**: Determine the OS temporary directory and write the handoff there:
   - Linux/macOS: `/tmp/` or `$TMPDIR`
   - Windows: `%TEMP%` or `C:\Users\<username>\AppData\Local\Temp\`
   - Use system API or environment variables to get the correct path
   
   Use this 4-part template:
   
   ```markdown
   ---
   filename: handoff-{description}.md
   timestamp: YYYY-MM-DD HH:MM:SS
   workspace: /absolute/path/to/workspace
   ---
   
   # Overview
   
   {Concise summary: what this work is for, where it stands now, what's next}
   
   ## One Core Rule
   
   **Before proceeding, clarify these with the user:**
   
   - {Critical decision or assumption that needs explicit confirmation}
   - {Ambiguity in requirements that could lead to wasted work}
   - {Risk or tradeoff the user should consciously choose}
   
   *Grill the user on these points before starting work. Don't assume.*
   
   ## Details
   
   ### Goal
   {What this work is ultimately for}
   
   ### Where we are
   - **Done**: {completed items}
   - **In progress**: {current work}
   - **Blocked**: {blockers or uncertainties}
   
   ### Key decisions
   - {Decision with one-line rationale}
   
   ### Next steps
   1. {Concrete, ordered, immediately executable steps}
   
   ### Suggested approach
   {What workflow or capability would be valuable next}
   
   ### Pitfalls
   - {Things that tripped this session}
   
   ## Things to Fix
   
   **AI-generated content that needs human review:**
   
   - [ ] {File or decision that may need adjustment}
   - [ ] {Assumption made that should be validated}
   - [ ] {Code or config generated that needs testing}
   - [ ] {Documentation that may need refinement}
   
   *Review these before considering the work complete.*
   ```

6. **Follow handoff rules**:
   - Each handoff is a new file with descriptive name
   - Redact sensitive values (tokens, credentials, personal data) — describe them, never copy them
   - Don't duplicate content that lives in project documents; link to it with absolute paths
   - Use full file paths and exact commands; include error messages verbatim
   - Checkbox items in "Things to Fix" should be actionable and specific

## Report

State:
- Full path where the handoff was written
- Filename with description
- One-sentence summary of the current state
- Reminder that the file is in the OS temp directory, not the workspace
- Key items from "One Core Rule" that the next session should clarify
- Number of items in "Things to Fix" checklist
