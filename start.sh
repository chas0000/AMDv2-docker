#!/bin/sh
set -e
echo "尝试启动"

# 1. 检查配置文件
if [ ! -f /app2/config/config.toml ]; then
    cp /app/config.example.toml /app2/config/config.toml
else
    cp /app2/config/config.toml /app/config.toml  
fi

export TERM=xterm-256color
export LANG=zh_CN.UTF-8

# 2. 设置 screen socket 目录
export SCREENDIR=/tmp/screen
mkdir -p "$SCREENDIR"
chmod 700 "$SCREENDIR"

# 3. 启动后台 screen 会话
screen -dmS mysession bash -c "poetry run python main.py 2>&1 | tee /tmp/mysession.log"

# 4. 等待 session 就绪
sleep 2

# 5. 启动 ttyd（前台运行）
if [ -n "$TTYD_USER" ] && [ -n "$TTYD_PASS" ]; then
    echo "[INFO] Starting ttyd with auth..."
    exec ttyd -W -c "$TTYD_USER:$TTYD_PASS" screen -xRR mysession
else
    echo "[INFO] Starting ttyd without auth..."
    exec ttyd -W screen -xRR mysession
fi
