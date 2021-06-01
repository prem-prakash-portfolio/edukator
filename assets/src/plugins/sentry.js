import Vue from "vue";
import * as Sentry from "@sentry/browser";
import * as Integrations from "@sentry/integrations";

// Sentry - begin
if (process.env.VUE_APP_MIX_ENV === "prod" && !!process.env.VUE_APP_SENTRY_DSN_PUBLIC) {
  Sentry.init({
    release: process.env.VUE_APP_SOURCE_VERSION,
    dsn: process.env.VUE_APP_SENTRY_DSN_PUBLIC,
    integrations: [new Integrations.Vue({ Vue, attachProps: true })]
  });
}
// Sentry - begin
