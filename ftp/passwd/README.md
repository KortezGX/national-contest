# 此目錄為 Pure-FTPd 虛擬帳號資料庫存放區

- 主要存放 `pureftpd.passwd`（帳號文字檔）與 `pureftpd.pdb`（帳號資料庫檔）。
- 請勿將此目錄加入版本控管（在 .gitignore 設定）。

## 原生帳號管理指令

請進入容器後，使用 pure-pw 指令管理帳號：

```sh
# 建立帳號（需互動式輸入密碼）
pure-pw useradd {username} -u ftpuser -g ftpuser -d /home/ftpusers/{username} -f /etc/pure-ftpd/passwd/pureftpd.passwd
# 刪除帳號
pure-pw userdel {username} -f /etc/pure-ftpd/passwd/pureftpd.passwd
# 修改密碼
pure-pw passwd {username} -f /etc/pure-ftpd/passwd/pureftpd.passwd
```

> 每次異動帳號（新增、刪除、修改密碼）後，**都必須執行下列指令，才會正式 commit 並讓修改生效：**
>
> ```sh
> pure-pw mkdb /etc/pure-ftpd/passwd/pureftpd.pdb -f /etc/pure-ftpd/passwd/pureftpd.passwd
> ```

- 所有帳號異動都會自動更新本目錄下的帳號資料檔案。
