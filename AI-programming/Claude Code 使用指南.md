# Claude Code 使用指南

---

## 一、基础命令

### 1️⃣ 常用斜杠命令

- `/help` \- 查看所有可用命令和帮助信息

- `/clear` \- 清空当前对话历史

- `/commit` \- 创建 Git 提交（需要明确请求）

- `/review-pr` \- 审查 Pull Request

- `/simplify` \- 优化和简化代码质量

- `/feature-dev` \- 引导式功能开发

---

### 2️⃣ 工作流命令

- `/tasks` \- 查看当前任务列表

- `/remember` \- 保存重要信息供后续使用

- `/forget` \- 删除之前保存的记忆

---

### 3️⃣ 特殊命令

- `@filename` \- 在对话中引用特定文件

- `@folder/` \- 引用整个文件夹

---

## 二、核心插件（Skills）

### 1️⃣ simplify \- 代码优化

审查最近修改的代码，检查代码复用、质量和效率问题。

**使用场景：**

- 重构后优化代码结构

- 提升代码可维护性

- 减少代码冗余

**示例：**

```Plain Text
请帮我优化刚才写的代码
/simplify
```

---

### 2️⃣ claude\-api \- Claude API 开发

构建使用 Claude API 或 Anthropic SDK 的应用。

**自动触发条件：**

- 代码导入 anthropic / @anthropic\-ai/sdk

- 用户明确要求使用 Claude API

**示例：**

```Plain Text
帮我写一个使用 Claude API 的聊天应用
```

---

### 3️⃣ code\-review \- 代码审查

对 Pull Request 进行全面的代码审查。

**使用场景：**

- PR 提交前审查

- 发现潜在 bug

- 检查代码规范

**示例：**

```Plain Text
/review-pr
审查 PR #123
```

---

### 4️⃣ feature\-dev \- 功能开发

引导式功能开发，包含架构分析和实现规划。

**使用场景：**

- 开发新功能

- 需要架构设计

- 复杂功能实现

**示例：**

```Plain Text
/feature-dev
帮我实现用户认证功能
```

---

### 5️⃣ frontend\-design \- 前端设计

创建高质量、有设计感的前端界面。

**使用场景：**

- 构建 Web 组件

- 创建页面或应用

- 需要精美 UI 设计

**示例：**

```Plain Text
帮我创建一个现代化的登录页面
```

---

### 6️⃣ Figma 相关技能

#### 🧩 figma:implement\-design

将 Figma 设计转换为生产级代码。

**使用方式：**

```Plain Text
实现这个 Figma 设计
https://figma.com/design/xxx/...
```

---

#### 🔗 figma:code\-connect\-components

连接 Figma 设计组件和代码组件。

**使用方式：**

```Plain Text
将这个 Figma 组件连接到代码
code connect 这个按钮组件
```

---

#### 🎨 figma:create\-design\-system\-rules

为项目生成自定义设计系统规则。

**使用方式：**

```Plain Text
为我的项目创建设计系统规则
```

---

## 三、MCP 服务器

### ❓ 什么是 MCP？

Model Context Protocol（模型上下文协议）允许 Claude 连接外部工具和数据源。

---

### ⚙️ 已配置的 MCP 服务器

#### 1️⃣ Context7 \- 文档查询

查询最新的编程库和框架文档。

**可用工具：**

- resolve\-library\-id \- 解析库名称到 ID

- query\-docs \- 查询文档内容

**使用示例：**

```Plain Text
查询 Next.js 14 的最新路由文档
React 18 的 useEffect 最佳实践
```

---

#### 2️⃣ Figma \- 设计集成

与 Figma 文件交互，生成设计、获取设计上下文等。

**可用工具：**

- get\_design\_context \- 获取设计上下文

- get\_screenshot \- 获取节点截图

- generate\_figma\_design \- 从网页生成设计

- use\_figma \- 执行 Figma Plugin API

- search\_design\_system \- 搜索设计系统资源

**使用示例：**

```Plain Text
获取这个 Figma 组件的设计规范
https://figma.com/design/xxx?node-id=1-2
```

---

#### 3️⃣ Pencil \- 设计文件操作

操作 \.pen 设计文件（Canvas 编辑器）。

**可用工具：**

- batch\_design \- 批量设计操作

- batch\_get \- 批量读取节点

- get\_screenshot \- 获取截图

- export\_nodes \- 导出为图片

---

### 🔧 如何配置 MCP 服务器

在 `~/.claude/settings.json` 中配置：

```JSON
{
  "mcpServers": {
    "your-server-name": {
      "command": "node",
      "args": ["path/to/server.js"],
      "env": {
        "API_KEY": "your-api-key"
      }
    }
  }
}
```

---

## 四、VSCode 集成

### ⌨️ 快捷键（macOS）

#### 对话控制

- Cmd \+ L \- 打开/聚焦 Claude 面板

- Cmd \+ Shift \+ L \- 在新对话中打开

- Escape \- 关闭 Claude 面板

- Cmd \+ Shift \+ P → "Claude" \- 访问所有 Claude 命令

---

#### 💻 代码交互

- 选中代码后右键 → "Ask Claude"

- 选中代码后右键 → "Edit with Claude"

- Cmd \+ K （在编辑器中）\- 快速编辑模式

---

#### 📂 文件引用

- 输入 `@` \- 浏览并引用文件/文件夹

- 拖拽文件到聊天框

---

#### 🧠 任务管理

- 查看右侧任务面板

- 点击任务查看详情

---

### ⌨️ 快捷键（Windows/Linux）

将上述 Cmd 替换为 Ctrl 即可：

- Ctrl \+ L

- Ctrl \+ Shift \+ L

- Ctrl \+ K

---

## 五、高级使用技巧

### 🚀 1️⃣ 工作流自动化

```Plain Text
1. /feature-dev
2. 实现代码
3. /simplify
4. /commit
5. /review-pr
```

---

### 📁 2️⃣ 文件引用最佳实践

```Plain Text
@src/components/Button.tsx
这个组件有什么问题？
```

```Plain Text
@src/api/ @src/types/
帮我重构这些 API 文件
```

---

### 🧠 3️⃣ 上下文管理

- 使用 `/clear` 清空上下文

- 使用 `/remember` 保存重要决策

- 定期检查 `~/.claude/CLAUDE.md`

---

### ⚡ 4️⃣ 任务并行处理

1. 在一个消息中请求多个任务

2. Claude 并行执行

3. 提升效率

---

### 🔧 5️⃣ Git 集成技巧

**安全策略：**

- 不运行破坏性命令

- 不跳过 Git hooks

- 默认新提交

---

**提交流程：**

```Plain Text
请帮我提交刚才的更改
```

---

### 🔍 6️⃣ 代码审查技巧

```Plain Text
/review-pr
关注：
1. 安全
2. 性能
3. 规范
```

---

### 🎨 7️⃣ 设计到代码工作流

**Figma → 代码**

1. 分享链接

2. 获取设计

3. 生成代码

4. Code Connect

---

**网页 → Figma**

```Plain Text
帮我将 localhost:3000 捕获到 Figma
```

---

## 六、配置文件

### 🌍 全局配置

路径：`~/.claude/settings.json`

```JSON
{
  "apiKey": "your-api-key",
  "mcpServers": {},
  "hooks": {
    "preCommit": "npm run lint",
    "postCommit": "npm run test"
  }
}
```

---

### 📦 项目配置

仅供参考，这个可以自己自定义

路径：`.claude/CLAUDE.md`

```Markdown
# Claude 代码修改规范

- 首先必须用中文回答我的问题

你是一个资深前端工程师（10年以上经验），正在一个生产级项目中工作。  
你的所有输出必须符合以下严格规范。

# 🎯 核心目标

- 输出 **可直接运行的高质量代码**
- 遵循 **现代前端最佳实践**
- 保持 **工程一致性 + 可维护性**
- 避免“演示代码”或“简化写法”

---

## ⚠️ 核心修改原则

### 1. 理解优先原则

- **必须先预览和阅读当前代码**，充分理解现有逻辑和实现方式
- 找出相关的函数、组件、状态管理逻辑
- 分析现有的数据流和事件流
- 识别潜在的副作用和依赖关系

### 2. 保持兼容原则

- **不要改变原有的业务逻辑**
- 不要删除或修改现有的功能
- 不要影响其他组件或模块的正常运行
- 保持现有的 API 接口和数据结构不变

### 3. 增量修改原则

- 采用**增量式**而非重写式的修改方式
- 新增代码应该与现有代码风格保持一致
- 优先使用现有的工具函数、Hooks 和组件
- 避免引入不必要的新依赖

### 4. 最小影响原则

- 修改范围应该尽可能小
- 只改动必要的代码行
- 避免"顺手"重构无关代码
- 确保修改的可回溯性

## ✅ 修改流程

```
1. 📖 阅读相关代码文件
   ↓
2. 🔍 理解现有实现逻辑
   ↓
3. 🎯 定位需要修改的位置
   ↓
4. 💡 设计兼容的实现方案
   ↓
5. ✏️ 进行最小化修改
   ↓
6. 🧪 检查是否影响现有功能
```

## 🚫 禁止行为

- ❌ 未阅读代码就直接修改
- ❌ 大范围重构现有代码
- ❌ 删除看似"多余"的代码
- ❌ 改变现有的命名规范
- ❌ 修改无关的代码格式
- ❌ 引入破坏性变更

## 📝 示例

### ❌ 错误做法

```typescript
*// 直接重写整个函数，破坏了原有逻辑*
const handleClick = () => {
  *// 全新的实现，忽略了原有的边界条件和副作用*
  doSomething();
}
```

### ✅ 正确做法

```typescript
*// 在理解原有逻辑的基础上，增量添加新功能*
const handleClick = () => {
  *// 保留原有的边界检查*
  if (isLoading) return;

  *// 保留原有的业务逻辑*
  updateData();

  *// 新增功能：在不影响原有逻辑的前提下添加*
  trackEvent('click');
}
```

## 🎯 目标

通过遵循这些规范，确保：

- ✅ 代码库的稳定性
- ✅ 功能的向后兼容
- ✅ 团队协作的顺畅
- ✅ 代码的可维护性

```

---

## 七、性能优化建议

### ⚡ 1️⃣ 减少上下文开销

- 精确引用文件

- 清理历史

---

### 📦 2️⃣ 批量操作

- 合并修改请求

- 使用 Agent 工具

---

### 🧠 3️⃣ 缓存利用

- 利用文件缓存

- 连续操作更高效

---

## 八、常见问题

**Q: 如何让 Claude 记住项目约定？**
A: 在 `.claude/CLAUDE.md` 中添加项目指令。

**Q: Claude 可以访问哪些文件？**
A: 默认可访问整个工作区，但会尊重 `.gitignore`。

**Q: 如何取消正在运行的任务？**
A: 使用 TaskStop 工具或点击停止按钮。

**Q: MCP 服务器连接失败怎么办？**
A: 检查配置和进程。

**Q: 如何升级 Claude CLI？**
A:

```Plain Text
npm update -g @anthropic-ai/claude-code
```

---

## 🧾 总结

Claude Code 是一个强大的 AI 编程助手，通过：

- 🧩 命令系统

- 🔌 插件技能

- 🌐 MCP 集成

- 💻 IDE 集成

👉 显著提升开发效率！

---

💡 **小贴士：** 从简单功能开始，逐步进阶使用 🚀



