<template>
  <div>
    <v-row>
      <v-col>
        <v-card class="pa-2">
          <v-card-title primary-title>
            Simulados e Provas iniciadas
          </v-card-title>
          <template v-if="exam_sessions_found">
            <v-card-text v-if="show_search">
              <div class="col-xs-12 col-md-6 offset-md-6 pa-0">
                <v-text-field
                  v-model="search_text"
                  prepend-icon="search"
                  dense
                  single-line
                  placeholder="Encontre aqui os simulados, provas e treinos que você já iniciou"
                />
              </div>
            </v-card-text>
            <v-card-text v-if="noSearchResults" class="text--primary">
              Nenhum resultado encontrado :(
            </v-card-text>

            <ExamList
              :exams="userSessions.exams"
              :session="true"
              :expanded="0"
              @deletedExam="checkEmpty()"
            />
          </template>
          <template v-else>
            <v-card-text class="text--primary">
              Você ainda não possui simulados ou provas em progresso.
            </v-card-text>
            <v-card-actions>
              <v-btn
                :to="{ name: 'exams' }"
                rounded 
                dark
                color="indigo"
                small
              >
                Provas Anteriores
              </v-btn>
              <v-btn
                :to="{ name: 'mocks' }"
                rounded 
                dark
                color="indigo"
                small
              >
                Simulados exclusivos
              </v-btn>
            </v-card-actions>
          </template>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import ExamList from "@/components/resources/ExamList";
import debounce from "lodash/debounce";
export default {
  name: "StartedExams",
  components: {
    ExamList
  },
  data() {
    return {
      pageSize: 30,
      userSessions: {},
      search_text: "",
      current_user: {},
      real_search_text: "",
      show_search: false,
      exam_sessions_found: false
    };
  },
  computed: {
    noSearchResults() {
      return (
        this.userSessions.exams &&
        this.userSessions.exams.length == 0 &&
        this.show_search == true
      )
    }
  },
  watch: {
    search_text: {
      handler: function(before, after) {
        return this.debouncedSearch();
      }
    }
  },
  apollo: {
    userSessions: {
      query: require("@/graphql/UserExamSessionsQuery.gql"),
      fetchPolicy: "no-cache",
      variables() {
        return {
          cursor_after: null,
          size: this.pageSize,
          search_text: this.real_search_text
        };
      },
      result({ data }) {
        if(data.userSessions.exams && data.userSessions.exams.length > 0) {          
          this.exam_sessions_found = true;
          if(data.userSessions.exams.length > 10) {
            this.show_search = true;
          }
        }
      } 
    }
  },
  created: function() {
    this.debouncedSearch = debounce(this.search, 1000);
  },
  methods: {
    search() {
      this.real_search_text = this.search_text;
    },
    checkEmpty() {
      this.$apollo.queries.userSessions.refresh();
      
      if(this.userSessions.exams.length == 1 && !this.show_search){
        this.exam_sessions_found = false;
      } 
    }
  }
};
</script>
