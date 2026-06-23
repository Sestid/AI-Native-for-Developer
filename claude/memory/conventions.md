# 命名与代码规范（Conventions）

> Layer 1 · 记忆层。本文件承载「与技术栈强相关」的细则，
> 与技术无关的通用原则放在 `project.md`。

---

## 1. 命名规范

| 类别 | 规则 | 示例 |
|------|------|------|
| 文件 - 组件/类 | PascalCase | `UserCard.tsx` / `UserService` |
| 文件 - 工具/普通 | camelCase 或 kebab-case（全项目统一其一） | `formatDate.ts` / `format-date.ts` |
| 函数 / 变量 | camelCase | `fetchUser`、`userList` |
| 类型 / 接口 | PascalCase | `UserInfo`、`ApiResponse` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY` |
| 私有/内部成员 | 不导出 + 约定前缀 | `fetchUserApi`（私有，不导出） |
| 布尔值 | is/has/should 前缀 | `isLoading`、`hasPermission` |

> 落地时删掉不适用的语言行，补上本项目实际用的语言细则。

---

## 2. 代码风格

- **格式化**：交给工具（Prettier / gofmt / ruff 等），不手动对齐，不在 PR 里夹格式 diff。
- **类型安全**：所有导出有显式类型；避免逃逸类型（`any` / `interface{}` / `Object`），确需时注释原因。
- **错误处理**：在边界层统一处理（捕获、提示、转换），不把底层错误裸抛到 UI / 调用方。
- **注释**：默认不写。只在「为什么」非显而易见时写一行——隐藏约束、坑点、反直觉行为。
- **导入**：每个目录有统一出口（`index` / `__init__` / `mod`），对外只暴露出口。

---

## 3. 目录与分层约定

> 按本项目实际架构填写。下方为「分层式」通用模板，按需替换。

```
src/
├── <feature>/          # 业务模块，自包含
│   ├── ui/             # 展示层：只渲染，事件只转发给状态层
│   ├── stores/         # 状态层：管理状态 + 协调流程
│   ├── services/       # 服务层（可选）：API 调用 + 业务编排 + 副作用
│   ├── domain/         # 领域层（可选）：纯函数业务规则，无副作用
│   └── index           # 统一出口
└── shared/             # 跨模块共享：ui / stores / utils / api / config
```

**依赖方向（单向）**：`ui → stores → services → domain`

**各层一句话职责**：
- UI：只负责展示与交互转发，禁止直接调用 API、禁止写业务逻辑。
- Store/State：管理状态、调用服务层，禁止直接 import UI、禁止直连 API。
- Service：封装 API、编排业务、处理副作用与用户提示。
- Domain：纯函数，可测试可复用，禁止 API / 全局状态 / UI 依赖。

---

## 4. 提交与分支

- **提交信息**：`<type>: <一句话说清为什么>`（feat/fix/refactor/docs/test/chore）。
- **一 PR 一意图**：触碰文件 > 10 个或跨模块，拆 PR。
- **不夹带**：一次提交不混入无关重构 / 格式化。

---

## 5. 测试约定

- 纯函数 / 领域层优先单测。
- 涉及外部系统（DB / 网络）的关键路径走集成测试，不要只靠 mock 蒙混。
- 改完跑一遍 `lint` + `test` + 主流程冒烟再算完成。

---

**版本**：v1.0
**最后更新**：`<填写>`
