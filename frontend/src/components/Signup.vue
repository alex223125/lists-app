<template>
  <v-container>
    <v-layout row wrap class="signup-layout">
      <v-col class="text-xs-center" mt-5> <h1>Sign Up</h1> </v-col>
      <v-col xs12 sm6 offset-sm3 mt-3>
        <form @submit.prevent="onSignUp">
          <v-col>
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
            <v-flex>
              <v-text-field
                name="confirmPassword"
                label="Confirm Password"
                id="confirmPassword"
                type="password"
                v-model="passwordConfirm"
                :rules="[comparePasswords]"
              ></v-text-field>
            </v-flex>
            <v-flex class="text-xs-center" mt-5>
              <v-btn color="primary" type="submit">
                Sign Up
              </v-btn>
            </v-flex>
          </v-col>
        </form>
      </v-col>
    </v-layout>
  </v-container>
</template>

<style scoped>
  .signup-layout {
    display: grid;
  }
</style>

<script>
import "@/store/index.js";
import { mapActions } from "vuex";
import router from "../router";
export default {
  data() {
    return {
      email: "",
      password: "",
      passwordConfirm: ""
    };
  },
  computed: {
    comparePasswords() {
      return this.password === this.passwordConfirm
        ? true
        : "Passwords don't match";
    }
  },
  methods: {
    ...mapActions(["registerUser"]),
    onSignUp(event) {
      if (this.comparePasswords !== true) {
        return;
      }
      let data = {
        user: {
          email: this.email,
          password: this.password,
        },
      };
      this.registerUser(data);
    }
  }
};
</script>
