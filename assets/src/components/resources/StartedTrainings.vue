<template>
  <div>
    <v-row>
      <v-col>
        <v-card class="pa-2">
          <v-card-title>Meus treinos</v-card-title>
          <template v-if="training_sessions_found">
            <v-card-text v-if="show_search">
              <div class="col-xs-12 col-md-6 offset-md-6 pa-0">
                <v-text-field
                  v-model="search_text"
                  prepend-icon="search"
                  dense
                  single-line
                  placeholder="Encontre aqui os treinos que você já iniciou"
                />
              </div>
            </v-card-text>
            <v-card-text v-if="noSearchResults" class="text--primary">
              Nenhum resultado encontrado :(
            </v-card-text>
            <TrainingList :trainings="userSessions.trainings" @deletedTraining="checkEmpty()" />
          </template>
          <template v-else>
            <v-card-text class="text--primary">
              Você ainda não possui treinos em progresso.
            </v-card-text>
            <v-card-actions>
              <v-btn
                :to="{ name: 'new_training' }"
                rounded 
                dark
                color="indigo"
                small
              >
                Criar treino
              </v-btn>
            </v-card-actions>
          </template>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import TrainingList from "@/components/resources/TrainingList";
import debounce from "lodash/debounce";
export default {
  name: "StartedTrainings",
  components: {
    TrainingList
  },
  data() {
    return {
      pageSize: 30,
      userSessions: {},
      search_text: "",
      real_search_text: "",
      show_search: false,
      training_sessions_found: false
    };
  },
  computed: {
    noSearchResults() {
      return (
        this.userSessions.trainings &&
        this.userSessions.trainings.length == 0 &&
        this.show_search == true
      );
    },
    trainingSessionsFound() {
        return(
            this.userSessions.trainings &&
            this.userSessions.trainings.length > 0
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
      query: require("@/graphql/UserTrainingSessionsQuery.gql"),
      fetchPolicy: "no-cache",
      variables() {
        return {
          cursor_after: null,
          size: this.pageSize,
          search_text: this.real_search_text
        };
      },
      result({ data }) {
        if(data.userSessions.trainings && data.userSessions.trainings.length > 0) {          
          this.training_sessions_found = true;
        }
        if(data.userSessions.trainings && data.userSessions.trainings.length > 10) {
            this.show_search = true;
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
      if(this.userSessions.trainings.length == 1 && !this.show_search){
        this.training_sessions_found = false;
      }
    }
  }
};
</script>
