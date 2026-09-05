---
name: grill
description: "Stress-test a plan, decision, or idea by interviewing the user in structured rounds before any work starts. Use when the user wants to be grilled or quizzed about a plan or design, before writing a spec, or when they say things like 'grill me', 'stress-test this', or 'poke holes in this plan'."
allowed-tools: Read, Bash, Glob, Grep, AskUserQuestion
disable-model-invocation: true
---

# Grill

## Overview

Stress-test plans, decisions, or ideas through relentless structured interviewing before work begins. Maps the topic as a design tree and walks it systematically, surfacing every undecided branch through frontier-based questioning. Push back where thinking is thin; concede quickly where it is solid.

## When to use

- Before writing specs or starting major work
- When the user says "grill me", "stress-test this", or "poke holes in this plan"
- When a plan or design needs validation before implementation
- Before making irreversible architectural decisions

## Roles

- **User**: Decision maker who answers questions and owns the final choices
- **Agent**: Interviewer who maps the design tree, verifies facts, identifies frontier questions, and recommends answers

## Steps

1. **Map the design tree**: Represent the topic as a tree of decisions where each decision branches into the decisions that depend on it. Walk this tree root decisions first.

2. **Distinguish facts from decisions**:
   - **Facts** (what a file contains, what a command returns, which dependency is in use) are the agent's job — look them up via Read, Bash, Grep, Glob. Never ask the user something you can verify yourself.
   - **Decisions** (things genuinely the user's call) go to the user with a recommendation attached.

3. **Identify the frontier**: The frontier is the set of questions whose prerequisites are already settled — questions you can ask without guessing at answers to anything else.

4. **Ask frontier questions in rounds**:
   - Decide how many questions the round contains: ask the whole frontier when questions are independent; hold back ones that depend on answers still outstanding. No fixed cap.
   - Number questions continuously across the session. Each gets a bold title, the question itself, and a recommended answer:
     > 1. ❓ **Persistence layer** — should this project use SQLite or plain JSON files on disk?  
     >    ➡️ Recommended: SQLite — the query patterns in the plan need filtering, and stdlib support is good enough.
   - If the user delegates a question back to you, decide it, record the decision with one line of rationale, and move on.

5. **Choose the medium**:
   - Prefer a structured question tool (e.g. AskUserQuestion) when your harness provides one: it renders options and captures answers cleanly.
   - If a round has more questions than a single call accepts, split it across consecutive calls — keep numbering continuous.
   - Without such a tool, list the round's questions in the conversation in the format above.

6. **Wait for answers**: Send every frontier question in the round, then stop and wait. Do not answer for the user, and do not proceed on assumptions.

7. **Repeat rounds**: Continue until the frontier is empty — every branch of the design tree is settled.

8. **Summarize and confirm**: Summarize the shared understanding as a short outline (decisions + one-line rationale each). Ask the user to confirm it. Do not act on the plan until they do.

9. **Activate to-docs**: Once confirmed, activate the to-docs skill so the understanding is written into the project documents.

## Report

After user confirmation, provide:

- **Decision outline**: Each decision with one-line rationale
- **Shared understanding summary**: The agreed plan ready for documentation

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill, invoke the Skill tool:

- Project-level skills (`test`, `code-review`, `docs-update`): invoke with the plain name, e.g. `test`.
- Bundled skills from this plugin: invoke with the plain name (e.g. `to-docs`); if the name is ambiguous, use the plugin-qualified form `hello-my-skills:<skill-name>`.
<!-- activation-guide end -->
