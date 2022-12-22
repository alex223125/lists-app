import Vue from "vue";
import App from "./App.vue";
import { store } from './store';
import router from "./router";
import VueRouter from "vue-router";
import "material-design-icons-iconfont/dist/material-design-icons.css";
import "vuetify/dist/vuetify.min.css";
import vuetify from '@/plugins/vuetify'

Vue.use(VueRouter);

new Vue({
  store: store,
  vuetify : vuetify,
  router: router,
  render: h => h(App)
}).$mount("#app");