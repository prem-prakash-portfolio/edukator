<template>
  <p>Carregando...</p>
</template>

<script>
import { QUESTOES_AUTH_TOKEN } from "@/constants/settings";
export default {
  name: "ExternalLogin",
  props: {
    token: String
  },
  created() {
    localStorage.setItem(QUESTOES_AUTH_TOKEN, this.token);
    this.$router.push({ name: "start" });
  }
};
</script>
