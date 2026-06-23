# cursor使用指南

# 🚀 Cursor 使用指南（AI 代码编辑器）

---

## 一、产品简介

Cursor 是一款基于 VSCode 的 AI 代码编辑器，深度集成了 GPT\-4、Claude 等大语言模型，提供智能代码补全、对话式编程、代码重构等功能。

---

### 🌟 核心优势

- 🚀 原生 AI 集成，无需插件

- 💬 多模型支持（GPT\-4、Claude、自定义模型）

- ⚡ 实时代码补全（Tab 补全）

- 🎯 上下文感知的代码生成

- 🔄 完全兼容 VSCode 插件生态

---

## 二、核心功能与快捷键

---

### 1️⃣ Cmd/Ctrl \+ K \- 行内编辑模式

最常用的功能，在当前光标位置进行 AI 编辑。

**使用场景：**

```JavaScript
// 1. 选中代码，按 Cmd+K，输入指令
function oldFunction() {
  // 选中这段代码
  // 按 Cmd+K 输入："重构为 async/await"
}

// 2. 在空白处按 Cmd+K
// 输入："创建一个用户登录函数"
// AI 会直接生成代码
```

**高级技巧：**

- 选中多行代码一起编辑

- 不选中代码时，AI 会在光标位置插入新代码

- 支持连续编辑（Accept → Cmd\+K → 继续修改）

---

### 2️⃣ Cmd/Ctrl \+ L \- AI 聊天面板

打开侧边栏 AI 对话，进行长对话和复杂任务。

**使用场景：**

```Bash
# 代码解释
"解释这个算法的时间复杂度"

# 调试帮助
"为什么这段代码会报 TypeError？"

# 架构讨论
"帮我设计一个电商系统的数据库架构"

# 代码审查
"审查这个组件的性能问题"
```

**快捷操作：**

- @文件名 \- 引用特定文件到对话

- @文件夹 \- 引用整个文件夹

- @代码 \- 引用选中的代码片段

- @网页 \- 引用网页内容（需要配置）

- @文档 \- 引用项目文档

---

### 3️⃣ Tab \- 智能代码补全

Cursor 最强大的功能之一，类似 GitHub Copilot 但更智能。

**工作原理：**

```JavaScript
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}
```

**高级设置：**

- Cursor Settings → Features → Tab Autocomplete

- 调整建议延迟时间

- 启用/禁用多行补全

- 选择补全模型（快速/强大）

---

### 4️⃣ Cmd/Ctrl \+ Shift \+ L \- 新建 AI 对话

在新的对话窗口中开始，不保留之前的上下文。

---

### 5️⃣ Cmd/Ctrl \+ I \- 快速问答模式

内联快速问答，不打开侧边栏。

---

### 6️⃣ Cmd/Ctrl \+ Shift \+ K \- 终端 AI 助手

在终端中使用 AI 帮助。

---

## 三、高级功能详解

---

### 1️⃣ Composer（项目级 AI）

Cursor 的最强功能，可以同时编辑多个文件。

---

#### 📌 打开方式

- Cmd/Ctrl \+ Shift \+ I

- 或点击右上角 "Composer"

---

#### 🎯 使用场景

```Bash
# 重构模块
"将所有组件从 Class 组件重构为函数组件"

# 添加功能
"添加用户认证功能..."

# 修复 bug
"修复购物车总价计算错误..."

# 生成系统
"创建一个博客系统..."
```

---

#### ⚙️ Composer 工作流

1. 描述任务

2. 分析项目结构

3. 生成修改计划

4. 展示修改内容

5. Accept / 审查

---

#### 💡 高级技巧

- @file1 @file2 @folder/

- 使用 \.cursorrules

- Long Context Mode

---

### 2️⃣ @符号引用系统

精确控制 AI 的上下文。

---

#### 📂 支持类型

- @Files

- @Folders

- @Code

- @Docs

- @Web

- @Git

- @Definitions

- @Codebase

---

### 3️⃣ Rules for AI（\.cursorrules）

为项目定义 AI 行为规则。

---

#### 📄 创建方式

在项目根目录创建 `.cursorrules`

---

#### 🧩 示例结构

（原文规则完整保留）

---

### 4️⃣ 模型选择与切换

---

#### 🤖 可用模型

- GPT\-4

- GPT\-4 Turbo

- GPT\-3\.5 Turbo

- Claude 3\.5 Sonnet

- Claude 3 Opus

- Claude 3 Haiku

- 自定义模型

---

#### 🎯 使用建议

- GPT\-4：复杂任务

- GPT\-4 Turbo：日常开发

- GPT\-3\.5：简单任务

- Claude 3\.5：代码重构

- Claude Opus：高质量任务

- Claude Haiku：快速补全

---

### 5️⃣ Cursor Tab（高级补全）

---

#### ⚙️ 启用方式

Settings → Features → Cursor Tab

---

#### ✨ 特性

- 上下文感知

- 多行预测

- 编辑预测

- Ghost Text

---

### 6️⃣ 索引与搜索

---

#### 🔍 索引内容

- 代码文件

- Git 历史

- 依赖包

- 文档

---

#### ⚡ 性能优化

`.cursorignore`

---

## 四、实用工作流

---

### 1️⃣ 从零创建项目

1. 使用 Composer

2. 配置 \.cursorrules

3. Cmd\+K 微调

4. Tab 补全

---

### 2️⃣ 调试 Bug

1. Cmd\+L 分析

2. 引用文件

3. Cmd\+K 修复

4. 添加测试

---

### 3️⃣ 重构代码

1. Composer 分析

2. 批量修改

3. 审查

4. 测试

---

### 4️⃣ 学习新技术

- Chat 学习

- 边写边学

- 引用文档

---

### 5️⃣ 代码审查

- 性能

- 安全

- 质量

---

## 五、快捷键速查表

---

### 💻 macOS



---

### 🖥 Windows/Linux

Cmd → Ctrl

---

## 六、高级配置

---

### 1️⃣ Settings\.json

---

### 2️⃣ \.cursorignore

---

### 3️⃣ 自定义 Prompt

`.cursor/prompts/`

---

### 4️⃣ 团队配置

`.cursor/team-settings.json`

---

## 七、实用技巧集锦

---

### ⚡ 1️⃣ 加速 AI 响应

- 使用快模型

- 减少上下文

- 使用缓存

- 多用 Tab

---

### 🧠 2️⃣ 提高代码质量

- 定义规则

- 要求测试

- 添加注释

- 审查代码

---

### 📦 3️⃣ 批量操作

- Composer

- 正则引用

- @Codebase

---

### 🐞 4️⃣ 调试技巧

- 完整错误

- 提供上下文

- 分步调试

- 终端 AI

---

### 📚 5️⃣ 学习最佳实践

- 解释代码

- 对比方案

- 改进建议

- 新模式

---

### ✍️ 6️⃣ 高效提示词

✅ 好提示 vs ❌ 差提示（原文保留）

---

## 八、与其他工具对比

---

### ⚔️ Cursor vs Copilot

---

### ⚔️ Cursor vs Claude Code

---

## 九、常见问题解答

---

### ❓ Q\&A

- Cursor 免费吗？

- 如何用免费额度？

- 是否泄露代码？

- 如何提高补全？

- Composer vs Chat？

- VSCode 迁移？

- 支持语言？

- 是否离线？

- 团队配置？

- 如何反馈？

---

## 十、最佳实践总结

---

### 🎯 新手路径

- 第 1 天：基础

- 第 2\-3 天：进阶

- 第 4\-7 天：高级

- 第 2 周\+：精通

---

### 💡 效率建议

1. 键盘优先

2. 上下文管理

3. 规范先行

4. 模型选择

5. 批量操作

6. 持续学习

---

### ⚠️ 注意事项

1. 不要盲信 AI

2. 保护隐私

3. 使用 Git

4. 测试覆盖

5. 性能优化

6. 成本控制

---

## 🧾 总结

Cursor 是目前最强大的 AI 编程工具之一，通过：

- 🎨 直观界面

- ⚡ 强大补全

- 💬 智能对话

- 🔧 深度集成

- 🎯 多模型

👉 编程效率提升数倍！

---

## 🔗 推荐资源

- 官网：[https://cursor\.sh](https://cursor.sh/)

- 文档：[https://docs\.cursor\.com](https://docs.cursor.com/)

- 社区：[https://forum\.cursor\.com](https://forum.cursor.com/)

---





