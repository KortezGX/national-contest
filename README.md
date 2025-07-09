# Pure-FTPd Docker 專案結構說明

本專案目錄結構如下：

- `ftpdata/`：FTP 實體資料存放區
- `ftp/`：Pure-FTPd 設定資料夾
- `nginx/conf.d/`：Nginx 多網站配置檔案
- `scripts/`：管理腳本
- `docker-compose.yml`：Docker Compose 配置檔
- `.gitignore`：Git 忽略規則

---

## Volume 掛載與憑證設定說明

- 主要掛載路徑與用途請見 `docker-compose.yml`。
- 憑證設定：
  - `ftp/certs/` 目錄會掛載到容器 `/etc/ssl/private`，用於 Pure-FTPd TLS 憑證。
  - 憑證檔案名稱需為 `pure-ftpd.pem`，內容為憑證+私鑰。
  - 是否啟用 TLS 由 `docker-compose.yml` 的 `ADDED_FLAGS` 參數控制：
    - `--tls=2`：強制所有連線必須使用 TLS（建議，較安全）
    - `--tls=1`：允許明文與加密連線
    - `--tls=0`：完全不啟用 TLS（不建議，僅限測試）
  - 相關設定可於 `docker-compose.yml` 的 `environment` 欄位調整。

---

## 各目錄詳細操作與指令

請參閱各目錄下的 README.md 或說明文件，會有對應的管理指令與操作方式。

如有其他問題，請參考官方文件或詢問管理員。
