<template>
  <v-container
    fluid
    grid-list-sm
  >
    <v-layout wrap>
      <v-flex
        v-for="exam in exams"
        :key="exam.id"
        xs12
        md6
      >
        <v-card>
          <v-list-item two-line>
            <div class="subtitle-2">
              {{ exam.name }}
            </div>
          </v-list-item>
          <v-list-item v-if="expanded != 0">
            <v-list-item-content class="body-2">
              {{ exam.exam_questions_count }} questões
            </v-list-item-content>
            <v-list-item-action v-if="expanded != 0">
              <v-btn
                :loading="startExamSessionInProgress"
                :disabled="startExamSessionInProgress"
                rounded
                dark
                color="orange darken-3"
                @click="startExamSession(exam)"
              >
                INICIAR
              </v-btn>
            </v-list-item-action>
          </v-list-item>

          <v-expansion-panels
            :value="expanded"
            :disabled="exam.exam_sessions.length == 0"
          >
            <v-expansion-panel>
              <v-expansion-panel-header
                v-if="expanded != 0"
                :class="exam.exam_sessions.length > 0 ? 'brown lighten-5' : ''"
                disable-icon-rotate
              >
                <!-- <template v-slot:actions>
                  <v-icon color="white">$vuetify.icons.expand</v-icon>
                </template>-->
                <template v-if="exam.exam_sessions.length > 0">
                  Iniciado
                </template>
              </v-expansion-panel-header>
              <v-expansion-panel-content class="mx-n5 mb-n4">
                <v-list-item
                  v-for="exam_session in exam.exam_sessions"
                  :key="exam_session.id"
                >
                  <v-list-item-content class="body-2">
                    {{ exam_session.responses_count }} respondidas
                  </v-list-item-content>
                  <v-list-item-action>
                    <v-btn
                      v-if="!finished(exam_session, exam)"
                      :to="{
                        name: 'session',
                        params: {
                          id: exam_session.id,
                          type: 'ExamSession',
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
                      v-if="finished(exam_session, exam)"
                      :to="{
                        name: 'result',
                        params: {
                          type: 'ExamSession',
                          id: exam_session.id,
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
                  <v-list-item-action v-if="session">
                    <v-btn
                      class="mt-2"
                      icon
                      @click="openPopup(exam_session.id)"
                    >
                      <v-icon>delete</v-icon>
                    </v-btn>
                  </v-list-item-action>
                </v-list-item>
              </v-expansion-panel-content>
            </v-expansion-panel>
          </v-expansion-panels>
        </v-card>
      </v-flex>
      <v-dialog
        v-if="session"
        v-model="dialog"
        max-width="290"
      >
        <v-card>
          <v-card-title>Tem certeza que deseja deletar esta sessão?</v-card-title>
          <v-card-actions>
            <v-btn
              color="green darken-1"
              text
              @click="dialog = false"
            >
              Não
            </v-btn>
            <v-spacer />
            <v-btn
              color="green darken-1"
              text
              @click="removeExamSession()"
            >
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

import { path } from "ramda";
export default {
  name: "ExamList",
  props: {
    exams: { type: Array },
    expanded: null,
    exam_type: { type: String },
    session: { type: Boolean }
  },
  data() {
    return {
      startExamSessionInProgress: false,
      dialog: false,
      idToDelete: null
    };
  },
  methods: {
    openPopup(exam_id) {
      this.dialog = true;
      this.idToDelete = exam_id;
    },
    removeExamSession() {
      this.$apollo
        .mutate({
          mutation: require("@/graphql/ExamDeleteExamSessionMutation.gql"),
          variables: {
            id: this.idToDelete
          },
          refetchQueries: [
            {
              query: require("@/graphql/ExamsQuery.gql"),
              variables: { size: 30, search_text: "", type: "OLD_EXAM" }
            },
            {
              query: require("@/graphql/ExamsQuery.gql"),
              variables: { size: 30, search_text: "", type: "MOCK" }
            }
          ]
        })
        .then(data => {})
        .catch(({ graphQLErrors }) => {
          graphQLErrors.forEach(error => {
            console.log(error["message"]);
          });
        })
        .finally(() => {
          this.dialog = false;
          this.$emit("deletedExam");
          this.idToDelete = null;
        });
    },
    finished(exam_session, exam) {
      return exam.exam_questions_count == exam_session.responses_count;
    },
    startExamSession: function(exam) {
      this.startExamSessionInProgress = true;
      this.$apollo
        .mutate({
          mutation: require("@/graphql/ExamStartExamSessionMutation.gql"),
          variables: { exam_id: exam.id },
          refetchQueries: [
            {
              query: require("@/graphql/UserExamSessionsQuery.gql"),
              variables: { size: 30, search_text: "" }
            }
          ]
        })
        .then(({ data }) => {
          this.$ma.trackEvent({
            category: "Exam",
            action: "Started Exam",
            label: "exam_id",
            value: exam.id,
            properties: {
              examName: exam.name,
              examType: this.exam_type,
              jobName: path(["job", "name"], exam),
              organizationName: exam.organization.name,
              authorName: exam.author.name,
              examTotalQuestions: exam.exam_questions_count
            }
          });
          this.$router.push({
            name: "session",
            params: {
              type: "ExamSession",
              id: data.create_exam_session.exam_sessions[0].id,
              position: 1
            }
          });
        })
        .catch(error => {
          console.log(error);
          // graphQLErrors.forEach(error => {
          //   this.errors.add({
          //     field: error["field"],
          //     msg: error["message"]
          //   });
          // });
        })
        .finally(() => {
          this.startExamSessionInProgress = false;
        });
    }
  }
};
</script>
