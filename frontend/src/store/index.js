import Vue from "vue";
import Vuex from "vuex";
import sessionManager from "@/store/modules/session_manager";

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {},
  mutations: {},
  actions: {},
  modules: {
    sessionManager,
  },
});