#!/bin/bash
# 動態產生 node services 區塊，輸出到 docker-compose.generated.yml

set -e # 指令失敗時立即終止腳本，避免後續錯誤

# 切換到專案根目錄
cd "$(dirname "$0")/../.."
echo -e "\033[1;33m目前工作目錄：$(pwd)\033[0m"

# 統一設定路徑
FTP_PATH="ftpdata" # 使用者上傳檔案目錄
MODULE_NAME="module_c" # Node 模組資料夾名稱
COMPOSE_PATH="docker-compose.yml" # 基礎 docker-compose 檔案路徑
GENERATED_PATH="docker-compose.generated.yml" # 產生的 docker-compose 檔案路徑

NODE_IMAGE="node:22-alpine" # node container 使用的映像檔
NODE_CMD="npx nodemon --watch . --delay 1 index.js" # 啟動 node 服務的指令
NODE_DEPENDS="ftp" # 依賴的 service（docker-compose 依賴）

# 取得所有使用者目錄
USER_DIRS=$(find $FTP_PATH -mindepth 1 -maxdepth 1 -type d | sort)

# 顯示找到的使用者目錄
echo -e "\033[1;36m找到以下使用者目錄：\033[0m"
for USER_PATH in $USER_DIRS; do
  USER=$(basename "$USER_PATH")
  MODULE_PATH="$USER_PATH/$MODULE_NAME"
  if [ -d "$MODULE_PATH" ]; then
    echo -e " \033[1;32m [$USER] $USER_PATH/$MODULE_NAME\033[0m"
  else
    echo -e " \033[0;31m [$USER] $USER_PATH (無 $MODULE_NAME)\033[0m"
  fi
done

# 產生 node services 區塊
NODE_SERVICES=""
for USER_PATH in $USER_DIRS; do
  USER=$(basename "$USER_PATH")
  MODULE_PATH="$USER_PATH/$MODULE_NAME"

  if [ -d "$MODULE_PATH" ]; then
    NODE_SERVICES+="  node-$USER:\n"
    NODE_SERVICES+="    image: $NODE_IMAGE\n"
    NODE_SERVICES+="    container_name: node-$USER\n"
    NODE_SERVICES+="    restart: unless-stopped\n"
    NODE_SERVICES+="    working_dir: /app\n"
    NODE_SERVICES+="    volumes:\n"
    NODE_SERVICES+="      - ./$MODULE_PATH:/app\n"
    NODE_SERVICES+="    depends_on:\n"
    NODE_SERVICES+="      - $NODE_DEPENDS\n"
    NODE_SERVICES+="    expose:\n"
    NODE_SERVICES+="      - \"3000\"\n"
    NODE_SERVICES+="    command: $NODE_CMD\n\n"
  fi
done

# 合併 base compose 與 node services
if [ ! -f "$COMPOSE_PATH" ]; then
  echo -e "\033[0;31m找不到 $COMPOSE_PATH，請確認檔案存在。\033[0m"
  exit 1
fi

# 複製基礎 compose 檔案並添加 node services
cp "$COMPOSE_PATH" "$GENERATED_PATH"
echo -e "$NODE_SERVICES" >> "$GENERATED_PATH"

echo -e "\033[1;33m已產生 $(pwd)/$GENERATED_PATH。\033[0m"
