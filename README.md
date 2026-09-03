# hello-my-skills

这里是一个我本人在编码过程中常用到的 skills 汇总，同一套技能原生支持三种分发形态：**Claude Code 插件**、**Codex / ChatGPT 插件**、**通用 Agent Skills**。

## 设计哲学

主张将 project codebase 作为 skill 设计原则，依据代码库实时更新 project level skills。

随着 LLMs 的发展，配合合适的 harness，AI 本身已经基本能够掌握整个代码仓库。本仓库的 skills 主要以一次 `git commit` 为单位，构成一组能够自主更新的工作流：

```
/grill ──→ /to-docs ──→ /implement ──┬─→ /test ──→ /code-review ──→ /docs-update ──→ 一次 git commit
                                     └─→（项目级技能缺失时）/generate-project-skills
```

- **自维护**：`/generate-project-skills` 生成项目级技能时，会在每个生成的技能中嵌入 Self-maintenance 小节——技能被调用时先自检与代码库的漂移（命令变了、规范文档新增了、目录改了），先更新自身再执行任务
- **一次提交闭环**：`/implement` 的收尾链（test → code-review → docs-update）全部完成后，代码、测试、审查修复、文档更新与技能自更新作为**单个 commit** 落地
- **主代理中继**：/test 的结果由主代理顺序转发给 /code-review 作为审查输入，不依赖后台任务或轮询，三种 harness 行为一致

## skills

由以下 skill 所生成的所有文档都将存放在目标仓库根目录（ARCHITECTURE.md / SPEC.md / WORKFLOW.md / HANDOFF.md / INDEX.md，以及必要时的 `scripts/test`）。

|          skills          |  层级  |                                                                                           详细描述                                                                                           | 是否允许 model 激活 |                            工具权限（以 [claude code tools](https://code.claude.com/docs/en/tools-reference) 为例）                            |
| :----------------------: | :----: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------: | :-----------------------------------------------------------------------------------------------------------------------------: |
|          /grill          | 用户级 | 基于 [grilling](https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling)：设计树 + frontier 轮次提问，每题附推荐答案；事实性问题自查不问用户；**每轮题量由 AI 依据 frontier 决定**（工具单次调用受限时拆为连续调用）；共识确认后激活 /to-docs |         否          |                              Read, Bash, Glob, Grep, AskUserQuestion                              |
|         /to-docs         | 用户级 | 基于 [to-spec](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-spec)：将共识沉淀为根目录 ARCHITECTURE.md（结构）/ SPEC.md（目标，沿用 to-spec 七段模板）/ WORKFLOW.md（流程）；增量更新不盲覆盖 |         是          |                                  Read, Bash, Glob, Grep, Edit, Write                                   |
|        /implement        | 用户级 | 基于 [implement](https://github.com/mattpocock/skills/tree/main/skills/engineering/implement)：先评估 WORKFLOW.md 是否需更新 → 执行任务（TDD、seams 共识）→ 收尾链 /test → /code-review（携带测试结果）→ /docs-update → **一次性 git commit** |         否          |                          Read, Bash, Glob, Grep, Edit, Write, Agent                          |
|         /handoff         | 用户级 | 基于 [handoff](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff)：压缩对话为根目录 HANDOFF.md，含 Suggested skills 小节、敏感信息脱敏、不重复既有文档 |         否          |                                  Read, Bash, Glob, Grep, Edit, Write                                   |
| /generate-project-skills | 用户级 | 读取代码库深度定制（技术栈/测试命令/文档位置/规范），生成三个项目级技能并**同时写入** `.claude/skills/` 与 `.agents/skills/`；每个生成技能含 Self-maintenance 小节 |         否          |                                  Read, Bash, Glob, Grep, Edit, Write                                   |
|       /code-review       | 项目级 | 基于 [code-review](https://github.com/mattpocock/skills/blob/main/skills/engineering/code-review) 两轴审查：Standards（WORKFLOW.md + 项目规范 + smell baseline）与 Spec（SPEC.md/任务）；测试结果由主代理中继注入；只报告不代改 |         是          |                          Read, Bash, Glob, Grep, Edit, Write, Agent                          |
|       /docs-update       | 项目级 | 第一步维护根目录 INDEX.md（全仓库文档目录：名称\|路径\|内容\|维护方式\|最后更新）；第二步更新受影响文档（五件套优先）；HANDOFF.md 只收录不编辑 |         是          |                          Read, Bash, Glob, Grep, Edit, Write, Agent                          |
|          /test           | 项目级 | 基于 [tdd](https://github.com/mattpocock/skills/blob/main/skills/engineering/tdd)：红绿循环、seams 共识、垂直切片、三大反模式；优先复用项目测试设施，无则生成 `scripts/test`；运行后结果交回主代理中继 |         是          |                          Read, Bash, Glob, Grep, Edit, Write, Agent                          |

## 仓库结构

```
hello-my-skills/
├── skills/                  # 唯一手工维护源（同时就是"通用"变体，可直接安装）
│   ├── grill/ to-docs/ implement/ handoff/
│   └── generate-project-skills/
│       └── templates/       # 三个项目级技能模板（占位符待生成器填充）
├── claude-code-plugin/      # 生成物：Claude Code 插件（已通过 claude plugin validate）
├── codex-plugin/            # 生成物：Codex / ChatGPT 插件（含各技能 agents/openai.yaml）
├── .claude-plugin/          # 生成物：marketplace.json（GitHub 一键安装入口）
└── scripts/sync.sh          # 由 skills/ 重新生成以上三者
```

三个变体的差异全部由 `scripts/sync.sh` 处理：

- **frontmatter**：canonical 源只含 `name` + `description`；Claude 版追加 `allowed-tools`、`disable-model-invocation`、`argument-hint`；Codex 版生成 `agents/openai.yaml`（`policy.allow_implicit_invocation` 控制模型自动激活）
- **互调措辞**：canonical 正文以 `<!-- activation-guide -->` 标记块承载中性说明；Claude 版改写为 Skill 工具调用，Codex 版改写为读取 `.agents/skills/` 执行 / `$skill`，通用版保持中性

## 安装

### Claude Code（插件）

```bash
claude plugin marketplace add <github-owner>/hello-my-skills
claude plugin install hello-my-skills@hello-my-skills
```

本地试用（不经 GitHub）：

```bash
claude --plugin-dir ./claude-code-plugin
```

### Codex / ChatGPT（插件）

将 `codex-plugin/` 作为本地 marketplace 安装（参见官方 [Build plugins](https://learn.chatgpt.com/docs/build-plugins) 文档），或采用下面的通用方式。

### 通用（任何支持 [Agent Skills](https://agentskills.io) 的工具：Codex、ZCode、Cursor、Gemini CLI 等）

```bash
cp -r skills/* ~/.agents/skills/
```

项目级技能由 `/generate-project-skills` 在目标项目内生成，无需手动安装。

## 开发

1. 修改 `skills/` 下的 canonical 源（英文正文，中性措辞 + `activation-guide` 标记块）
2. 运行 `scripts/sync.sh` 重新生成两个插件目录与 marketplace.json
3. `scripts/sync.sh --check` 校验生成物与源同步（可用于 CI）
4. 提交：canonical 源与生成物同入一个 commit

发布前可用 `claude plugin validate ./claude-code-plugin` 与 `claude plugin validate .`（marketplace）做官方校验。
