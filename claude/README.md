# Claude 智能体工程化架构

本目录按 **五层架构** 组织，把 Claude 从聊天工具升级为具备 **记忆 / 技能 / 护栏 / 委派 / 分发** 能力的 AI 工程体。

```
.claude/
├── memory/          # Layer 1 · 记忆层（项目宪法 / 规则 / 上下文）
├── skills/          # Layer 2 · 知识层（可复用的能力包）
├── hooks/           # Layer 3 · 护栏层（执行前/后的安全闸门）
├── subagents/       # Layer 4 · 委派层（任务拆解 / 并行协作）
├── plugins/         # Layer 5 · 分发层（扩展能力的版本管理）
├── settings.json    # 项目级配置（hooks / permissions / env 注册）
└── settings.local.json  # 本地权限白名单（gitignore）
```

## 五层职责速览

| 层级 | 目录 | 作用 | 解决什么痛点 |
|------|------|------|------|
| 🧠 1 记忆 | `memory/` | 项目宪法、命名规范、架构红线 | 记忆缺失：每次对话重新解释项目 |
| 📚 2 知识 | `skills/` | 业务/技术领域的能力包 | 能力不足：不懂业务、不熟工具链 |
| 🛡️ 3 护栏 | `hooks/` | 危险操作拦截、操作审计 | 安全风险：误删、越权、漏改 |
| 🤝 4 委派 | `subagents/` | 复杂任务拆分给子智能体 | 效率低下：一个 Agent 啥都干 |
| 📦 5 分发 | `plugins/` | 扩展工具的版本管理 | 协作不齐：团队工具不一致 |

## 快速上手

1. **读规则** · 先看 [memory/project.md](memory/project.md) 了解项目宪法，再看 [memory/conventions.md](memory/conventions.md) 命名规范、[memory/context.md](memory/context.md) 当前上下文
2. **挑技能** · 任务匹配 [skills/](skills/README.md) 下哪个 SKILL.md，按里面流程走；新建能力复制 [skills/_TEMPLATE/](skills/_TEMPLATE/SKILL.md)
3. **走护栏** · 危险操作会被 [hooks/PreToolUse.sh](hooks/PreToolUse.sh) 拦截，操作留痕在 [hooks/PostToolUse.sh](hooks/PostToolUse.sh)
4. **派子智能体** · 大任务用 [subagents/](subagents/README.md) 里的 architect / coder / reviewer 角色拆分
5. **配工具** · MCP 与插件清单见 [plugins/README.md](plugins/README.md)，启用配置在 [settings.json](settings.json)

## 落地步骤

1. 把 [memory/project.md](memory/project.md) 与 [memory/conventions.md](memory/conventions.md) 的占位符 `<...>` 填成本项目实况
2. 按需在 [hooks/PreToolUse.sh](hooks/PreToolUse.sh) 的 `DANGEROUS_PATTERNS` 追加项目特有红线
3. 在 [settings.json](settings.json) 调整 permissions 白名单与 `env`
4. 给脚本可执行权限：`chmod +x hooks/*.sh`

详细方法论见同级 [ai-native-frontend-workflow.md](./ai-native-frontend-workflow.md)，配套项目级规范见 [DEVSKILL.md](./DEVSKILL.md)。
