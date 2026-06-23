# Hooks · 护栏层

> Layer 3 · 护栏层。在工具调用「执行前 / 执行后」插入安全闸门，
> 拦截危险操作、记录操作审计。让 AI 的「手」始终在可控边界内。

---

## 工作原理

Claude Code 在每次工具调用前后会触发对应的 hook 脚本。脚本通过 **stdin 收到 JSON**
（包含工具名、参数等），通过 **退出码** 决定放行或拦截：

| 退出码 | 含义（PreToolUse） |
|--------|---------------------|
| `0` | 放行，正常执行工具 |
| `2` | **拦截**，阻止工具执行，stderr 内容回传给 AI |
| 其他 | 非阻塞错误，记录但不拦截 |

---

## 本目录脚本

| 脚本 | 触发时机 | 作用 |
|------|----------|------|
| `PreToolUse.sh` | 工具执行**前** | 拦截危险命令（rm -rf、强制 push、改 .git 等） |
| `PostToolUse.sh` | 工具执行**后** | 写操作审计日志，便于回溯 |

---

## 启用方式

在 `settings.json` 的 `hooks` 字段注册（本架构已配好，见仓库根的 `settings.json`）：

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/hooks/PreToolUse.sh" }] }
    ],
    "PostToolUse": [
      { "matcher": "*",
        "hooks": [{ "type": "command", "command": "$CLAUDE_PROJECT_DIR/hooks/PostToolUse.sh" }] }
    ]
  }
}
```

记得给脚本可执行权限：`chmod +x hooks/*.sh`

---

## 设计原则

- **黑名单从严，但只拦真危险的**：误删、越权、不可逆操作。别把正常开发命令也拦了，否则 AI 寸步难行。
- **可解释**：拦截时 stderr 要说清「为什么拦」，让 AI 能调整策略而不是干瞪眼。
- **审计而非监视**：PostToolUse 只记录，不做判断，留痕用于事后复盘。
- **护栏是兜底，不是唯一防线**：真正的边界控制靠 `skills/boundary-declaration` 的事前声明。

---

## 自定义

把项目特有的危险模式加进 `PreToolUse.sh` 的 `DANGEROUS_PATTERNS`。
例如：禁止动 `production` 配置、禁止跑某个删库脚本。
