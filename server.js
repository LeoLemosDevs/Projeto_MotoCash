const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3000;
const HOST = '0.0.0.0';

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.webmanifest': 'application/manifest+json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.jfif': 'image/jpeg',
  '.ico': 'image/x-icon',
  '.txt': 'text/plain; charset=utf-8',
  '.md': 'text/markdown; charset=utf-8',
  '.sql': 'text/plain; charset=utf-8'
};

const server = http.createServer((req, res) => {
  let rawUrl = req.url || '/';
  let reqPath = decodeURI(rawUrl.split('?')[0]);
  
  // Normaliza caminhos raiz ou favicon
  if (reqPath === '/' || reqPath === '') {
    reqPath = '/index.html';
  } else if (reqPath === '/favicon.ico') {
    reqPath = '/assets/icons/icon-192.png';
  }

  // Sanitiza caminho contra directory traversal
  const safePath = path.normalize(reqPath).replace(/^(\.\.[\/\\])+/, '');
  let filePath = path.join(__dirname, safePath);

  fs.stat(filePath, (err, stats) => {
    // Se o arquivo não existir ou for uma rota SPA (ex: /painel, /moto, /metas)
    if (err || !stats.isFile()) {
      // Se não possui extensão (ex: /painel, /metas), faz fallback para index.html (SPA)
      if (!path.extname(reqPath)) {
        filePath = path.join(__dirname, 'index.html');
      } else {
        console.warn(`[404] Arquivo não encontrado: ${req.url}`);
        res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(`
          <!DOCTYPE html>
          <html lang="pt-BR">
          <head><meta charset="UTF-8"><title>404 - MotoCash Pro</title></head>
          <body style="background:#030508;color:#fff;font-family:sans-serif;text-align:center;padding:50px;">
            <h1 style="color:#00E676;">MotoCash Pro</h1>
            <p>Página não encontrada (${req.url}).</p>
            <p><a href="/" style="color:#00E676;font-weight:bold;">Voltar para o Painel</a></p>
          </body>
          </html>
        `);
        return;
      }
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    const headers = {
      'Content-Type': contentType,
      'Access-Control-Allow-Origin': '*'
    };

    if (filePath.endsWith('sw.js')) {
      headers['Service-Worker-Allowed'] = '/';
      headers['Cache-Control'] = 'no-cache';
    }

    res.writeHead(200, headers);
    fs.createReadStream(filePath).pipe(res);
  });
});

server.listen(PORT, HOST, () => {
  console.log(`MotoCash Pro rodando com sucesso!`);
  console.log(`> No seu computador: http://localhost:${PORT}`);
  console.log(`> No seu celular (na mesma rede Wi-Fi): http://192.169.6.73:${PORT}`);
});
