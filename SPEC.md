# hello-my-skills 实现计划

## 已确认的决策（grilling 五轮结果 + 修正）

1. 目录：`claude-code-plugin/` + `codex-plugin/` + `skills/`（通用）
2. `skills/` 为唯一手工维护源，`scripts/sync.sh` 生成两个插件目录
3. SKILL.md 正文英文，README 中文
4. 项目级技能（code-review/docs-update/test）仅作模板，存放于 `generate-project-skills/templates/`，不随插件分发为可触发技能
5. 互调措辞按变体定制：Claude 版写 Skill 工具调用、Codex 版写 $skill/读取执行、通用版中性措辞（由 sync 脚本从受控标记改写）
6. /test 结果由主代理顺序中继给 /code-review（不依赖轮询/后台任务）
7. /generate-project-skills 同时写入目标项目 `.claude/skills/` 与 `.agents/skills/`
8. Claude 侧附根目录 `.claude-plugin/marketplace.json`（可从 GitHub 一键安装）；Codex 侧 README 记录本地 marketplace 安装
9. /implement 收尾链：/test → /code-review（携带测试结果）→ /docs-update
10. HANDOFF.md 存仓库根目录
11. 文档目录 = 根目录 INDEX.md（表格：文档名|路径|内容描述|维护方式|最后更新）
12+17. 自维护机制：不建独立技能，生成器在每个生成的技能中嵌入 Self-maintenance 小节（被调用时先自检与代码库漂移、先更新自身再执行），共 8 个技能
13. 三文档划分：ARCHITECTURE（结构）/ SPEC（目标，沿用 to-spec 七段模板）/ WORKFLOW（流程，/implement 的执行依据）
14. 测试脚本：优先项目现有测试设施，无则生成根目录 scripts/test
15. 生成器读取代码库深度定制（嵌入项目特定事实）
16. /docs-update 覆盖全仓库文档（根目录五件套优先）
18. /implement 全链完成后一次性 git commit（代码+测试+审查修复+文档+技能自更新同入一个 commit）
19. grill 每轮问题数量由 AI 依据 frontier 自行决定，不设固定上限（工具单次调用有上限时，同一轮拆分为连续多次调用）

## 一、目录结构

```
hello-my-skills/
├── README.md                          # 更新：中文，安装说明+技能表
├── .claude-plugin/
│   └── marketplace.json               # 仓库根 marketplace，指向 ./claude-code-plugin
├── scripts/
│   └── sync.sh                        # 同步脚本（含变体配置表）
├── skills/                            # 通用变体 = 唯一手工维护源（canonical，中性措辞）
│   ├── grill/SKILL.md
│   ├── to-docs/SKILL.md
│   ├── implement/SKILL.md
│   ├── handoff/SKILL.md
│   └── generate-project-skills/
│       ├── SKILL.md
│       └── templates/                 # 项目级技能模板（含占位符）
│           ├── code-review/SKILL.md
│           ├── docs-update/SKILL.md
│           └── test/SKILL.md
├── claude-code-plugin/                # 生成物
│   ├── .claude-plugin/plugin.json
│   └── skills/                        # 5 个用户级技能（Claude 措辞+完整 frontmatter）
└── codex-plugin/                      # 生成物
    ├── .codex-plugin/plugin.json      # { name, version, description, "skills": "./skills/" }
    └── skills/                        # 5 个用户级技能 + 各自 agents/openai.yaml
```

## 二、同步脚本 scripts/sync.sh（bash，Git Bash 兼容）

1. 复制 `skills/` 下 5 个用户级技能到两个插件的 `skills/`
2. frontmatter 组装：canonical 源只含 name+description；按内嵌配置表追加变体字段
   - Claude：`allowed-tools`、`disable-model-invocation`（grill/implement/handoff/generate-project-skills 为 true）、`argument-hint`（handoff）
   - Codex：保持 name+description，另生成 `agents/openai.yaml`（invocation policy，非 model 激活的技能设 allow_implicit_invocation: false；含工具依赖；确切 schema 实现时以 learn.chatgpt.com 文档为准）
   - 通用：原样
3. 互调措辞改写：canonical 正文用受控标记（如 `{{invoke:test}}`），按变体替换为 Skill 工具调用 / $skill·读取执行 / 中性措辞
4. 生成清单：`claude-code-plugin/.claude-plugin/plugin.json`、根 `.claude-plugin/marketplace.json`、`codex-plugin/.codex-plugin/plugin.json`（插件名 hello-my-skills，版本 0.1.0）
5. 幂等（重复运行无 diff），支持 `--check` 模式输出差异；结束打印变更摘要

## 三、8 个技能内容设计（正文英文）

全局约定：所有生成产物（ARCHITECTURE.md / SPEC.md / WORKFLOW.md / HANDOFF.md / INDEX.md / 测试脚本）默认在目标仓库根目录；正文 <500 行，细节放 references/。

### 用户级（5 个，随三变体分发）

**1. grill**（手动触发；Read/Bash/Glob/Grep/AskUserQuestion）
基于 mattpocock grilling：设计树、frontier 轮次提问、❓编号问题+➡️推荐答案格式、事实性问题自查不问用户。适配：**每轮问题数量由 AI 依据 frontier 自行决定，不设固定上限**；优先 AskUserQuestion 类工具，单次调用达到工具上限时将同一轮拆分为连续多次调用；工具不可用则按原版格式在对话中列整轮并等待。完成判据：frontier 为空且用户确认共识 → 激活 to-docs。

**2. to-docs**（model 可激活；Read/Bash/Glob/Grep/Edit/Write）
将 grill 或对话确认的共识沉淀为三份根目录文档：ARCHITECTURE.md（技术栈/模块划分/依赖/数据流）、SPEC.md（to-spec 七段模板：Problem/Solution/User Stories/Implementation Decisions/Testing Decisions/Out of Scope/Further Notes）、WORKFLOW.md（构建/测试/lint/提交命令与流程约定）。增量更新：先读现有文档再合并，不覆盖人工内容。INDEX.md 归 /docs-update 管理。

**3. implement**（手动触发；+Agent）
① 读 WORKFLOW.md+ARCHITECTURE.md，先评估 WORKFLOW.md 是否需随本任务更新；② 执行任务（TDD 优先、pre-agreed seams、频繁类型检查与单文件测试）；③ 收尾链：激活 /test → 将测试结果注入 /code-review → /docs-update；④ 项目级技能不存在时提示先运行 /generate-project-skills（降级：直接运行测试+自审）；⑤ 全链完成后一次性 git commit。

**4. handoff**（手动触发；argument-hint 为下一会话用途）
基于 mattpocock handoff：压缩对话为根目录 HANDOFF.md，含 Suggested skills 小节、敏感信息脱敏、不与其他工件重复内容。

**5. generate-project-skills**（手动触发；Read/Bash/Glob/Grep/Edit/Write）
深度定制：分析项目技术栈/测试命令/文档位置/规范文件，将项目事实填入三个模板占位符；在每个生成的技能中嵌入 Self-maintenance 小节；写入目标项目 `.claude/skills/` 与 `.agents/skills/` 两处。

### 项目级模板（3 个，占位符待生成器填充）

**6. code-review**（model 可激活；+Agent）
mattpocock 两轴审查：Standards 轴（WORKFLOW.md+项目规范文件+smell baseline）与 Spec 轴（SPEC.md/当前对话）；钉住 fixed point（工作区 vs HEAD）；支持并行子代理。适配：测试结果由主代理中继注入输入。含 Self-maintenance。

**7. docs-update**（model 可激活；+Agent）
第一步创建/更新根目录 INDEX.md（收录全仓库文档）；第二步依据目录+上下文更新受影响文档（五件套优先）。含 Self-maintenance。

**8. test**（model 可激活；+Agent）
mattpocock tdd：红绿循环、seams 共识、垂直切片、三大反模式（implementation-coupled/tautological/horizontal slicing）。README 行为：按项目架构生成测试脚本（优先现有测试设施，否则根目录 scripts/test）；已存在则先评估修改再运行；运行并等待结果；结果交回主代理中继给 /code-review。含 Self-maintenance。

## 四、README 更新（中文）

保留设计哲学与技能表（补充自维护机制、收尾链顺序、一次提交说明、grill 轮次由 AI 决定），新增：仓库结构与三变体说明；安装方式（Claude Code：marketplace add 或 --plugin-dir；Codex：本地 marketplace 或复制到 ~/.agents/skills/；通用：复制 skills/ 到 ~/.agents/skills/）；开发流程（改 skills/ → scripts/sync.sh → 提交）。

## 五、实施步骤

1. `git init`（当前非 git 仓库）
2. 编写 `scripts/sync.sh`（含 per-skill 配置表与措辞替换表）
3. 编写 5 个用户级技能 + 3 个模板（canonical、英文、中性措辞+受控标记）
4. 运行 sync.sh 生成 claude-code-plugin/、codex-plugin/、根 marketplace.json
5. 校验：frontmatter YAML 可解析、目录名=name、sync 幂等（跑两次无 diff）、`claude plugin validate`（若本机有 claude CLI）
6. 更新 README.md
7. 初始 commit