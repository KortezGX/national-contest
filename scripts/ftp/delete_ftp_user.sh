#!/bin/bash
# delete_ftp_user.sh
# 用法：./delete_ftp_user.sh {username}

# 引入共用 header（模擬 prompt 與指令）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

if [ -z "$1" ]; then
  echo -e "\033[1;33m========================="
  echo -e "用法：./delete_ftp_user.sh {username}"
  echo -e "\033[1;33mError : 請輸入要刪除的 FTP 帳號名稱並帶入 username 作為參數"
  echo -e "\033[1;33m=========================\033[0m"
  
  end_script
fi
USERNAME="$1"
HOMEDIR="$FTP_ROOT/$USERNAME"

echo -ne "\033[1;31m"
read -p "確定要刪除 FTP 帳號 '$USERNAME' 及其所有檔案嗎？(y/N): " confirm
echo -ne "\033[0m"

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo -e "\033[1;33m已取消刪除。\033[0m"
  end_script
fi

# 刪除虛擬帳號（僅當帳號存在時）
if pure-pw show "$USERNAME" -f /etc/pure-ftpd/passwd/pureftpd.passwd > /dev/null 2>&1; then
  pure-pw userdel "$USERNAME" -f /etc/pure-ftpd/passwd/pureftpd.passwd
  pure-pw mkdb /etc/pure-ftpd/passwd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd
  USER_MSG="FTP 帳號已刪除"
else
  USER_MSG="FTP 帳號不存在，略過刪除"
fi

# 刪除家目錄（僅當目錄存在時）
if [ -d "$HOMEDIR" ]; then
  rm -rf "$HOMEDIR"
  DIR_MSG="家目錄已刪除"
else
  DIR_MSG="家目錄不存在，略過刪除"
fi

# 輸出結果訊息，根據內容決定顏色
echo -e "\033[1;32m=========================\033[0m"
echo -e "\033[1;33m$USER_MSG\033[0m"
echo -e "\033[1;33m$DIR_MSG\033[0m"
echo -e "\033[1;32m帳號 $USERNAME 及其家目錄處理完成！\033[0m"
echo -e "\033[1;32m=========================\033[0m"

end_script
