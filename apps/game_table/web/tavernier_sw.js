// Hors ligne d'abord (ENF-01) : l'application reste chargeable sans réseau.
// Réseau d'abord, pour toujours servir la dernière version ; le cache prend le
// relais quand le réseau manque. Les données vivent dans la base locale, pas ici.
'use strict';

const CACHE = 'tavernier-shell-v1';

// Coquille de l'application, mise en cache dès l'installation : sans elle,
// un premier rechargement hors ligne échouerait.
const SHELL = [
  './',
  'index.html',
  'flutter_bootstrap.js',
  'main.dart.js',
  'manifest.json',
  'favicon.png',
  'sqlite3.wasm',
  'drift_worker.js',
  'canvaskit/canvaskit.js',
  'canvaskit/canvaskit.wasm',
  'canvaskit/chromium/canvaskit.js',
  'canvaskit/chromium/canvaskit.wasm',
  'assets/FontManifest.json',
  'assets/AssetManifest.bin.json',
  'assets/fonts/MaterialIcons-Regular.otf',
  'assets/packages/dnd_ui_kit/fonts/Cinzel.ttf',
  'assets/packages/dnd_ui_kit/fonts/RobotoFlex.ttf',
  'assets/assets/packs/srd-5.2.1-fr.dndpack',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE);
      // Un fichier absent d'une plateforme ne bloque pas l'installation.
      await Promise.allSettled(SHELL.map((path) => cache.add(path)));
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      for (const name of await caches.keys()) {
        if (name !== CACHE) await caches.delete(name);
      }
      await self.clients.claim();
    })(),
  );
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;
  if (new URL(request.url).origin !== self.location.origin) return;
  event.respondWith(
    (async () => {
      const cache = await caches.open(CACHE);
      try {
        const response = await fetch(request);
        if (response.ok) await cache.put(request, response.clone());
        return response;
      } catch (error) {
        const cached = await cache.match(request, { ignoreSearch: true });
        if (cached) return cached;
        throw error;
      }
    })(),
  );
});
