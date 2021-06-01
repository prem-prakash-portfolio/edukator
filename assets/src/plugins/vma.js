import Vue from "vue";
import router from "@/router/index";
import VueMultianalytics from "vue-multianalytics";

import LocalTracker from "@/plugins/local_tracker";

VueMultianalytics.addCustomModule('localTracker', LocalTracker)

// VueMultianalytics - begin
let mixpanelConfig = {
  token: process.env.VUE_APP_MIXPANEL_TOKEN ? process.env.VUE_APP_MIXPANEL_TOKEN : "arrodeio",
  debug: process.env.VUE_APP_MIX_ENV !== "prod" || !!process.env.VUE_APP_DEBUG_ANALYTICS
};

let gaConfig = {
  appName: "Edukator - Folha Dirigida", // Mandatory
  appVersion: "0.1", // Mandatory
  trackingId: process.env.VUE_APP_GA_ID ? process.env.VUE_APP_GA_ID : "arrodeio", // Mandatory
  options: {
    siteSpeedSampleRate: 10
  },
  debug: process.env.VUE_APP_MIX_ENV !== "prod" || !!process.env.VUE_APP_DEBUG_ANALYTICS // Whether or not display console logs debugs (optional)
};

Vue.use(VueMultianalytics, {
  routing: {
    vueRouter: router, //  Pass the router instance to automatically sync with router (optional)
    ignoredViews: ['external_login']
  },
  modules: {
    mixpanel: mixpanelConfig,
    ga: gaConfig,
    localTracker: {}
  }
});
// VueMultianalytics - end
