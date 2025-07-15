#!/bin/bash
# fix_ftp_user_dir.sh
# 用法：./fix_ftp_user_dir.sh {username}

# 引入共用 header（模擬 prompt 與指令）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

if [ -z "$1" ]; then
  echo -e "\033[1;33m========================="
  echo -e "用法：./fix_ftp_user_dir.sh {username}"
  echo -e "Error : 請輸入要修正的 FTP 帳號名稱並帶入 username 作為參數"
  echo -e "結束腳本執行"
  echo -e "=========================\033[0m"
  end_script
fi

USERNAME="$1"
FTP_UID=$(id -u ftpuser)
FTP_GID=$(id -g ftpuser)
HOMEDIR="/home/$USERNAME"

mkdir -p "$HOMEDIR"
chown $FTP_UID:$FTP_GID "$HOMEDIR"
chmod 755 "$HOMEDIR"

echo -e "\033[1;32m========================="
echo -e "$HOMEDIR 權限已修正為 $FTP_UID:$FTP_GID 755"
echo -e "=========================\033[0m"

end_script
