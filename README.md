# Pure-FTPd Docker 專案結構說明

本專案目錄結構如下：


- `ftpdata/`：所有 FTP 使用者的家目錄與檔案，對應容器 `/home`，每個 user 都有獨立資料夾。
- `ftp/`：Pure-FTPd 相關設定、密碼資料庫、TLS 憑證等，對應容器 `/etc/pure-ftpd`、`/etc/ssl/private`。
- `nginx/conf.d/`：Nginx 虛擬主機設定檔，支援多 user、動態 node/laravel 反向代理。
- `scripts/`：所有管理腳本，分為 `ftp/`（FTP 帳號管理）、`nodes/`（node 服務管理）、`lib/`（共用函式庫）。
- `docker-compose.yml`：主要 Docker Compose 配置，定義所有服務、volume 掛載、環境變數等。
- `.env`：專案環境變數，所有路徑、主機、模組名稱都可在此自訂。
- `.gitignore`：Git 忽略規則，避免追蹤敏感或自動產生檔案。

---

## Volume 掛載 .env 設定與憑證設定說明

### FTP 服務掛載
- 使用者家目錄 `PATH_DATA` 掛載到容器 `/home` 。
- 密碼資料庫、TLS 憑證等 `PATH_FTP` 掛載到 `/etc/pure-ftpd`、`/etc/ssl/private` 。
- 憑證檔案需為 `pure-ftpd.pem`，內容為憑證+私鑰，設定方式參考 `ftp/cert/README.md` 。

- TLS 啟用方式由 `.env` 的 `FTP_TLS` 控制：
  - 設為 2：強制所有連線必須使用 TLS（建議，最安全）
  - 設為 1：允許明文與加密連線（兼容舊用戶端，但不建議）
  - 設為 0：完全不啟用 TLS（僅限測試，極度不安全）

> 建議正式環境設為 2，確保所有 FTP 傳輸都加密。

### Laravel 服務掛載
- 所有 user 的 web 目錄 `PATH_DATA` 掛載到容器 `/var/www/html` 。
- Laravel 服務只在 docker network 內開放 9000 port，nginx 會用 fastcgi_pass 連線。

### Node 服務掛載
- 每個 user 的 node module 目錄 `PATH_DATA` 掛載到 node container 的 `/app`，可用 `.env` 設定 `MODULE_NODE` 與 `PATH_DATA`。
- node 服務由 `scripts/upWithNodeService.sh` 動態產生，統一從容器內 3000 port expose。

> 所有 volume 掛載路徑、憑證、模組名稱等都可在 `.env` 設定，請依需求調整。

---

## 使用說明

### 一般（不含 node）操作流程

1. 啟動基本服務：
   ```bash
   docker compose up -d
   ```
   會啟動 pure-ftpd、nginx、mysql、laravel 等基本服務。

2. FTP 帳號管理、目錄權限修正等，請進入 pure-ftpd container 執行 scripts 目錄下的腳本。
   詳細用法請見 `scripts/ftp/README.md`。

3. 其他管理指令請參閱各目錄下的 README.md。

### 含 node 動態服務操作流程

1. 產生 node 服務：
   ```bash
   ./scripts/upWithNodeService.sh
   ```
   會自動偵測所有 user 資料夾是否有 .env 設定的 node env folder，產生對應的 node container 並更新 docker-compose.generated.yml。

2. 停止並移除所有 node 服務：
   ```bash
   ./scripts/downWithNodeService.sh
   ```

3. 其他 node 服務管理指令請見 `scripts/actionWithNodeService.sh`。

---

各目錄下均有 README.md 或說明文件，請依需求參閱。
