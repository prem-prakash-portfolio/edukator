<!--
<template>
  <v-container>
    <v-layout>
      <v-flex
        xs12
        offset-xs0
        sm8
        offset-sm2
        md6
        offset-md3
        lg4
        offset-lg4
      >
        <ValidationObserver ref="observer" v-slot="{ passes }">
          <form @submit.prevent="passes(doSignup)">
            <v-card class="mt-4 pa-4 pt-0">
              <v-card-title primary-title class="pt-0">
                <v-img class="mx-auto" src="/images/logo-color.png" contain aspect-ratio="2.75" />
              </v-card-title>
              <v-card-title>
                <h3 class="headline mb-0">
                  Criar conta
                </h3>
              </v-card-title>

              <v-card-text>
                <ValidationProvider
                  :rules="{ required: true }"
                  v-slot="{ errors }"
                  :debounce="1000"
                  vid="name"
                  name="Nome"
                >
                  <v-text-field v-model="name" :error-messages="errors" name="name" label="Nome" />
                </ValidationProvider>

                <ValidationProvider
                  :rules="{ required: true, email: true }"
                  v-slot="{ errors }"
                  :debounce="1000"
                  vid="email"
                  name="Email"
                >
                  <v-text-field
                    v-model="email"
                    :error-messages="errors"
                    name="email"
                    label="E-mail"
                  />
                </ValidationProvider>

                <ValidationProvider
                  :rules="{ required: true }"
                  v-slot="{ errors }"
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
                    @click:append="showPassword = !showPassword"
                    name="password"
                    label="Senha"
                  />
                </ValidationProvider>
              </v-card-text>

              <v-card-actions>
                <v-spacer />
                <v-btn
                  :disabled="submitting"
                  color="indigo accent-2"
                  class="white--text font-weight-medium"
                  type="submit"
                >
                  Criar Conta
                </v-btn>
              </v-card-actions>

              <v-card-actions>
                <div class="mx-3">
                  Já possui uma conta?
                </div>

                <v-btn
                  :to="{ name: 'login' }"
                  color="green darken-1"
                  class="white--text font-weight-medium"
                >
                  Entrar
                </v-btn>
                <v-spacer />
              </v-card-actions>
            </v-card>
          </form>
        </ValidationObserver>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { SIGNUP, CURRENT_USER } from "constants/graphql";
import { ValidationObserver } from "vee-validate";
import * as Sentry from "@sentry/browser";
export default {
  name: "Signup",
  components: {
    ValidationObserver
  },
  data() {
    return {
      name: "",
      email: "",
      password: "",
      checkbox: true,
      showPassword: false,
      submitting: false
    };
  },
  apollo: {
    current_user: {
      query: CURRENT_USER,
      prefetch: true,
      result({ data }) {
        if (data.current_user !== null) {
          this.$router.push({ name: "mocks" });
        }
      }
    }
  },
  methods: {
    doSignup: function() {
      this.submitting = true;
      const { name, email, password } = this.$data;
      this.$apollo
        .mutate({
          mutation: SIGNUP,
          variables: {
            name,
            email,
            password
          }
        })
        .then(({ data }) => {
          this.$ma.setUsername(data.signup.id);
          this.$ma.setAlias(data.signup.id);
          this.$ma.trackEvent({
            category: "Account",
            action: "Created account",
            label: "email",
            value: data.signup.email
          });
          this.$ma.setUserProperties({
            userId: data.signup.id,
            name: data.signup.name,
            $email: data.signup.email
          });

          Sentry.configureScope(scope => {
            scope.setUser({
              id: data.signup.id,
              email: data.signup.email,
              name: data.signup.name
            });
          });

          this.$router.push({ name: "mocks" });
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
-->