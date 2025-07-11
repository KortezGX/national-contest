// 共用 Node.js 入口，支援多 user module_c
const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();

// 測試用 hello world 路由
app.get('/test', (req, res) => {
  res.send('hello world from Node.js with express');
});

// 例如 /us1_module_c 會對應 /ftpdata/us1/module_c/index.js
app.get('/:user_module_c', async (req, res) => {
  const { user_module_c } = req.params;
  // 解析 user 名稱
  const match = user_module_c.match(/^([a-zA-Z0-9_-]+)_module_c$/);
  if (!match) return res.status(404).send('Invalid path');
  const user = match[1];
  const userModulePath = path.join('/ftpdata', user, 'module_c', 'index.js');

  // 檢查 index.js 是否存在
  if (!fs.existsSync(userModulePath)) {
    return res.status(404).send('User module_c index.js not found');
  }

  // 動態載入並執行 user 的 index.js
  try {
    // 清除 require cache，確保每次都執行最新內容
    delete require.cache[require.resolve(userModulePath)];
    const userModule = require(userModulePath);
    // 假設 user 的 index.js 匯出一個函式 (req, res) => {...}
    if (typeof userModule === 'function') {
      return userModule(req, res);
    } else {
      return res.status(500).send('User module_c index.js must export a function');
    }
  } catch (err) {
    return res.status(500).send('Error executing user module_c: ' + err.message);
  }
});

app.listen(3000, () => {
  console.log('Node 多 user 服務啟動，監聽 3000 port');
});
