/* eslint no-undef:0 */

if (process.env.VUE_APP_MIX_ENV === "prod" && !!process.env.VUE_APP_YANDEX_ID) {
  (function(m, e, t, r, i, k, a) {
    m[i] =
      m[i] ||
      function() {
        (m[i].a = m[i].a || []).push(arguments);
      };
    m[i].l = 1 * new Date();
    (k = e.createElement(t)),
      (a = e.getElementsByTagName(t)[0]),
      (k.async = 1),
      (k.src = r),
      a.parentNode.insertBefore(k, a);
  })(window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

  ym(process.env.VUE_APP_YANDEX_ID, "init", {
    clickmap: true,
    trackLinks: true,
    accurateTrackBounce: true,
    webvisor: true
  });
}
