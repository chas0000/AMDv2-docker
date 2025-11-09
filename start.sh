#!/bin/bash
set -e
echo "尝试启动"
# 1. 检查 /app2/amdl/config.toml 是否存在
if [ ! -f /app2/config/config.toml ]; then
    cp /app/config.example.toml /app2/config/config.toml
else
    cp /app/config/config.toml /app/config.toml  
fi

export TERM=xterm-256color
export LANG=zh_CN.UTF-8
# 后台运行 ttyd
#ttyd -W  screen -xR mysession bash &
#ttyd -W  bash &
#ttyd -W  screen -xR mysession &
#ttyd -W tmux new -A -s mysession &
exit 0
