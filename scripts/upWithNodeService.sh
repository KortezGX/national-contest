#!/bin/bash
# upWithNodeService.sh
# 用法：./upWithNodeService.sh

set -e # 指令失敗時立即終止腳本，避免後續錯誤

# 引入共用 header（開始提示）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

echo -e "\033[1;36m========================="
echo -e "產生 node services 並啟動 docker compose"
echo -e "=========================\033[0m"

# 產生 docker-compose.generated.yml 到 nodes/tmp 目錄
echo -e "\033[1;33m正在建立 docker-compose.generated.yml ...\033[0m"
echo ""
bash ./nodes/generateNodeService.sh
echo ""

# 啟動前詢問使用者是否繼續
echo -ne "\033[1;33m確定要啟動所有 node container？(y/N): "
read confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "\033[1;31m已取消啟動所有 node container。\033[0m"
  end_script
fi

# 啟動所有服務
docker compose -f ../docker-compose.generated.yml up -d

echo -e "\033[1;32m=========================="
echo -e "所有 node container 已啟動！"
echo -e "==========================\033[0m"

end_script
