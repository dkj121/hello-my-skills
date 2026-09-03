---
name: grill
description: "Stress-test a plan, decision, or idea by interviewing the user in structured rounds before any work starts. Use when the user wants to be grilled or quizzed about a plan or design, before writing a spec, or when they say things like 'grill me', 'stress-test this', or 'poke holes in this plan'."
---

# Grill

Interview the user relentlessly to stress-test a plan, decision, or idea. Your job is to surface every undecided branch before work begins — not to be agreeable. Push back where the thinking is thin; concede quickly where it is solid.

## The design tree

Map the topic as a tree of decisions: every decision branches into the decisions that hang off it. Your interview walks this tree, root decisions first.

## Facts vs. decisions

- Facts — what a file contains, what a command returns, which dependency is in use — are **your** job. Look them up: read files, run commands, search the repo. Never ask the user something you can verify yourself.
- Decisions — things that are genuinely the user's call — go to the user, with a recommendation attached.

## Rounds and the frontier

Ask questions in rounds. The **frontier** is the set of questions whose prerequisites are already settled — questions you can ask without guessing at the answers to anything else.

- You decide how many questions a round contains: ask the whole frontier when the questions are independent; hold back the ones that depend on answers still outstanding. There is no fixed cap.
- Send every frontier question in the round, then stop and wait. Do not answer for the user, and do not proceed on assumptions.

## Question format

Number questions continuously across the session. Each gets a bold title, the question itself, and a recommended answer:

> 1. ❓ **Persistence layer** — should this project use SQLite or plain JSON files on disk?
>    ➡️ Recommended: SQLite — the query patterns in the plan need filtering, and stdlib support is good enough.

If the user delegates a question back to you, decide it, record the decision with one line of rationale, and move on.

## Choosing the medium

- Prefer a structured question tool (e.g. AskUserQuestion) when your harness provides one: it renders options and captures the answer cleanly. If a round has more questions than a single call accepts, split it across consecutive calls — keep the numbering continuous.
- Without such a tool, list the round's questions in the conversation in the format above and wait.

## Ending

The session ends when the frontier is empty — every branch of the design tree is settled. Then:

1. Summarize the shared understanding as a short outline (decisions + one-line rationale each).
2. Ask the user to confirm it. Do not act on the plan until they do.
3. Once confirmed, activate the to-docs skill so the understanding is written into the project documents.

<!-- activation-guide start -->
## Activating other skills

When this skill says to activate another skill:

- Project-level skills (`test`, `code-review`, `docs-update`): read and follow `.agents/skills/<skill-name>/SKILL.md` in the project (mirrored at `.claude/skills/<skill-name>/SKILL.md`). If it is missing, ask the user to run `$<skill-name>`.
- Bundled skills: read and follow `../<skill-name>/SKILL.md` (a sibling of this skill's directory), or ask the user to run `$<skill-name>`.
<!-- activation-guide end -->
