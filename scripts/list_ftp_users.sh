#!/bin/bash
# list_ftp_users.sh
# 用法：./list_ftp_users.sh

# 引入共用 header（模擬 prompt 與指令）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

PASSWD_FILE="/etc/pure-ftpd/passwd/pureftpd.passwd"

if [ ! -f "$PASSWD_FILE" ]; then
  echo -e "\033[1;31m========================="
  echo -e "找不到帳號資料檔 $PASSWD_FILE"
  echo -e "=========================\033[0m"
  end_script
fi

echo -e "\033[1;34m=========================\033[0m"
echo -e "\033[1;34m帳號資料檔內容：\033[0m"
cat "$PASSWD_FILE"
echo -e "\033[1;34m=========================\033[0m"

echo -e "\033[1;35m=========================\033[0m"
echo -e "\033[1;35m目前已建立的 FTP 虛擬帳號：\033[0m"
cut -d: -f1 "$PASSWD_FILE"
echo -e "\033[1;35m=========================\033[0m"

end_script
