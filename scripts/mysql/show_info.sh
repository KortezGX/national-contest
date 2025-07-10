#!/bin/bash
# show_mysql_users_dbs.sh
# 用法：./show_mysql_users_dbs.sh

# 引入共用 footer（結束腳本 function）
source ../lib/footer.sh

echo -ne "\033[1;36m請輸入 MySQL root 密碼: \033[0m"
read -sp "" MYSQL_PWD
export MYSQL_PWD

echo # 強制換行，避免 read -sp 之後的 SQL 查詢結果黏在同一行

# 檢查 MySQL 是否可連線（不顯示查詢結果）
mysql -u root -N -s -e "SELECT 1;" 1>/dev/null 2>/tmp/mysql_err
if grep -q 'Access denied' /tmp/mysql_err; then
  unset MYSQL_PWD
  echo -e "\n\033[1;31m密碼驗證錯誤！\033[0m"
  rm -f /tmp/mysql_err
  end_script
fi
rm -f /tmp/mysql_err

# 查詢 MySQL 使用者
echo -e "\n\033[1;34m=========================="
echo -e "目前所有 MySQL 使用者："
echo -e "==========================\033[0m"
mysql -u root -e "SELECT User, Host FROM mysql.user;"

# 查詢 MySQL 資料庫
echo -e "\033[1;34m=========================="
echo -e "目前所有 Database："
echo -e "==========================\033[0m"
mysql -u root -e "SHOW DATABASES;"

echo -e "\033[1;32m=========================="
echo -e "查詢完成"
echo -e "==========================\033[0m"

unset MYSQL_PWD
end_script
