/* eslint no-undef:0 */

if (
  process.env.VUE_APP_MIX_ENV === "prod" &&
  !!process.env.VUE_APP_HOTJAR_ID &&
  !!process.env.VUE_APP_HOTJAR_SV
) {
  (function(h, o, t, j, a, r) {
    h.hj =
      h.hj ||
      function() {
        (h.hj.q = h.hj.q || []).push(arguments);
      };
    h._hjSettings = {
      hjid: process.env.VUE_APP_HOTJAR_ID,
      hjsv: process.env.VUE_APP_HOTJAR_SV
    };
    a = o.getElementsByTagName("head")[0];
    r = o.createElement("script");
    r.async = 1;
    r.src = t + h._hjSettings.hjid + j + h._hjSettings.hjsv;
    a.appendChild(r);
  })(window, document, "https://static.hotjar.com/c/hotjar-", ".js?sv=");
}
