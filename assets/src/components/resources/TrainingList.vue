<template>
  <v-container fluid grid-list-sm>
    <v-layout wrap>
      <v-flex v-for="training in trainings" :key="training.id" xs12 md6>
        <v-card>
          <v-list-item two-line>
            <div class="subtitle-2">
              {{ training.name }}
            </div>
          </v-list-item>
          <v-list-item>
            <v-list-item-content v-if="$vuetify.breakpoint.mdAndUp" class="body-2">
              {{ training.questions_count }} questões /
              {{ training.responses_count }} respondidas
            </v-list-item-content>
            <v-list-item-action>
              <v-btn
                v-if="!finished(training)"
                :to="{
                  name: 'session',
                  params: {
                    id: training.id,
                    type: 'Training',
                    position: 1
                  }
                }"
                rounded
                dark
                color="green darken-1"
              >
                CONTINUAR
              </v-btn>
              <v-btn
                v-if="finished(training)"
                :to="{
                  name: 'result',
                  params: {
                    type: 'Training',
                    id: training.id,
                    question_position: 1
                  }
                }"
                rounded
                dark
                color="indigo"
              >
                RESULTADO
              </v-btn>
            </v-list-item-action>
            <v-list-item-action>
              <v-btn class="mt-2" icon @click="openPopup(training.id)">
                <v-icon>delete</v-icon>
              </v-btn>
            </v-list-item-action>
          </v-list-item>
        </v-card>
      </v-flex>
      <v-dialog v-model="dialog" max-width="290">
        <v-card>
          <v-card-title>Tem certeza que deseja deletar este treino?</v-card-title>
          <v-card-actions>
            <v-btn color="green darken-1" text @click="dialog = false">
              Não
            </v-btn>
            <v-spacer />
            <v-btn color="green darken-1" text @click="removeTraining()">
              Sim
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-layout>
  </v-container>
</template>

<script>
/* eslint-disable no-console */
export default {
  name: "TrainingList",
  props: {
    trainings: { type: Array }
  },
  data() {
    return {
      loading: 0,
      dialog: false,
      idToDelete: null
    };
  },

  methods: {
    openPopup(training_id) {
      this.dialog = true;
      this.idToDelete = training_id;
    },
    removeTraining() {
      this.$apollo
        .mutate({
          mutation: require("@/graphql/TrainingDeleteTrainingMutation.gql"),
          variables: {
            id: this.idToDelete
          }
        })
        .then(data => {})
        .catch(({ graphQLErrors }) => {
          graphQLErrors.forEach(error => {
            console.log(error["message"]);
          });
        })
        .finally(() => {
          this.dialog = false;
          this.$emit("deletedTraining");
          this.idToDelete = null;
        });
    },
    finished(training) {
      return training.questions_count == training.responses_count;
    }
  }
};
</script>
