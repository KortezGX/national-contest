# FTP 管理腳本

本目錄下所有腳本需在 pure-ftpd container 內執行。

## 使用方式
## 各腳本用途

- `create_ftp_user.sh`：建立新的 FTP 帳號，並自動建立家目錄及 ENV 內設定的子目錄。
- `delete_ftp_user.sh`：刪除指定 FTP 帳號及其家目錄。
- `fix_ftp_user_dir.sh`：修正指定 FTP 帳號的家目錄權限與結構。
- `list_ftp_users.sh`：列出所有已建立的 FTP 帳號。

1. 進入 pure-ftpd container：

   ```bash
   docker compose exec ftp bash
   ```

2. 執行腳本（範例）：

   ```bash
   cd /scripts
   ./create_ftp_user.sh username
   ./delete_ftp_user.sh username
   ./fix_ftp_user_dir.sh username
   ./list_ftp_users.sh
   ```

> 注意：
> - 這些腳本會操作 /home/ftpusers 及 /etc/pure-ftpd/passwd 目錄，請確保權限正確。
> - 建立/刪除帳號後，建議重啟 pure-ftpd 服務以使更改生效。
