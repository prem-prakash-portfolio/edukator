<template>
  <div>
    <Navigation />

    <v-content>
      <v-container fluid>
        <v-layout row>
          <v-spacer />
          <v-flex md10 lg8>
            <router-view />
          </v-flex>
          <v-spacer />
        </v-layout>
      </v-container>
    </v-content>
  </div>
</template>

<script>
import Navigation from "@/components/resources/Navigation";
export default {
  name: "Logged",
  components: {
    Navigation: Navigation
  }
};
</script>
