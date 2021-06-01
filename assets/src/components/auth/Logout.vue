<template>
  <a class="white--text" @click="logout">
    Sair
    <v-icon>exit_to_app</v-icon>
  </a>
</template>

<script>
export default {
  name: "Logout",
  methods: {
    logout: function() {
      this.$apollo
        .mutate({
          mutation: require("@/graphql/UserLogoutMutation.gql")
        })
        .then(data => {
          Object.values(this.$apollo.provider.clients).forEach(client =>
            client.cache.reset()
          );
          this.$router.push({ name: "login" });
        })
        .catch(error => {
          console.error(error);
        });
    }
  }
};
</script>
