---
name: grill
description: "Stress-test a plan, decision, or idea by interviewing the user in structured rounds before any work starts. Use when the user wants to be grilled or quizzed about a plan or design, before writing a spec, or when they say things like 'grill me', 'stress-test this', or 'poke holes in this plan'."
allowed-tools: Read, Bash, Glob, Grep, AskUserQuestion
disable-model-invocation: true
---

# Grill

## Overview

Stress-test plans, decisions, or ideas through structured interviewing before work begins. Maps the topic as a design tree and walks it systematically, surfacing undecided branches through frontier-based questioning. Push back where thinking is thin; concede quickly where it is solid. Adapts depth to decision complexity.

## When to use

- Before writing specs or starting major work
- When the user says "grill me", "stress-test this", or "poke holes in this plan"
- When a plan or design needs validation before implementation
- Before making irreversible architectural decisions

## Roles

- **User**: Decision maker who answers questions and owns the final choices
- **Agent**: Interviewer who maps the design tree, verifies facts, identifies frontier questions, and recommends answers

## Steps

### 1. Assess scope

Before starting the full design tree, understand the decision's scope:

- **Trivial decision** (tool choice, naming, local pattern): 2-3 questions, quick validation
- **Feature decision** (how to implement, which approach): 5-10 questions, one or two rounds
- **Architecture decision** (cross-cutting, foundational): Full design tree, multiple rounds
- **Strategic decision** (product direction, major refactor): Deep tree, thorough exploration

Match the grilling depth to the decision's weight and reversibility. Don't apply architecture-grade scrutiny to a local naming decision.

### 2. Map the design tree

Represent the topic as a tree of decisions where each decision branches into the decisions that depend on it. Walk this tree root decisions first.

For small scope: A shallow tree with 2-3 levels may suffice.
For large scope: Map the full tree systematically.

### 3. Distinguish facts from decisions

- **Facts** (what a file contains, what a command returns, which dependency is in use) are the agent's job — look them up via Read, Bash, Grep, Glob. Never ask the user something you can verify yourself.
- **Decisions** (things genuinely the user's call) go to the user with a recommendation attached.

### 4. Identify the frontier

The frontier is the set of questions whose prerequisites are already settled — questions you can ask without guessing at answers to anything else.

### 5. Ask frontier questions in rounds

- Decide how many questions the round contains: ask the whole frontier when questions are independent; hold back ones that depend on answers still outstanding. No fixed cap.
- Number questions continuously across the session. Each gets a bold title, the question itself, and a recommended answer:
  > 1. ❓ **Persistence layer** — should this project use SQLite or plain JSON files on disk?  
  >    ➡️ Recommended: SQLite — the query patterns in the plan need filtering, and stdlib support is good enough.
- If the user delegates a question back to you, decide it, record the decision with one line of rationale, and move on.

### 6. Choose the medium and handle tool limits

**Prefer a structured question tool** (e.g. AskUserQuestion) when your harness provides one: it renders options and captures answers cleanly.

**Handle tool call limits:** If a round has more questions than a single call accepts (e.g., tool limit is 4 questions but round has 8):
- Split across consecutive calls in the same response
- Keep question numbering continuous (questions 1-4 in first call, 5-8 in second call)
- Each call is one frontier round — wait for all answers before proceeding

**Example with 8 frontier questions:**
```
First AskUserQuestion call: questions 1-4
Second AskUserQuestion call: questions 5-8
[Both in same response, then wait for user]
```

**Without a structured tool:** List the round's questions in the conversation using the format:
> N. ❓ **Title** — question text?  
>    ➡️ Recommended: answer with rationale

### 7. Wait for answers

Send every frontier question in the round, then stop and wait. Do not answer for the user, and do not proceed on assumptions.

**Allow early exit:** If the user signals they've explored enough ("that's sufficient", "let's stop here", "I'm ready to proceed"), respect it. Not every grilling needs to exhaust the entire tree.

### 8. Repeat rounds

Continue until the frontier is empty — every branch of the design tree is settled — or until the user signals sufficient exploration.

### 9. Summarize and confirm

Summarize the shared understanding as a short outline (decisions + one-line rationale each). Ask the user to confirm it. Do not act on the plan until they do.

### 10. Offer next steps

Once confirmed, suggest appropriate next actions based on what was decided:

- **If the understanding should be documented:** Suggest capturing it in project documents (e.g., with to-docs skill)
- **If ready to implement:** Suggest moving to implementation
- **If more exploration needed:** Suggest what to explore next
- **If external input needed:** Note what's needed and from whom

**Do not automatically activate another skill.** Present options and let the user choose the path forward.

## Report

After user confirmation, provide:

- **Decision outline**: Each decision with one-line rationale
- **Shared understanding summary**: The agreed plan
- **Suggested next steps**: What the user might want to do next (documentation, implementation, further exploration)

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill, invoke the Skill tool:

- Project-level skills (`test`, `code-review`, `docs-update`): invoke with the plain name, e.g. `test`.
- Bundled skills from this plugin: invoke with the plain name (e.g. `to-docs`); if the name is ambiguous, use the plugin-qualified form `hello-my-skills:<skill-name>`.
<!-- activation-guide end -->
