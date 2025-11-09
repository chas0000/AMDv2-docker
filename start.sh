#!/bin/sh
set -e

echo "[INFO] Starting application..."

# 1. 检查配置文件
if [ ! -f /app2/config/config.toml ]; then
    cp /app/config.example.toml /app2/config/config.toml
else
    cp /app2/config/config.toml /app/config.toml
fi

# 2. 设置环境
export TERM=xterm-256color
export LANG=zh_CN.UTF-8

# 3. 设置 tmux socket 目录
export TMUX_TMPDIR=/tmp/tmux
mkdir -p "$TMUX_TMPDIR"
chmod 700 "$TMUX_TMPDIR"

SESSION_NAME=mysession

# 4. 启动 tmux session 后台运行 Python（只启动一次）
if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "[INFO] Creating tmux session $SESSION_NAME..."
    tmux new-session -d -s $SESSION_NAME "poetry run python main.py; exec bash"
else
    echo "[INFO] tmux session $SESSION_NAME already exists, reusing..."
fi

# 5. 等待 session 就绪
sleep 2

# 6. 清理可能的嵌套 tmux 环境
unset TMUX

# 7. 启动 ttyd 并 attach tmux session
TTYD_CMD="tmux attach -t $SESSION_NAME"

if [ -n "$TTYD_USER" ] && [ -n "$TTYD_PASS" ]; then
    echo "[INFO] Starting ttyd with auth..."
    ttyd -W -c "$TTYD_USER:$TTYD_PASS" $TTYD_CMD
else
    echo "[INFO] Starting ttyd without auth..."
    ttyd -W $TTYD_CMD
fi

# ttyd 前台运行，start.sh 不退出
