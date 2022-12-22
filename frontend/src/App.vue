<template>
  <v-app>
    <v-toolbar app class="app-header">
      <v-toolbar-title>
        <router-link class="app-title" to="/" tag="span" style="cursor: pointer">
          {{ appTitle }}
        </router-link>
        <v-btn class="mx-4 lists-button" to="/lists"> Lists </v-btn>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items class="hidden-xs-only">
        <v-btn flat v-for="item in menuItems" :key="item.title" :to="item.path">
          <v-icon class="material-icons" left dark>{{ item.icon }}</v-icon>
          {{ item.title }}
        </v-btn>
        <v-btn flat v-if="isLoggedIn" @click="logoutUser">
          <v-icon left>exit_to_app</v-icon>
          Sign Out
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <v-content>
      <router-view></router-view>
    </v-content>
  </v-app>
</template>

<style scoped>
.app-header {
  max-height: 64px;
}
.theme--light.v-toolbar.v-sheet {
  background-color: blue;
}
.lists-button {
  width: 60px;
  height: 60px;
  padding: 0;
  overflow: hidden;
  border-width: 0;
  outline: none;
  border-radius: 2px;
  transition: background-color .3s;
}
.app-title {
  color: white;
}
</style>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  name: "App",
  data() {
    return {
      appTitle: 'List items App'
    };
  },
  computed: {
    ...mapGetters(["isLoggedIn"]),
    menuItems() {
      if (this.isLoggedIn) {
        return [{ title: "Home", path: "/home", icon: "home" }];
      } else {
        return [
          { title: "Sign Up", path: "/signup", icon: "face" },
          { title: "Sign In", path: "/signin", icon: "lock_open" }
        ];
      }
    }
  },
  methods: {
    ...mapActions(["logoutUser"])
  }
};
</script>

























