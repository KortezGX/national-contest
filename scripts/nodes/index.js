// 預設啟動檔：最簡 hello world
const http = require('http');
const PORT = process.env.PORT || 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(`
    <!DOCTYPE html>
    <html lang="zh-Hant">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>歡迎頁面</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
      <div class="container py-5">
        <div class="row justify-content-center">
          <div class="col-md-8 text-center">
            <h1 class="display-4 mb-4">👋 歡迎使用 Node 服務！</h1>
            <p class="lead">本服務已成功啟動，您可以開始開發自己的應用程式。</p>
            <hr>
            <p class="text-muted">Powered by Node.js & Bootstrap CDN</p>
          </div>
        </div>
      </div>
    </body>
    </html>
  `);
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});