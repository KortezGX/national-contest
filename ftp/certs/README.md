# 憑證放置與 openssl 產生教學

請將你的 `pure-ftpd.pem` 憑證檔案放在此目錄下。

- 例如：certbot 產生的 `fullchain.pem` + `privkey.pem` 合併為 `pure-ftpd.pem`

---

## 使用 openssl 產生自簽憑證

1. 產生私鑰與自簽憑證：
   ```sh
   openssl req -x509 -nodes -newkey rsa:2048 -keyout privkey.pem -out cert.pem -days 365
   ```
2. 合併為 pure-ftpd.pem：
   ```sh
   cat cert.pem privkey.pem > pure-ftpd.pem
   ```
3. 將 `pure-ftpd.pem` 放到本目錄下。
