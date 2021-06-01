<template>
  <div>
    <v-card class="pa-2">
      <v-card-text>
        <v-container fluid>
          <v-layout wrap>
            <v-flex
              xs12
              md4
              class="pa-5"
            >
              <v-card
                :to="{ name: 'mocks' }"
                outlined
                class="px-4 pb-4"
              >
                <v-list-item three-line>
                  <v-list-item-content>
                    <div class="overline mb-4">
                      SURPREENDA-SE
                    </div>
                    <v-list-item-title
                      id="tour-0"
                      class="headline mb-1"
                    >
                      Simulados Exclusivos
                    </v-list-item-title>
                    <v-list-item-subtitle>O melhor conteúdo exclusivo</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-card>
            </v-flex>
            <v-flex
              xs12
              md4
              class="pa-5"
            >
              <v-card
                :to="{ name: 'exams' }"
                outlined
                class="px-4 pb-4"
              >
                <v-list-item three-line>
                  <v-list-item-content>
                    <div class="overline mb-4">
                      EXERCITE-SE
                    </div>
                    <v-list-item-title
                      id="tour-1"
                      class="headline mb-1"
                    >
                      Provas Anteriores
                    </v-list-item-title>
                    <v-list-item-subtitle>O maior repositório de provas</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-card>
            </v-flex>
            <v-flex
              xs12
              md4
              class="pa-5"
            >
              <v-card
                :to="{ name: 'new_training' }"
                outlined
                class="px-4 pb-4"
              >
                <v-list-item three-line>
                  <v-list-item-content>
                    <div class="overline mb-4">
                      DESAFIE-SE
                    </div>
                    <v-list-item-title
                      id="tour-2"
                      class="headline mb-1"
                    >
                      Resolver Questões
                    </v-list-item-title>
                    <v-list-item-subtitle>Uma experiência única de questões</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </v-card-text>
      <v-row>
        <v-col>
          <Suggestions />
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <StartedExams />
        </v-col>
      </v-row>
      <v-row>
        <v-col>
          <StartedTrainings />
        </v-col>
      </v-row>
    </v-card>
    <v-tour
      name="menuTour"
      :steps="tourSteps"
      :options="tourOptions"
      :callbacks="tourCallbacks"
    />
  </div>
</template>

<script>
import StartedExams from "@/components/resources/StartedExams";
import StartedTrainings from "@/components/resources/StartedTrainings";
import Suggestions from "@/components/resources/Suggestions";
export default {
  name: "Start",
  components: {
    StartedExams,
    StartedTrainings,
    Suggestions
  },
  data() {
    return {
      tourSteps: [
        {
          target: "#tour-0",
          content:
            "Seja bem-vindo ao FDQuestões! Aqui é onde você encontrará simulados exclusivos que a Folha Dirigida fez especialmente para você com comentários em vídeo de professores.",
          params: {
            enableScrolling: false
          }
        },
        {
          target: "#tour-1",
          content:
            "Aqui você irá encontrar mais de 12.000 provas de concursos passados à sua disposição.",
          params: {
            enableScrolling: false,
            placement: "top"
          }
        },
        {
          target: "#tour-2",
          content:
            "Aqui você poderá criar seus próprios cadernos de questões da forma que desejar.",
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
        onStop: this.menuTourOver
      }
    };
  },
  apollo: {
    current_user: {
      query: require("@/graphql/UserProductTourQuery.gql"),
      fetchPolicy: "no-cache",
      result({ data }) {
        if (!data.current_user.viewed_tours.menu) {
          this.$tours["menuTour"].start();
        }
      }
    }
  },
  methods: {
    menuTourOver() {
      this.current_user.viewed_tours.menu = true;
      this.$apollo
        .mutate({
          mutation: require("@/graphql/UserFinishTourMutation.gql"),
          variables: {
            viewed_tours: { menu: true }
          }
        });
    }
  }
};
</script>
