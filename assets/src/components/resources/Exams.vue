<template>
  <v-card class="pa-2">
    <v-tour name="searchTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallbacks" />
    <v-card-title primary-title>
      <v-container fluid>
        <v-layout wrap>
          <v-flex xs12 md6>
            <h2 class="headline">
              {{ headline }}
            </h2>
          </v-flex>
          <v-flex xs12 md6>
            <v-text-field id="step-0" v-model="search_text" prepend-icon="search" single-line />
          </v-flex>
        </v-layout>
      </v-container>
    </v-card-title>
    <v-card-text class="text-right">
      <div>{{ examsPage.total_count }} itens</div>
    </v-card-text>

    <template v-if="noResults">
      <v-card-text>
        <p class="text-center headline">
          Nenhum resultado encontrado
        </p>
      </v-card-text>
    </template>
    <template v-else>
      <ExamList :exam_type="exam_type" :exams="examsPage.exams" />
    </template>

    <div class="text-center py-4">
      <v-progress-circular v-if="loading" indeterminate color="purple" />
    </div>
  </v-card>
</template>
<script>
import ExamList from "@/components/resources/ExamList";
export default {
  name: "Exams",
  components: {
    ExamList
  },
  props: {
    headline: String,
    exam_type: String
  },
  data() {
    return {
      pageSize: 30,
      examsPage: {},
      search_text: "",
      loading: 0,
      current_user: {},
      noResults: false,
      loadingMore: false,
      tourSteps: [
        {
          target: "#step-0",
          content:
            "Aqui você pode pesquisar por palavras-chave da prova desejada.",
          params: {
            enableScrolling: false
          }
        }
      ],
      tourOptions: {
        useKeyboardNavigation: false,
        labels: {
          buttonSkip: "Pular",
          buttonPrevious: "Anterior",
          buttonNext: "Próximo",
          buttonStop: "Fim"
        }
      },
      tourCallbacks: {
        onStop: this.searchTourOver
      }
    };
  },
  computed: {
    shouldFetchMore() {
      return !this.loading && this.examsPage.has_more;
    }
  },
  watch: {
    search_text: {
      handler: function(before, after) {
        this.loadingMore = false;
      }
    }
  },
  mounted() {
    this.scroll();
  },
  beforeRouteLeave(to, from, next) {
    this.search_text = "";
    this.fetchMore();
    next();
  },
  apollo: {
    examsPage: {
      query: require("@/graphql/ExamsQuery.gql"),
      variables() {
        return {
          cursor_after: null,
          size: this.pageSize,
          type: this.exam_type,
          search_text: this.search_text
        };
      },
      throttle: 2000,
      result({ data }) {
        if (this.search_text !== "" && !this.loadingMore) {
          this.$ma.trackEvent({
            category: "List of Exams",
            action: `Search ${this.exam_type}`,
            label: "search term",
            value: this.search_text,
            properties: { totalResults: data.examsPage.total_count }
          });
        }
        if (data.examsPage.total_count === 0) {
          this.noResults = true;
        } else {
          this.noResults = false;
        }
      }
    },
    current_user: {
      query: require("@/graphql/UserProductTourQuery.gql"),
      fetchPolicy: "no-cache",

      result({ data }) {
        if (!data.current_user.viewed_tours.search) {
          this.$tours["searchTour"].start();
        }
      }
    }
  },
  methods: {
    scroll() {
      window.onscroll = () => {
        let bottomOfWindow =
          document.documentElement.scrollTop + window.innerHeight ===
            document.documentElement.offsetHeight ||
          document.body.scrollTop + window.innerHeight ===
            document.body.offsetHeight;

        if (bottomOfWindow) {
          this.fetchMore();
        }
      };
    },
    fetchMore() {
      if (!this.$apollo.queries.examsPage || !this.shouldFetchMore) {
        return;
      }

      this.loadingMore = true;

      const variables = {
        size: this.pageSize,
        cursor_after: this.examsPage.cursor_after,
        search_text: this.search_text
      };

      this.$apollo.queries.examsPage
        .fetchMore({
          variables,
          updateQuery: (previousResult, { fetchMoreResult }) => {
            const newExams = fetchMoreResult.examsPage.exams.filter(
              n =>
                previousResult.examsPage.exams.findIndex(e => e.id == n.id) ==
                -1
            );

            let has_more = fetchMoreResult.examsPage.has_more;
            const cursor_after = fetchMoreResult.examsPage.cursor_after;
            const total_count = fetchMoreResult.examsPage.total_count;

            return {
              examsPage: {
                __typename: previousResult.examsPage.__typename,
                exams: [...previousResult.examsPage.exams, ...newExams],
                has_more,
                cursor_after,
                total_count
              }
            };
          }
        })
        .catch(error => {})
        .finally(() => {
          this.loadingMore = true;
          this.$ma.trackEvent({
            category: "List of Exams",
            action: `Infinite Scrolled list of Exams ${this.exam_type}`,
            label: "exam type",
            value: this.exam_type
          });
        });
    },
    searchTourOver() {
      this.current_user.viewed_tours.search = true;
      this.$apollo.mutate({
        mutation: require("@/graphql/UserFinishTourMutation.gql"),
        variables: {
          viewed_tours: { search: true }
        }
      });
    }
  }
};
</script>
