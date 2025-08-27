#!/bin/bash
# ARMv7 无头浏览器启动脚本

export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 &

# 启动 Python 应用
exec python main.py
