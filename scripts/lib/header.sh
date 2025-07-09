#!/bin/bash
# header.sh
# 共用：顯示模擬 prompt 與執行指令

clear
USER=$(whoami)
HOST=$(hostname)
PWD=$(pwd)

printf '\n%.0s' {1..1}

echo "$USER@$HOST:$PWD# $0 $@"
