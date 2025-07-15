#!/bin/bash
# delete_mysql_user_db.sh
# 用法：./delete_mysql_user_db.sh {username}

# 引入共用 footer（結束腳本 function）
source ./lib/footer.sh

if [ -z "$1" ]; then
  echo -e "\033[1;33m========================="
  echo -e "用法：./delete_mysql_user_db.sh {username}"
  echo -e "\033[1;33mError : 請輸入要刪除的 MySQL 帳號名稱並帶入 username 作為參數"
  echo -e "\033[1;33m=========================\033[0m"
  end_script
fi

USERNAME="$1"
DBNAME="${USERNAME}_db"

echo -ne "\033[1;36m請輸入 MySQL root 密碼: \033[0m"
read -sp "" MYSQL_PWD
export MYSQL_PWD

echo # 強制換行，避免 read -sp 之後的 SQL 查詢結果黏在同一行

# 檢查 MySQL 是否可連線
mysql -u root -N -s -e "SELECT 1;" 1>/dev/null 2>/tmp/mysql_err
if grep -q 'Access denied' /tmp/mysql_err; then
  unset MYSQL_PWD
  echo -e "\n\033[1;31m密碼驗證錯誤！\033[0m"
  rm -f /tmp/mysql_err
  end_script
fi
rm -f /tmp/mysql_err

mysql -u root <<EOF
DROP DATABASE IF EXISTS \`$DBNAME\`;
DROP USER IF EXISTS '$USERNAME'@'%';
FLUSH PRIVILEGES;
EOF

echo -e "\033[1;32m=========================="
echo -e "MySQL user/db 刪除完成！"
echo -e "user: $USERNAME"
echo -e "db  : $DBNAME"
echo -e "==========================\033[0m"

unset MYSQL_PWD
end_script
