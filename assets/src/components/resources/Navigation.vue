<template>
  <div>
    <v-navigation-drawer
      v-model="drawer"
      temporary
      app
    >
      <v-list
        nav
        class="pt-0"
      >
        <v-list-item
          v-for="(link, index) in links"
          :key="index"
          class="grey--text text--darken-1"
          :to="link.route"
        >
          <v-list-item-content>
            <v-list-item-title class="grey--text text--darken-1">
              {{ link.label }}
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item
          v-if="trialUser"
          href="https://assine.folhadirigida.com.br/planofdquestoes/"
          target="_blank"
          class="grey--text text--darken-1"
          @click="signupPageEvent()"
        >
          <v-list-item-content>
            <v-list-item-title class="grey--text text--darken-1">
              Guia do Usuário
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item
          class="grey--text text--darken-1"
          :to="{name: 'profile'}"
        >
          <v-list-item-content>
            <v-list-item-title class="grey--text text--darken-1">
              Perfil
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item
          class="grey--text text--darken-1"
          @click="logout"
        >
          <v-list-item-content>
            <v-list-item-title class="grey--text text--darken-1">
              Sair
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar
      app
      color="#022e49"
      height="76"
      dark
    >
      <v-app-bar-nav-icon
        class="hidden-lg-and-up"
        @click.stop="drawer = !drawer"
      />
      <v-toolbar-title class="pl-0">
        <v-img
          contain
          src="@/assets/logo-white.png"
          height="50"
          max-width="300"
        />
      </v-toolbar-title>

      <v-spacer />

      <v-toolbar-items class="hidden-md-and-down">
        <v-btn v-for="(link, index) in links" :key="index" :to="link.route" text>
          {{ link.label }}
        </v-btn>
      </v-toolbar-items>

      <v-spacer />
      <v-spacer />

      <v-toolbar-items class="hidden-sm-and-down">
        <v-btn
          :to="{ name: 'profile' }"
          dark
          text
        >
          <v-icon>person</v-icon>
        </v-btn>
        <v-btn
          v-if="trialUser"
          href="https://assine.folhadirigida.com.br/planofdquestoes/"
          target="_blank"
          text
          dark
          class="mr-0 pr-0"
          @click="signupPageEvent()"
        >
          Assine aqui
          <v-icon class="ml-2 mr-0 pr-0">
            create
          </v-icon>
        </v-btn>

        <v-btn
          text
          dark
          @click="logout"
        >
          Sair
          <v-icon>exit_to_app</v-icon>
        </v-btn>
      </v-toolbar-items>
    </v-app-bar>
  </div>
</template>

<script>
/* eslint-disable no-console */
import { QUESTOES_AUTH_TOKEN } from "@/constants/settings";

// import Logout from "../auth/Logout";
export default {
  name: "Navigation",
  components: {
    // Logout
  },
  data() {
    return {
      links: [
        { label: "Início", route: { name: "start" } },
        { label: "Simulados Exclusivos", route: { name: "mocks" } },
        { label: "Provas Anteriores", route: { name: "exams" } },
        { label: "Resolver Questões", route: { name: "new_training" } }
      ],
      tenant: {},
      logoSrc: null,
      drawer: null,
      current_user: {},
      loading: 0
    };
  },
  computed: {
    trialUser: function() {
      return this.current_user.account_type == "TRIAL";
    }
  },
  apollo: {
    current_user: {
      query: require("@/graphql/UserAccountTypeQuery.gql"),
      fetchPolicy: "no-cache",       
    }
    // tenant: {
    //   query: TENANT_QUERY,
    //   result(data) {
    //     if (data.error) {
    //       return;
    //     }
    //     if (this.tenant.name) {
    //       document.title = this.tenant.name;
    //     }
    //   },
    //   prefetch: true
    // },
  },
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

          localStorage.removeItem(QUESTOES_AUTH_TOKEN);

          this.$ma.trackEvent({
            category: "Account",
            action: "Logout",
            label: "Logout",
            value: "Logout"
          });
          this.$ma.reset();

          this.$router.push({ name: "login" });
        })
        .catch(error => {
          console.error(error);
        });
    },
    signupPageEvent: function() {
      this.$ma.trackEvent({
        category: "Signup Page",
        action: "Access Signup Page",
        label: "Signup Page",
        value: "Signup Page"
      });
    },
  }
};
</script>

