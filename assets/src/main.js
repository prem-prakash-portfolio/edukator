import Vue from "vue";
import App from "@/App.vue";
import "@/registerServiceWorker";
import router from "@/router/index";
import vuetify from "@/plugins/vuetify";
import apollo from "@/plugins/apollo";
import Axios from "axios";
import "@/plugins/veevalidate";
import "@/plugins/sentry";
import "@/plugins/vma";
import "@/plugins/vueTour";
import "@/tags/hotjar";
import "@/tags/yandex";
import "material-design-icons-iconfont/dist/material-design-icons.css";

Vue.config.productionTip = false;

Vue.prototype.$http = Axios;

new Vue({
  router,
  vuetify,
  apolloProvider: apollo,
  render: h => h(App)
}).$mount("#app");
