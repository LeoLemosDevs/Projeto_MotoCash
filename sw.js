// ============================================================================
// MotoCash Pro — Service Worker (Offline-First para Motoboys na Rua)
// ============================================================================

const CACHE_NAME = 'motocash-pro-v1.8.0';

const PRECACHE_URLS = [
  './',
  './index.html',
  '/assets/icons/icon-192.png',
  '/assets/icons/icon-512.png',
  '/assets/icons/icon-maskable.png',
  '/assets/icons/logo.png',
  '/assets/icons/logo-128.png',
  '/img/logo.png',
  '/img/logo moto 300p.png',
  'https://cdn.tailwindcss.com',
  'https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js',
  'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700;800&family=Orbitron:wght@600;700;800;900&display=swap'
];

// Instalação: Pré-carrega recursos essenciais em paralelo
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(async (cache) => {
      await Promise.all(
        PRECACHE_URLS.map((url) =>
          cache.add(url).catch((err) => {
            console.warn('[ServiceWorker] Aviso no pré-cache:', url, err);
          })
        )
      );
    }).then(() => self.skipWaiting())
  );
});

// Ativação: Limpa caches legados
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            console.log('[ServiceWorker] Removendo cache antigo:', key);
            return caches.delete(key);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Interceptação de requisições:
// 1. Navegação (HTML): Network-First para garantir que novas atualizações entrem na hora
// 2. Outros recursos (ícones, fontes): Cache-First para velocidade e uso 100% offline
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') {
    return;
  }

  // Navegação: Network-first com cache fallback
  if (event.request.mode === 'navigate' || event.request.url.includes('index.html')) {
    event.respondWith(
      fetch(event.request)
        .then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200) {
            const copy = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
          }
          return networkResponse;
        })
        .catch(() => caches.match(event.request) || caches.match('./index.html') || caches.match('/'))
    );
    return;
  }

  // Recursos estáticos: Cache-first com network update
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        fetch(event.request).then((networkResponse) => {
          if (networkResponse && networkResponse.status === 200 && networkResponse.type === 'basic') {
            caches.open(CACHE_NAME).then((cache) => cache.put(event.request, networkResponse.clone()));
          }
        }).catch(() => {/* Offline */ });

        return cachedResponse;
      }

      return fetch(event.request).then((networkResponse) => {
        if (!networkResponse || networkResponse.status !== 200) {
          return networkResponse;
        }

        const responseToCache = networkResponse.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseToCache);
        });

        return networkResponse;
      }).catch(() => {
        if (event.request.mode === 'navigate') {
          return caches.match('./index.html') || caches.match('/');
        }
      });
    })
  );
});
