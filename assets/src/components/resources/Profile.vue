<template>
  <v-container>
    <v-layout>
      <v-flex
        xs12
        sm8
        offset-sm2
      >
        <ProfileGoals>
          <template v-slot:header>
            <h3 class="headline mb-0">
              Meu objetivo
            </h3>
          </template>
        </ProfileGoals>
      </v-flex>
    </v-layout>
  </v-container>
</template>
<script>
import ProfileGoals from "@/components/resources/ProfileGoals";

export default {
  name: "Profile",
  components: { ProfileGoals }
};
</script>