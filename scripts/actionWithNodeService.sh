#!/bin/bash
# 用法：./actionWithNodeService.sh <docker compose 參數>
# 例如：./actionWithNodeService.sh ps -a

COMPOSE_FILE="../docker-compose.generated.yml"

# 檢查是否有輸入參數
if [ $# -eq 0 ]; then
  echo -e "\033[1;33m請輸入 docker compose 參數，例如：\033[0m"
  echo -e "\033[1;36m  ./actionWithNodeService.sh ps -a\033[0m"
  exit 1
fi

# 檢查 docker-compose.generated.yml 是否存在
if [ ! -f "$COMPOSE_FILE" ]; then
  echo -e "\033[0;31m找不到 $COMPOSE_FILE，請先產生 node services。\033[0m"
  exit 1
fi

echo -e "\033[1;36m [exec] docker compose -f $COMPOSE_FILE $@\033[0m"
docker compose -f "$COMPOSE_FILE" "$@"
