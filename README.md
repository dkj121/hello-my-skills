# hello-my-skills

这里是一个我本人在编码过程中常用到的 skills 汇总，同一套技能原生支持三种分发形态：**Claude Code 插件**、**Codex / ChatGPT 插件**、**通用 Agent Skills**。

## 设计哲学

主张将 **project codebase 作为上下文源**，而非将工作流固化为硬编码技能链。随着 LLMs 的发展，配合合适的 harness，AI 本身已经基本能够掌握整个代码仓库并选择合适的工作流。

```
/grill ──→ /to-docs ──→ /implement ──→（用户激活时）注入项目指导 ──→ AI 选择成熟技能
                                     └─→ /generate-project-skills（生成指导文档）
```

### 核心原则

- **指导而非固化**：`/generate-project-skills` 生成的是**指导文档**（项目测试命令、规范来源、文档位置等），而非硬编码的可执行技能。这些指导在 AI 需要时注入上下文，帮助 AI 理解项目约定。

- **AI 自主选择工作流**：`/implement` 不再强制 test → code-review → docs-update 的固定链条。AI 根据：
  - 项目指导文档（如果存在）
  - 项目 WORKFLOW.md / ARCHITECTURE.md / SPEC.md
  - 任务性质（TDD、修复、重构、文档）
  - 可用的成熟技能（如 ECC 的 `ecc:tdd`、`ecc:code-review` 等）
  
  自主选择合适的工作流和技能组合。

- **一次提交闭环**：无论 AI 选择何种工作流，最终目标不变：代码、测试、审查修复、文档更新在一次 git commit 中完成。

- **渐进增强**：
  - 项目没有指导文档 → AI 依据 WORKFLOW.md 等项目文档工作
  - 项目有指导文档 → AI 获得更精确的上下文（测试命令、规范位置）
  - 有成熟技能可用 → AI 优先使用（如 `ecc:tdd` 而非自己实现 TDD）

## skills

由以下 skill 所生成的所有文档默认存放在目标仓库根目录（ARCHITECTURE.md / SPEC.md / WORKFLOW.md / HANDOFF.md，以及必要时的 `scripts/test`）。**用户可能自行迁移文档位置**：技能在读取或更新前会用 Glob/Grep 定位文档，就地更新，而不是在根目录另建副本。

|          skills          |  层级  |                                                                                                                             详细描述                                                                                                                              | 是否允许 model 激活 | 工具权限（以 [claude code tools](https://code.claude.com/docs/en/tools-reference) 为例） |
| :----------------------: | :----: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------: | :--------------------------------------------------------------------------------------: |
|          /grill          | 用户级 | 基于 [grilling](https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling)：设计树 + frontier 轮次提问，每题附推荐答案；事实性问题自查不问用户；**每轮题量由 AI 依据 frontier 决定**（工具单次调用受限时拆为连续调用）；共识确认后激活 /to-docs |         否          |                         Read, Bash, Glob, Grep, AskUserQuestion                          |
|         /to-docs         | 用户级 |                       基于 [to-spec](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec)：将共识沉淀为根目录 ARCHITECTURE.md（结构）/ SPEC.md（目标，沿用 to-spec 七段模板）/ WORKFLOW.md（流程）；增量更新不盲覆盖                        |         是          |                           Read, Bash, Glob, Grep, Edit, Write                            |
|        /implement        | 用户级 |           基于 [implement](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement)：读取项目文档与指导（如有），由 AI 自主选择合适的工作流与技能（优先使用成熟技能），review 发现错误时**阻止提交并提醒用户修复**，最终**一次性 git commit**           |         否          |                        Read, Bash, Glob, Grep, Edit, Write, Agent                        |
|         /handoff         | 用户级 |                                          基于 [handoff](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff)：压缩对话为带描述的 handoff 文件（handoff-{description}.md），保存到系统临时目录，含 YAML 头/Overview/One Core Rule/Things to Fix                                          |         否          |                           Read, Bash, Glob, Grep, Edit, Write                            |
| /generate-project-skills | 用户级 |                                                读取代码库深度定制（技术栈/测试命令/文档位置/规范），**通过 subagents 并行生成**三个项目指导文档（test, code-review, core-docs-update）并写入 `.claude/skills/` 与 `.agents/skills/`，供 AI 读取作为上下文                                                 |         否          |                        Read, Bash, Glob, Grep, Edit, Write, Agent                        |

## 仓库结构

```
hello-my-skills/
├── skills/                  # 唯一手工维护源（同时就是"通用"变体，可直接安装）
│   ├── grill/ to-docs/ implement/ handoff/
│   └── generate-project-skills/
│       └── templates/       # 三个项目级技能模板（占位符待生成器填充）
├── claude-code-plugin/      # 生成物：Claude Code 插件（已通过 claude plugin validate）
├── codex-plugin/            # 生成物：Codex / ChatGPT 插件（含各技能 agents/openai.yaml，已实测安装）
├── .claude-plugin/          # 生成物：Claude marketplace.json（GitHub 一键安装入口）
└── .agents/plugins/         # 生成物：Codex marketplace.json（GitHub 一键安装入口）
```

## 安装

### Claude Code（插件）

```bash
claude plugin marketplace add dkj121/hello-my-skills
claude plugin install hello-my-skills@hello-my-skills
```

本地试用（不经 GitHub）：

```bash
claude --plugin-dir ./claude-code-plugin
```

### Codex / ChatGPT（插件）

从 GitHub 直接安装：

```bash
codex plugin marketplace add dkj121/hello-my-skills
codex plugin add hello-my-skills@hello-my-skills
```

本地试用（将本仓库作为本地 marketplace 源）：

```bash
codex plugin marketplace add /path/to/hello-my-skills
codex plugin add hello-my-skills@hello-my-skills
```

### 通用（任何支持 [Agent Skills](https://agentskills.io) 的工具：Codex、ZCode、Cursor、Gemini CLI 等）

通过 [skills.sh](https://www.skills.sh/)（Vercel 维护的 Agent Skills 开放目录，安装时自动适配 Claude Code、Codex、Cursor、Copilot 等主流 agent）一键安装：

```bash
npx skills add dkj121/hello-my-skills
```

或手动复制到用户级技能目录：

```bash
cp -r skills/* ~/.agents/skills/
```

项目级技能由 `/generate-project-skills` 在目标项目内生成，无需手动安装。
