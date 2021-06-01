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
        <ValidationObserver
          ref="observer"
          v-slot="{ passes }"
        >
          <form @submit.prevent="passes(doLogin)">
            <v-card class="mt-4 pa-4 pt-0">
              <v-card-title
                primary-title
                class="pt-0"
              >
                <v-img
                  class="mx-auto"
                  src="@/assets/logo-color.png"
                  contain
                  aspect-ratio="2.75"
                />
              </v-card-title>
              <v-card-title>
                <h3 class="headline mb-0">
                  Entrar
                </h3>
              </v-card-title>
              <v-card-text>
                <p class="red--text">
                  Se você já é assinante da folhadirigida.com.br, basta utilizar o mesmo email e senha já cadastrados!
                </p>
                <ValidationProvider
                  v-slot="{ errors }"
                  :rules="{ required: true, email: true }"
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
                    name="password"
                    label="Senha"
                    @click:append="showPassword = !showPassword"
                  />
                </ValidationProvider>
                <a
                  href="https://folhadirigida.com.br/esqueciasenha"
                  target="_blank"
                >Esqueci a senha</a>
              </v-card-text>

              <v-card-actions>
                <v-checkbox
                  v-model="checkbox"
                  label="Permanecer conectado"
                />
                <v-spacer />
                <v-btn
                  :loading="submitting"
                  :disabled="submitting"
                  color="indigo accent-2"
                  class="white--text font-weight-medium"
                  type="submit"
                >
                  Entrar
                </v-btn>
                <!-- <v-btn text color="indigo">Esqueci minha senha</v-btn> -->
              </v-card-actions>
              <v-card-actions>
                <div class="mx-3">
                  Ainda não possui uma assinatura?
                </div>
                <v-spacer />
                <v-btn
                  href="https://assine.folhadirigida.com.br/planofdquestoes/"
                  target="_blank"
                  color="green darken-1"
                  class="white--text font-weight-medium"
                >
                  Assinar
                </v-btn>
              </v-card-actions>
            </v-card>
          </form>
        </ValidationObserver>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { QUESTOES_AUTH_TOKEN } from "@/constants/settings";
import { ValidationObserver } from "vee-validate";
import * as Sentry from "@sentry/browser";
export default {
  name: "Login",
  components: {
    ValidationObserver
  },
  data() {
    return {
      email: "",
      password: "",
      checkbox: true,
      showPassword: false,
      submitting: false
    };
  },
  apollo: {
    current_user: {
      query: require("@/graphql/UserCurrentUserQuery.gql"),
      prefetch: true,
      fetchPolicy: "no-cache",
      result({ data }) {
        if (
          data.current_user !== null &&
          localStorage.getItem(QUESTOES_AUTH_TOKEN) !== null
        ) {
          this.trackUser(
            data.current_user.id,
            data.current_user.name,
            data.current_user.email
          );

          this.$router.push({ name: "start" });
        }
      }
    }
  },
  methods: {
    trackUser: function(id, name, email) {
      this.$ma.identify({ userId: id });
      this.$ma.setUsername(id);
      this.$ma.trackEvent({
        category: "Account",
        action: "Login",
        label: "id",
        value: id
      });
      this.$ma.setSuperProperties({
        userId: id,
        name: name,
        $email: email
      });

      Sentry.configureScope(scope => {
        scope.setUser({
          id: id,
          email: email,
          name: name
        });
      });
    },
    doLogin: function() {
      this.submitting = true;
      const { email, password } = this.$data;
      this.$apollo
        .mutate({
          mutation: require("@/graphql/UserLoginMutation.gql"),
          variables: {
            email,
            password
          }
        })
        .then(({ data }) => {
          this.trackUser(
            data.authenticate.id,
            data.authenticate.name,
            data.authenticate.email
          );

          localStorage.setItem(QUESTOES_AUTH_TOKEN, data.authenticate.token);

          this.$router.push({ name: "start" });
        })
        .catch(({ graphQLErrors }) => {
          graphQLErrors.forEach(error => {
            this.$refs.observer.setErrors({
              [error["key"]]: [error["message"]]
            });
          });
          this.$ma.trackEvent({
            category: "Account",
            action: "Login - Invalid Email or Password",
            label: "Login - Invalid Email or Password",
            value: "Login - Invalid Email or Password",
            properties: {
              userEmail: email
            }
          });
        })
        .finally(() => {
          this.submitting = false;
        });
    }
  }
};
</script>
