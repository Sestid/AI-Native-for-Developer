# AI-Native-for-Developer

在开发过程当中总结的 AI 相关的知识。

## 目录介绍

### `AI-programming/` — AI 编程工具使用指南

记录各类 AI 编程工具的使用技巧与实践经验。

- `AI编程使用技巧.md` — AI 辅助编程的通用方法与技巧总结
- `Claude Code 使用指南.md` — Claude Code 的使用说明
- `cursor使用指南.md` — Cursor 编辑器的使用说明

### `skills/` — 开发技能（Skill）

以 Skill 形式沉淀的可复用开发能力，供 AI 在对应场景下调用。

- `frontend-framework/SKILL.md` — AI Native 前端项目的架构规范与开发模式（React + TypeScript + MobX，Feature-based 分层架构）

### `claude/` — Claude 智能体工程化架构

把 Claude 从聊天工具升级为具备 **记忆 / 技能 / 护栏 / 委派 / 分发** 能力的 AI 工程体，按五层架构组织。

| 层级 | 目录 | 作用 |
|------|------|------|
| 🧠 记忆层 | `memory/` | 项目宪法、命名规范、架构红线 |
| 📚 知识层 | `skills/` | 可复用的能力包 |
| 🛡️ 护栏层 | `hooks/` | 执行前/后的安全闸门 |
| 🤝 委派层 | `subagents/` | 任务拆解、并行协作 |
| 📦 分发层 | `plugins/` | 扩展能力的版本管理 |

- `settings.json` — 项目级配置（hooks / permissions / env 注册）
- 详见 `claude/README.md`
