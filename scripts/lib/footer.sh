# lib/footer.sh
# 共用結束腳本 function

end_script() {
  printf '\n%.0s' {1..1}
  echo -e "\033[1;31m========================\033[0m"
  echo -e "\033[1;33m🚫 結束腳本執行 🚫\033[0m"
  echo -e "\033[1;31m========================\033[0m"
  exit 1
}
