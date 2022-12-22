<template>
  <v-container fluid>
    <v-layout class="content-layout" row wrap>
      <v-flex xs12 class="text-xs-center" mt-5>
        <h1>Welcome to Todo list App</h1>
      </v-flex>
      <v-flex xs12 sm6 offset-sm3 mt-3>
        <blockquote class="blockquote text-xs-center">
          It's a basic Single Page application <br />
        </blockquote>
      </v-flex>
      <v-flex xs12 sm6 offset-sm3 class="text-xs-center" mt-5>
        <v-btn color="primary" to="/signup">Sign Up</v-btn>
        <v-btn to="/signin">Sign In</v-btn>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
export default {};
</script>

<style scoped>
.content-layout {
  display: grid;
  flex-direction: column;
  justify-content: center;
}
</style>
