<template>
  <v-app style="background: rgba(0,0,0,0);">
    <router-view />
  </v-app>
</template>

<style>
body {
  font-family: Roboto, Helvetica, Arial, sans-serif;
  background-image: url("./assets/background.jpg");
  background-size: cover;
}
  .v-card__text, .v-card__title {
    word-break: normal !important;
  }

</style>
