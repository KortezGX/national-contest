#!/bin/bash
# downWithNodeService.sh
# 用法：./downWithNodeService.sh

set -e # 指令失敗時立即終止腳本，避免後續錯誤

# 引入共用 header（開始提示）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

YML_PATH="../docker-compose.generated.yml"

echo -e "\033[1;36m========================="
echo -e "停止並移除所有 node container"
echo -e "=========================\033[0m"

# 互動確認
echo -e "\033[1;33m確定要移除所有 node container 及產生的 yml 檔案嗎？(y/N)\033[0m"
read -p $'\033[1;33m請輸入 y 以繼續：\033[0m' CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo -e "\033[0;31m已取消移除操作。\033[0m"
  end_script
fi

# 停止並移除所有 node container（包含孤兒 container）
docker compose -f $YML_PATH down --remove-orphans

# 移除 tmp 下的 yml 檔案
rm -f $YML_PATH

echo -e "\033[1;32m=========================="
echo -e "所有 node container 及 yml 檔案已移除！"
echo -e "==========================\033[0m"

end_script
