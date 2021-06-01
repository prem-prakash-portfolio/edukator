<template>
  <v-card class="pa-2">
    <v-card-title>
      <h2 class="headline">
        Resolver Questões
      </h2>
    </v-card-title>
    <v-progress-linear v-if="isLoading" indeterminate />
    <v-form v-if="question_filter">
      <v-container grid-list-xl>
        <v-layout row wrap>
          <v-flex xs12 lg4>
            <v-radio-group v-model="answered_questions" class="ma-0 pa-0">
              <v-radio
                v-for="(option, index) in answeredOptions"
                :key="index"
                :value="option.value"
                class="caption"
              >
                <template v-slot:label>
                  <span
                    :class="
                      `${
                        $vuetify.breakpoint.xs ? 'caption' : ''
                      } font-weight-medium`
                    "
                  >{{ option.label }}</span>
                </template>
              </v-radio>
            </v-radio-group>
          </v-flex>
          <v-flex xs12 lg4>
            <v-radio-group
              v-if="answered_questions == 'answered'"
              v-model="correct_questions"
              class="ma-0 pa-0"
            >
              <v-radio
                v-for="(option, index) in correctQuestionsOptions"
                :key="index"
                :value="option.value"
              >
                <template v-slot:label>
                  <span
                    :class="
                      `${
                        $vuetify.breakpoint.xs ? 'caption' : ''
                      } font-weight-medium`
                    "
                  >{{ option.label }}</span>
                </template>
              </v-radio>
            </v-radio-group>
          </v-flex>
        </v-layout>
        <v-layout id="step-0" row wrap>
          <template v-for="(field, ffi) in filterFields">
            <v-flex :key="ffi" xs12 lg4>
              <v-combobox
                v-model="selected[field.name]"
                :items="question_filter[field.name]"
                :name="field.name"
                :label="field.label"
                multiple
                deletable-chips
                dense
                clearable
                small-chips
                autocomplete="false"
                item-text="name"
                item-value="id"
              />
              <!-- <multiselect
                v-model="selected[field.name]"
                :options="question_filter[field.name]"
                label="name"
                name="organizations"
                selectedLabel="Selecionado"
                trackBy="id"
                :placeholder="field.label"
                multiple
                :autocomplete="`new-${field.name}`"
                :closeOnSelect="false"
                selectLabel="Pressione Enter para selecionar"
                deselectLabel="Pressione Enter para remover"
              >
                <template slot="noResult">
                  Nenhum item encontrado
                </template>
              </multiselect>-->
            </v-flex>
          </template>
        </v-layout>
        <v-layout>
          <v-flex xs12>
            <template v-if="question_filter.total_questions == 0">
              Nenhuma questão encontrada
            </template>
            <template v-else-if="question_filter.total_questions < minTrainingQuestions">
              Menos que {{ minTrainingQuestions }} questões encontradas, amplie
              sua busca para continuar
            </template>
            <template v-else>
              {{ question_filter.total_questions | formatNumber }} questões
              encontradas
            </template>
          </v-flex>
        </v-layout>
      </v-container>

      <v-card-actions class="mx-5 py-5">
        <v-spacer />
        <v-dialog v-model="dialog" persistent scrollable width="600">
          <template v-slot:activator="{ on }">
            <v-btn
              id="step-1"
              :disabled="
                question_filter.total_questions < minTrainingQuestions ||
                  isLoading
              "
              :loading="isLoading"
              color="indigo accent-2"
              ripple
              class="white--text font-weight-medium"
              v-on="on"
            >
              Resolver Questões
            </v-btn>
          </template>

          <ValidationObserver ref="observer" v-slot="{ passes }">
            <form @submit.prevent="passes(createTraining)">
              <v-card>
                <v-toolbar flat dark color="primary">
                  <v-toolbar-title>Resolver Questões</v-toolbar-title>
                  <v-spacer />
                  <v-btn :disabled="createTrainingInProgress" icon dark @click="dialog = false">
                    <v-icon>close</v-icon>
                  </v-btn>
                </v-toolbar>

                <v-card-text>
                  <ValidationProvider
                    v-slot="{ errors }"
                    :rules="{ required: true }"
                    :debounce="1000"
                    vid="name"
                    name="Nome do Treino"
                  >
                    <v-text-field
                      v-model="training.name"
                      :error-messages="errors"
                      name="email"
                      label="Nome do Treino"
                    />
                  </ValidationProvider>

                  <v-slider
                    v-model="training.size"
                    :step="
                      question_filter.total_questions >= maxTrainingQuestions
                        ? 10
                        : 1
                    "
                    :min="minTrainingQuestions"
                    :max="
                      question_filter.total_questions >= maxTrainingQuestions
                        ? maxTrainingQuestions
                        : question_filter.total_questions
                    "
                    thumb-label="always"
                    label="Número de questões"
                  />
                </v-card-text>

                <v-card-actions class="mx-5 py-5">
                  <v-spacer />
                  <v-btn
                    :loading="createTrainingInProgress"
                    :disabled="createTrainingInProgress"
                    color="indigo accent-2"
                    ripple
                    class="white--text font-weight-medium"
                    type="submit"
                  >
                    Confirmar
                  </v-btn>
                </v-card-actions>
              </v-card>
            </form>
          </ValidationObserver>
        </v-dialog>
      </v-card-actions>
    </v-form>
    <v-tour name="newTrainingTour" :steps="tourSteps" :options="tourOptions" :callbacks="tourCallbacks" />
  </v-card>
</template>

<script>

import { innerJoin, prop, map, propOr, compose } from "ramda";
import { ValidationObserver } from "vee-validate";
// import Multiselect from "vue-multiselect";
// import "vue-multiselect/dist/vue-multiselect.min.css";

export default {
  components: {
    // Multiselect,
    ValidationObserver
  },
  filters: {
    formatNumber: function(value) {
      return new Intl.NumberFormat("pt-BR").format(value);
    }
  },
  data() {
    return {
      question_filter: null,
      loading: 0,
      minTrainingQuestions: 10,
      maxTrainingQuestions: 120,
      searchOrganization: null,
      current_user: {},
      filterFields: [
        { name: "organizations", label: "Instituição" },
        { name: "years", label: "Ano" },
        { name: "authors", label: "Banca" },
        { name: "subjects", label: "Assunto" },
        { name: "disciplines", label: "Disciplina" },
        { name: "educational_levels", label: "Escolaridade" }
      ],
      selected: {
        organizations: [],
        years: [],
        authors: [],
        disciplines: [],
        subjects: [],
        educational_levels: []
      },
      training: {
        name: "Meu treino",
        size: 30
      },
      answeredOptions: [
        { value: "all", label: "TODAS" },
        { value: "answered", label: "RESOLVIDAS" },
        { value: "unanswered", label: "NÃO RESOLVIDAS" }
      ],
      correctQuestionsOptions: [
        { value: "all", label: "TODAS RESOLVIDAS" },
        { value: "correct", label: "ACERTEI" },
        { value: "wrong", label: "ERREI" }
      ],
      answered_questions: "all",
      correct_questions: "all",
      dialog: false,
      createTrainingInProgress: false,
      tourSteps: [
        {
          target: "#step-0",
          content: "Aqui você pode selecionar quantos filtros desejar para deixar seu treino do seu jeito!",
          params: {
            placement: "top"
          }
        },
        {
          target: "#step-1",
          content: "Em seguida, clique aqui para dar um nome e escolher quantas questões você quer no seu treino. As questões irão se adaptar ao seu nível!"
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
        onStop: this.newTrainingTourOver
      }
    };
  },
  computed: {
    isLoading: function() {
      return this.loading !== 0;
    }
  },
  methods: {
    getIdsOrNull(items) {
      return items ? items.map(item => item.id) : null;
    },
    selectedFilters() {
      const select = filter =>
        innerJoin(
          (available, selected) => available.id === selected.id,
          prop(filter, this.question_filter),
          prop(filter, this.selected)
        );
      const nameOr = item => propOr(item, "name", item);
      const getName = array => map(nameOr, array);
      const selectedItems = compose(
        getName,
        select
      );

      return {
        foundQuestions: this.question_filter.total_questions,
        years: selectedItems("years"),
        authors: selectedItems("authors"),
        disciplines: selectedItems("disciplines"),
        subjects: selectedItems("subjects"),
        organizations: selectedItems("organizations"),
        educational_levels: selectedItems("educational_levels")
      };
    },
    createTraining() {
      this.createTrainingInProgress = true;

      const { answered_questions, correct_questions, training } = this.$data;
      const variables = {
        filters: {
          organizations: this.getIdsOrNull(this.selected.organizations),
          years: this.getIdsOrNull(this.selected.years),
          authors: this.getIdsOrNull(this.selected.authors),
          disciplines: this.getIdsOrNull(this.selected.disciplines),
          subjects: this.getIdsOrNull(this.selected.subjects),
          educational_levels: this.getIdsOrNull(this.selected.educational_levels),
          answered_questions,
          correct_questions
        },
        name: training.name,
        size: training.size,
      };

      this.$apollo
        .mutate({
          mutation: require("@/graphql/TrainingCreateTrainingMutation.gql"),
          variables,
          refetchQueries: [
            { query: require("@/graphql/UserTrainingSessionsQuery.gql"), variables: { size: 30, search_text: "" } }
          ]
          // update: (proxy, { data: { create_training } }) => {
          //   //console.log(create_training);
          //   const data = proxy.readQuery({
          //     query: SESSIONS_QUERY,
          //     variables: { size: 30, search_text: "" }
          //   });
          //   data.userSessions.trainings.push(create_training);
          //   console.log(data);
          //   proxy.writeQuery({
          //     query: SESSIONS_QUERY,
          //     variables: { size: 30, search_text: "" },
          //     data
          //   });
          // }
        })
        .then(({ data }) => {
          this.$ma.trackEvent({
            category: "Training",
            action: "Created Training",
            label: "Created Training",
            value: "Created Training",
            properties: this.selectedFilters()
          });

          this.$router.push({
            name: "session",
            params: {
              id: data.create_training.id,
              type: "Training",
              position: 1
            }
          });
        })
        .catch(({ graphQLErrors }) => {
          graphQLErrors.forEach(error => {
            this.$refs.observer.setErrors({
              [error["key"]]: [error["message"]]
            });
          });
        })
        .finally(() => {
          this.createTrainingInProgress = false;
        });
    },
    
    newTrainingTourOver() {
      this.current_user.viewed_tours.new_training = true;
      this.$apollo
        .mutate({
          mutation: require("@/graphql/UserFinishTourMutation.gql"),
          variables: {
            viewed_tours: { new_training: true }
          }
        });
    }
    
  },
  apollo: {
    current_user: {
      query: require("@/graphql/UserProductTourQuery.gql"),
      fetchPolicy: 'no-cache',
    },
    question_filter: {
      query: require("@/graphql/QuestionFiltersQuery.gql"),
      fetchPolicy: "cache-and-network",
      variables() {
        const variables = {
          filters: {
            organizations: this.getIdsOrNull(this.selected.organizations),
            authors: this.getIdsOrNull(this.selected.authors),
            years: this.getIdsOrNull(this.selected.years),
            disciplines: this.getIdsOrNull(this.selected.disciplines),
            subjects: this.getIdsOrNull(this.selected.subjects),
            educational_levels: this.getIdsOrNull(this.selected.educational_levels),
            answered_questions: this.answered_questions,
            correct_questions: this.correct_questions
          }
        };
        return variables;
      },
      result({ data }) {
        if(data){
          this.$ma.trackEvent({
            category: "Training",
            action: "Selected a Filter",
            label: "Filter",
            value: "Filter",
            properties: this.selectedFilters()
          });
        }
        this.selected.authors = this.selected.authors.filter(
          a => data.question_filter.authors.findIndex(b => b.id == a.id) != -1
        );
        if(this.current_user.viewed_tours && !this.current_user.viewed_tours.new_training){
          this.$tours["newTrainingTour"].start();
        }
      }
    }
  }
};
</script>
