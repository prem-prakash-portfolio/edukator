<template>
  <ValidationObserver ref="observer" v-slot="{ passes }">
    <form @submit.prevent="passes(changePassword)">
      <v-card>
        <v-card-text>
          <ValidationProvider
            v-slot="{ errors }"
            :rules="{ required: true }"
            vid="current_password"
            name="Senha atual"
          >
            <v-text-field
              v-model="current_password"
              :append-icon="
                showPassword ? 'visibility' : 'visibility_off'
              "
              :error-messages="errors"
              :type="showPassword ? 'text' : 'password'"
              label="Digite sua senha atual"
              name="current_password"
              @click:append="showPassword = !showPassword"
            />
          </ValidationProvider>

          <ValidationProvider
            v-slot="{ errors }"
            :rules="{ required: true }"
            vid="password"
            name="Senha"
          >
            <v-text-field
              v-model="password"
              :append-icon="
                showPassword ? 'visibility' : 'visibility_off'
              "
              :error-messages="errors"
              :type="showPassword ? 'text' : 'password'"
              label="Nova senha"
              name="password"
              @click:append="showPassword = !showPassword"
            />
          </ValidationProvider>
          <ValidationProvider
            v-slot="{ errors }"
            :rules="{ required: true }"
            vid="password_confirmation"
            name="Confirmação da senha"
          >
            <v-text-field
              v-model="password_confirmation"
              :append-icon="
                showPassword ? 'visibility' : 'visibility_off'
              "
              :error-messages="errors"
              :type="showPassword ? 'text' : 'password'"
              label="Confirme sua nova senha"
              name="password_confirmation"
              @click:append="showPassword = !showPassword"
            />
          </ValidationProvider>
        </v-card-text>

        <v-card-text>{{ message }}</v-card-text>

        <v-card-actions>
          <v-spacer />
          <v-btn
            :loading="submitting"
            :disabled="submitting"
            color="indigo accent-2"
            class="white--text font-weight-medium"
            type="submit"
          >
            Mudar Senha
          </v-btn>
        </v-card-actions>
      </v-card>
    </form>
  </ValidationObserver>
</template>
<script>
import { ValidationObserver } from "vee-validate";

export default {
  name: "Profile",
  components: { ValidationObserver },
  data() {
    return {
      current_password: "",
      password: "",
      password_confirmation: "",
      showPassword: false,
      submitting: false,
      message: ""
    };
  },
  methods: {
    changePassword: function() {
      this.submitting = true;
      this.$apollo
        .mutate({
          mutation: require("@/graphql/UserUpdatePasswordMutation.gql"),
          variables: {
            current_password: this.current_password,
            password: this.password,
            password_confirmation: this.password_confirmation
          }
        })
        .then(data => {
          this.message = "Senha alterada com sucesso";
          //this.password = "";
        })
        .catch(({ graphQLErrors }) => {
          graphQLErrors.forEach(error => {
            this.$refs.observer.setErrors({
              [error["key"]]: [error["message"]]
            });
          });
        })
        .finally(() => {
          this.submitting = false;
        });
    }
  }
};
</script>