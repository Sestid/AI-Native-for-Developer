#!/usr/bin/env bash
#
# Layer 3 · 护栏层 · PreToolUse
# 在 Bash 工具执行前拦截危险命令。
#
# 输入：stdin 收到 JSON，形如 {"tool_input":{"command":"..."}}
# 输出：退出码 2 = 拦截（stderr 回传 AI）；0 = 放行。
#
# 这是防御性安全脚本：目的是防止误删、越权、不可逆操作，保护用户工作成果。

set -euo pipefail

# 读取 stdin 的 JSON 输入
INPUT="$(cat)"

# 提取命令文本（优先用 jq，无 jq 时退化为 grep 抽取）
if command -v jq >/dev/null 2>&1; then
  COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')"
else
  COMMAND="$(printf '%s' "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:[[:space:]]*"//;s/"$//')"
fi

# 空命令直接放行
[ -z "${COMMAND:-}" ] && exit 0

# ── 危险模式黑名单（按需在此追加项目特有规则）──────────────
# 每行一个 grep 扩展正则；命中即拦截。
DANGEROUS_PATTERNS=(
  'rm[[:space:]]+-[a-z]*r[a-z]*f'        # rm -rf 递归强删
  'rm[[:space:]]+-[a-z]*f[a-z]*r'        # rm -fr
  ':\(\)\{.*\|:&.*\}'                    # fork 炸弹
  'git[[:space:]]+push.*--force'         # 强制推送
  'git[[:space:]]+push.*-f([[:space:]]|$)'
  'git[[:space:]]+reset[[:space:]]+--hard'  # 硬重置
  'git[[:space:]]+clean[[:space:]]+-[a-z]*f' # 清理未跟踪文件
  '>[[:space:]]*/dev/sd[a-z]'            # 直写磁盘设备
  'mkfs'                                 # 格式化
  'dd[[:space:]]+if=.*of=/dev/'          # dd 写设备
  'chmod[[:space:]]+-R[[:space:]]+777'   # 全开权限
  '--no-verify'                          # 跳过 git hook
  'DROP[[:space:]]+TABLE'                # 删表
  'DROP[[:space:]]+DATABASE'             # 删库
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if printf '%s' "$COMMAND" | grep -Eiq -e "$pattern"; then
    echo "🛡️ [护栏拦截] 检测到危险操作，已阻止执行。" >&2
    echo "   命令：$COMMAND" >&2
    echo "   命中规则：$pattern" >&2
    echo "   如确需执行，请人工确认后手动运行，或调整命令规避不可逆风险。" >&2
    exit 2
  fi
done

# 放行
exit 0
