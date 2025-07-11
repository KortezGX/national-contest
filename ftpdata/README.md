# 此目錄為 FTP 實體資料存放區
每個虛擬帳號對應一個子目錄（如 user1、user2），用於存放該帳號上傳的檔案。

---

## 帳號管理腳本說明

請先進入 Pure-FTPd 容器內再執行腳本：

```sh
docker compose exec -it {service name} bash
```

### 建立帳號
```sh
cd /scripts
./create_ftp_user.sh {username}
```

### 刪除帳號
```sh
cd /scripts
./delete_ftp_user.sh {username}
```

### 修正帳號目錄權限
```sh
cd /scripts
./fix_ftp_user_dir.sh {username}
```

### 查看所有帳號
```sh
cd /scripts
./list_ftp_users.sh
```

> 所有腳本都需在容器內執行，否則權限與路徑可能不正確。