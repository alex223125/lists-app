<template>
  <v-container bg fill-height grid-list-md text-xs-center>
    <v-row class="content">
      <v-col xs12 class="text-xs-center" mt-5> <h1>Home page</h1> </v-col>
      <v-col xs12 class="text-xs-center" mt-3>
        <p>This is a user's home page</p>
      </v-col>
    </v-row>
  </v-container>
</template>


<style scoped>
.content {
  display: grid;
  flex-wrap: wrap;
  flex: 1 1 auto;
  margin: -12px;
  flex-direction: column;
  justify-content: space-around;
}
</style>


<script>
export default {};
</script>
