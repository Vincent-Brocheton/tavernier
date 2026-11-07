{{flutter_js}}
{{flutter_build_config}}

// Hors ligne d'abord : CanvasKit est servi avec l'application, jamais depuis
// le CDN de Google. Les polices de secours aussi : l'application embarque les
// siennes, et un glyphe absent ne doit pas déclencher de requête externe.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
    fontFallbackBaseUrl: "assets/fallback-fonts/",
  },
});

// Garde l'application chargeable sans réseau (ENF-01).
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("tavernier_sw.js").catch((error) => {
    console.warn("Service worker non enregistré :", error);
  });
}
