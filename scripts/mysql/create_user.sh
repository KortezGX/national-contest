#!/bin/bash
# create_mysql_user_db.sh
# 用法：./create_mysql_user_db.sh {username}

# 引入共用 footer（結束腳本 function）
source ../lib/footer.sh

if [ -z "$1" ]; then
  echo -e "\033[1;33m========================="
  echo -e "用法：./create_mysql_user_db.sh {username}"
  echo -e "\033[1;33mError : 請輸入要建立的 MySQL 帳號名稱並帶入 username 作為參數"
  echo -e "\033[1;33m=========================\033[0m"
  end_script
fi

USERNAME="$1"
DBNAME="${USERNAME}_db"
PASSWORD="$USERNAME"

echo -ne "\033[1;36m請輸入 MySQL root 密碼: \033[0m"
read -sp "" MYSQL_PWD
export MYSQL_PWD

echo # 強制換行，避免 read -sp 之後的 SQL 查詢結果黏在同一行

# 檢查 MySQL 是否可連線
mysql -u root -e "SELECT 1;" 2>/tmp/mysql_err
if grep -q 'Access denied' /tmp/mysql_err; then
  unset MYSQL_PWD
  echo -e "\n\033[1;31m密碼驗證錯誤！\033[0m"
  rm -f /tmp/mysql_err
  end_script
fi
rm -f /tmp/mysql_err

# 強制將新用戶的認證方式改為 mysql_native_password，避免 public key retrieval 問題
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`$DBNAME\`;
CREATE USER IF NOT EXISTS '$USERNAME'@'%' IDENTIFIED BY '$PASSWORD';
ALTER USER '$USERNAME'@'%' IDENTIFIED WITH mysql_native_password BY '$PASSWORD';
GRANT ALL PRIVILEGES ON \`$DBNAME\`.* TO '$USERNAME'@'%';
FLUSH PRIVILEGES;
EOF

echo -e "\033[1;32m=========================="
echo -e "MySQL user/db 建立完成！"
echo -e "user: $USERNAME"
echo -e "pwd : $PASSWORD"
echo -e "db  : $DBNAME"
echo -e "\033[1;36m新用戶已設定為 mysql_native_password，可直接用密碼登入 MySQL，避免 public key retrieval 問題\033[0m"
echo -e "\033[1;32m==========================\033[0m"

unset MYSQL_PWD
end_script
