<template v-if="current_user">
  <v-card class="pa-2">
    <v-card-title>
      Sugestões de provas.
    </v-card-title>
    <v-row>
      <v-card-text>
        <v-col>
          <template v-if="organizations || jobs">
            <template v-if="jobs">
              <p>
                Cargo{{ jobs.length > 1 ? 's' : '' }}:
                <v-chip v-for="(job, index) in jobs" :key="index" small>
                  {{ job }}
                </v-chip>
              </p>
            </template>

            <template v-if="organizations">
              <p>
                Instituiç{{ organizations.length > 1 ? 'ões' : 'ão' }}:
                <v-chip v-for="(organization, index) in organizations" :key="index" small>
                  {{ organization }}
                </v-chip>
              </p>
            </template>

            <p>
              Seguem algumas sugestões de Provas Anteriores e Simulados para você
              se preparar.
            </p>
            <v-row>
              <v-col>
                <v-list>
                  <template v-for="(exam, index) in current_user.suggested_exams">
                    <v-list-item
                      :key="index"
                      @click="startExamSession(exam)"
                    >
                      <v-list-item-content>
                        <p class="title">
                          {{ exam.name }}
                        </p>
                        <p>
                          <v-chip class="caption" dark color="indigo darken-0">
                            {{ exam.exam_questions_count }} questões
                          </v-chip>
                        </p>
                      </v-list-item-content>
                      <v-list-item-action>
                        <v-btn
                          :loading="startExamSessionInProgress"
                          :disabled="startExamSessionInProgress"
                          rounded
                          dark
                          color="orange darken-3"
                        >
                          TREINAR AGORA
                        </v-btn>
                      </v-list-item-action>
                    </v-list-item>
                  </template>
                </v-list>
                <p>
                  Seu objetivo mudou?
                </p>
                <v-btn
                  rounded
                  dark
                  color="indigo"
                  small
                  @click.stop="dialog = true"
                > 
                  Atualizar meu objetivo
                </v-btn>
              </v-col>
            </v-row>
          </template>
          <template v-else>
            <p>Defina aqui seu objetivo e receba sugestões de provas para poder chegar mais rápido aonde deseja!</p>
            <br>
            <v-btn
              rounded 
              dark
              color="indigo"
              small
              @click.stop="dialog = true"
            >
              Definir meu objetivo
            </v-btn>
          </template>
          <v-dialog
            v-model="dialog"
            max-width="700px"
          >
            <v-toolbar flat dark color="primary">
              <v-toolbar-title>Meu objetivo</v-toolbar-title>
              <v-spacer />
              <v-btn icon dark @click="dialog = false">
                <v-icon>close</v-icon>
              </v-btn>
            </v-toolbar>
            <ProfileGoals @updateGoals="updateGoals()" />
          </v-dialog>
        </v-col>
      </v-card-text>
    </v-row>
  </v-card>
</template>
<script>
import { path } from "ramda";
import ProfileGoals from "@/components/resources/ProfileGoals";
export default {
  name: "Suggestions",
  components: {
    ProfileGoals
  },
  data() {
    return {
      current_user: false,
      startExamSessionInProgress: false,
      dialog: false
    };
  },
  computed: {
    jobs() {
      if (this.current_user && this.current_user.goals.jobs.length > 0) {
        return this.current_user.goals.jobs.map(j => j.name);
      } else {
        return false;
      }
    },
    organizations() {
      if (
        this.current_user &&
        this.current_user.goals.organizations.length > 0
      ) {
        return this.current_user.goals.organizations.map(j => j.name);
        return new Intl.ListFormat("pt-BR", {
          style: "long",
          type: "conjunction"
        }).format(organizationsNames);
      } else {
        return false;
      }
    }
  },
  apollo: {
    current_user: {
      query: require("@/graphql/SuggestedExamsQuery.gql"),
      fetchPolicy: "no-cache"
    }
  },
  methods: {
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
            action: "Started Exam From Suggestions",
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
        .finally(() => {
          this.startExamSessionInProgress = false;
        });
    },
    updateGoals: function() {
      this.$apollo.queries.current_user.refresh();
    }
  }
};
</script>
