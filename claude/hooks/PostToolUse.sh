#!/usr/bin/env bash
#
# Layer 3 · 护栏层 · PostToolUse
# 在工具执行后记录操作审计日志，用于事后复盘。
#
# 输入：stdin 收到 JSON，形如 {"tool_name":"...","tool_input":{...}}
# 行为：只记录，不拦截，永远以退出码 0 结束（审计失败不应阻塞工作流）。

set -uo pipefail

INPUT="$(cat)"

LOG_DIR="${CLAUDE_PROJECT_DIR:-.}/hooks/.logs"
LOG_FILE="$LOG_DIR/audit.log"
mkdir -p "$LOG_DIR" 2>/dev/null || true

# 提取工具名
if command -v jq >/dev/null 2>&1; then
  TOOL="$(printf '%s' "$INPUT" | jq -r '.tool_name // "unknown"')"
  DETAIL="$(printf '%s' "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null | head -c 500)"
else
  TOOL="$(printf '%s' "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:[[:space:]]*"//;s/"$//')"
  DETAIL="$(printf '%s' "$INPUT" | head -c 500)"
fi

TS="$(date '+%Y-%m-%d %H:%M:%S')"
printf '[%s] tool=%s input=%s\n' "$TS" "${TOOL:-unknown}" "${DETAIL:-}" >> "$LOG_FILE" 2>/dev/null || true

exit 0
