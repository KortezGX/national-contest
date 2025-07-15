#!/bin/bash
# create_ftp_user.sh
# 用法：./create_ftp_user.sh {username}

# 引入共用 header（模擬 prompt 與指令）
source ./lib/header.sh
# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

if [ -z "$1" ]; then
  echo -e "\033[1;33m========================="
  echo -e "用法：./create_ftp_user.sh {username}"
  echo -e "\033[1;33mError : 請輸入要建立的 FTP 帳號名稱並帶入 username 作為參數"
  echo -e "\033[1;33m=========================\033[0m"
  end_script
fi

USERNAME="$1"
FTP_UID=$(id -u ftpuser)
FTP_GID=$(id -g ftpuser)
HOMEDIR="/home/$USERNAME"

# 建立家目錄
mkdir -p "/home/$USERNAME"
chown $FTP_UID:$FTP_GID "$HOMEDIR"
chmod 755 "$HOMEDIR"

# 依據 MODULE_FOLDERS 環境變數動態建立子目錄
IFS=',' read -ra MODULES <<< "$MODULE_FOLDERS"
for module in "${MODULES[@]}"; do
  module_trimmed=$(echo "$module" | xargs) # 去除空白
  mkdir -p "$HOMEDIR/$module_trimmed"
  chown $FTP_UID:$FTP_GID "$HOMEDIR/$module_trimmed"
  chmod 755 "$HOMEDIR/$module_trimmed"
done

# 建立虛擬帳號（需手動輸入密碼）
pure-pw useradd "$USERNAME" -u $FTP_UID -g $FTP_GID -d "$HOMEDIR" -f /etc/pure-ftpd/passwd/pureftpd.passwd
pure-pw mkdb /etc/pure-ftpd/passwd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd

# 設定 pdb 權限
chown $FTP_UID:$FTP_GID /etc/pure-ftpd/passwd/pureftpd.pdb
chmod 640 /etc/pure-ftpd/passwd/pureftpd.pdb

echo -e "\033[1;32m=========================="
echo -e "帳號 $USERNAME 建立完成！"
echo -e "家目錄：$HOMEDIR"
echo -e "請重新啟動 Pure-FTPd 服務以使更改生效"
echo -e "==========================\033[0m"

end_script
