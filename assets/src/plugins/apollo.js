/* eslint-disable no-console */
import Vue from "vue";
import { ApolloClient } from "apollo-client";
import { InMemoryCache } from "apollo-cache-inmemory";
import { setContext } from 'apollo-link-context';
import { createHttpLink } from "apollo-link-http";
import { ApolloLink } from 'apollo-link';
import { RetryLink } from "apollo-link-retry";
import { onError } from "apollo-link-error";
import VueApollo from "vue-apollo";
import router from "@/router/index";
import { QUESTOES_AUTH_TOKEN } from "@/constants/settings";

// Create the link the Apollo Client will manage between our frontend client and GraphQL server.
// Note that this is setup for development/demo - deployment will require your real URL.

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = localStorage.getItem(QUESTOES_AUTH_TOKEN);
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : "",
    }
  }
});

const retryLink = new RetryLink({
  delay: {
    initial: 300,
    max: Infinity,
    jitter: true
  },
  attempts: {
    max: 3
  }
});

const httpLink = createHttpLink({
  uri: "/api/graphql",
  credentials: "same-origin"
});

// Error Handling
const errorLink = onError(
  ({ graphQLErrors, networkError, operation, forward, response }) => {
    if (graphQLErrors) {
      if (
        graphQLErrors.filter(({ message }) => message === "Unauthenticated")
          .length > 0
      ) {
        localStorage.removeItem(QUESTOES_AUTH_TOKEN);
        router.push({ name: "login" }).catch(err => { });
        window.location.reload(true);
        return null;
      } else {
        return null;
      }
    }
    if (networkError) {
      console.log(`[Network error]: ${networkError}`);
      // localStorage.removeItem(QUESTOES_AUTH_TOKEN);
      // router.push({ name: "login" }).catch(err => { });;
    }
  }
);

const link = ApolloLink.from([
  errorLink,
  authLink,
  retryLink,
  httpLink
])

// Create the apollo client, with the Apollo caching.
const apolloClient = new ApolloClient({
  link: link,
  cache: new InMemoryCache(),
  connectToDevTools: process.env.VUE_APP_MIX_ENV !== "prod"
});

// Install the vue plugin for VueApollo
Vue.use(VueApollo);

export default new VueApollo({
  defaultClient: apolloClient,
  defaultOptions: {
    $loadingKey: "loading"
  }
});
