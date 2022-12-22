import Router from "vue-router";

import Landing from "../components/Landing.vue";
import Signin from "../components/Signin.vue";
import Signup from "../components/Signup.vue";
import Home from "../components/Home.vue";
import NotFound from "../components/NotFound.vue";
import Lists from "../components/Lists.vue";
import ItemsList from "../components/ItemsList.vue";

import { store } from '@/store/index.js';

const routerOptions = [
  { path: "/", component: "Landing" },
  { path: "/signin", component: "Signin" },
  { path: "/signup", component: "Signup" },
  { path: "/home", component: "Home", meta: { requiresAuth: true } },
  { path: "/lists", component: "Lists" },
  { path: "/:listId/items-list/", name: 'itemsList', component: "ItemsList" },
  {
    path: "/:catchAll(.*)", // Unrecognized path automatically matches 404
    component: "NotFound",
  }
];

const routes = routerOptions.map(route => {
  return {
    ...route,
    component: () => import(`@/components/${route.component}.vue`)
  };
});

const router = new Router({
    mode: "history",
    routes
});

router.beforeEach(async (to, from, next) => {

    let localAuthToken = localStorage.auth_token;
    let cookieExists = (localAuthToken !== "undefined" && localAuthToken !== null);
    if (cookieExists) {
      const auth_token = localStorage.getItem("auth_token");
      const authTokenExists = (auth_token !== "undefined" && auth_token !== null);
      if (authTokenExists) {
        await store.dispatch("loginUserWithToken", { auth_token });
      }
    }

    const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
    const isAuthenticated = store.getters.isLoggedIn

    if (requiresAuth && !isAuthenticated) {
      next("/signin");
    } else {
      next();
    }
  });

export default router