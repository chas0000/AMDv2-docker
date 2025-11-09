#!/bin/sh
set -e
echo "尝试启动"
# 1. 检查 /app2/amdl/config.toml 是否存在
if [ ! -f /app2/config/config.toml ]; then
    cp /app/config.example.toml /app2/config/config.toml
else
    cp /app2/config/config.toml /app/config.toml  
fi

export TERM=xterm-256color
export LANG=zh_CN.UTF-8
# 设置 screen socket 目录
export SCREENDIR=/tmp/screen
mkdir -p "$SCREENDIR"
chmod 700 "$SCREENDIR"

# 启动后台 screen 会话
screen -dmS mysession bash -c "poetry run python main.py"

# 等待 session 就绪
sleep 2

# 根据是否配置认证启动 ttyd
if [ -n "$TTYD_USER" ] && [ -n "$TTYD_PASS" ]; then
    echo "[INFO] Starting ttyd with auth..."
    ttyd -W -c "$TTYD_USER:$TTYD_PASS" screen -xRR mysession
else
    echo "[INFO] Starting ttyd without auth..."
    ttyd -W screen -xRR mysession
fi
# 后台运行 ttyd
#ttyd -W  screen -xR mysession bash &
#ttyd -W  bash &
#ttyd -W  screen -xR mysession &
#ttyd -W tmux new -A -s mysession &
exit 0
