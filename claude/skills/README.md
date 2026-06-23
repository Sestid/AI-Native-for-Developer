# Skills · 知识层

> Layer 2 · 知识层。把「可复用的能力」封装成 skill 文档，
> 让 AI 接到匹配任务时按图索骥，不必每次重新理解。

---

## Skill 的两个层级

| 层级 | 内容 | 放哪 |
|------|------|------|
| **项目级** | 整个仓库的宪法：分层、命名、允许/禁止 | `memory/project.md` + `memory/conventions.md` |
| **模块级** | 单个领域 / 功能的接入规范、门禁、自检清单 | `skills/<skill-name>/SKILL.md` |

> 项目级宪法拦不住「模块级反模式」，模块级 skill 才能。两层都备齐，AI 才能写出符合项目品味的代码。

---

## 目录结构

```
skills/
├── README.md                  # 本文件
├── _TEMPLATE/                 # 新建 skill 的模板，复制改名即用
│   └── SKILL.md
├── prd-to-plan/               # 示例：PRD → 结构化开发文档
│   └── SKILL.md
└── boundary-declaration/      # 示例：开发前边界声明门禁
    └── SKILL.md
```

---

## 如何新建一个 skill

1. 复制 `_TEMPLATE/` 为 `skills/<你的能力名>/`。
2. 填写 `SKILL.md` 的：触发时机、输入、流程、产出、自检清单。
3. 在本 README 的目录里登记一行。
4. 用过之后回写：踩到的新坑补进对应 skill，这是复利所在。

---

## 何时该写 skill？

- 同一类任务做过 ≥ 2 次，且每次都要给 AI 解释一遍背景 → 沉淀成 skill。
- 某模块有「接入门禁」（必须按固定步骤做，漏一步就出错）→ 写成 skill。
- 反之，一次性的简单任务不需要 skill，别过度沉淀。

---

## Skill 清单

| Skill | 用途 | 触发时机 |
|-------|------|---------|
| [prd-to-plan](prd-to-plan/SKILL.md) | 把 PRD 抽成结构化开发文档 | 拿到新需求 / PRD 时 |
| [boundary-declaration](boundary-declaration/SKILL.md) | 开发前强制声明边界 | 任何动手写代码之前 |
