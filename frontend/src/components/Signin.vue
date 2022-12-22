<template>
  <v-container>
    <v-layout row wrap class="signin-layout">
      <v-col xs12 class="text-xs-center" mt-5> <h1>Sign In</h1> </v-col>
      <v-col xs12 sm6 offset-sm3 mt-3>
        <form @submit.prevent="onLogin">
          <v-col column>
            <v-flex>
              <v-text-field
                name="email"
                label="Email"
                id="email"
                type="email"
                v-model="email"
                required
              ></v-text-field>
            </v-flex>
            <v-flex>
              <v-text-field
                name="password"
                label="Password"
                id="password"
                type="password"
                v-model="password"
                required
              ></v-text-field>
            </v-flex>
            <v-flex class="text-xs-center" mt-5>
              <v-btn color="primary" type="submit">Sign In</v-btn>
            </v-flex>
          </v-col>
        </form>
      </v-col>
    </v-layout>
  </v-container>
</template>

<style scoped>
.signin-layout {
  display: grid;
}
</style>

<script>
import {mapActions} from "vuex";

export default {
  data() {
    return {
      email: "",
      password: ""
    };
  },
  methods: {
    ...mapActions(["loginUser"]),
    onLogin(event) {
      let data = {
        user: {
          email: this.email,
          password: this.password,
        },
      };
      this.loginUser(data);
      this.resetData();
    },
    resetData() {
      this.email = "";
      this.password = "";
    }
  }
};
</script>
