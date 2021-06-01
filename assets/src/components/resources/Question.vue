<template>
  <!-- eslint-disable vue/no-v-html -->
  <div>
    <v-progress-linear v-if="loading" indeterminate />
    <template v-if="question">
      <v-container fluid grid-list-md>
        <v-layout row wrap justify-space-between>
          <v-flex>
            <strong>Instituição</strong>
            <v-chip outlined>
              {{ organizationName }}
            </v-chip>
          </v-flex>
          <v-flex>
            <strong>Banca</strong>
            <v-chip outlined>
              {{ authorName }}
            </v-chip>
          </v-flex>
          <v-flex v-if="jobName">
            <strong>Cargo</strong>
            <v-chip outlined>
              {{ jobName }}
            </v-chip>
          </v-flex>
          <v-flex v-if="examYear > 0">
            <strong>Ano</strong>
            <v-chip outlined>
              {{ examYear }}
            </v-chip>
          </v-flex>
          <v-flex v-if="questionDisciplines">
            <strong>Disciplina</strong>
            <v-chip
              v-for="discipline in questionDisciplines"
              :key="discipline.id"
              outlined
            >
              {{ discipline.name }}
            </v-chip>
          </v-flex>

          <v-flex v-if="questionSubjects">
            <strong>Assunto</strong>
            <v-chip
              v-for="subject in questionSubjects"
              :key="subject.id"
              outlined
            >
              {{ subject.name }}
            </v-chip>
          </v-flex>
          <v-flex v-if="questionEducationalLevel">
            <strong>Escolaridade</strong>
            <v-chip outlined>
              {{ questionEducationalLevel }}
            </v-chip>
          </v-flex>
        </v-layout>
      </v-container>

      <v-divider class="ma-4" />

      <div class="pt-4 font-weight-bold" v-html="question.content" />

      <v-list>
        <v-list-item-group v-model="selected_alternative">
          <template v-for="question_alternative in sortedAlternatives">
            <v-list-item
              :key="`item-${question_alternative.id}`"
              :value="question_alternative.id"
              :disabled="showQuestionResult"
              active-class="white--text"
            >
              <template v-slot:default="{ active, toggle }">
                <v-list-item-action>
                  <v-checkbox
                    :input-value="
                      (active && !showQuestionResult) ||
                        (showQuestionResult && question_alternative.correct) ||
                        (showQuestionResult &&
                        question_alternative.id == selected_alternative)
                    "
                    :true-value="question_alternative.id"
                    :color="
                      !showQuestionResult && active
                        ? 'indigo accent-3'
                        : showQuestionResult &&
                          active &&
                          !question_alternative.correct
                          ? 'red accent-2'
                          : showQuestionResult && question_alternative.correct
                            ? 'green accent-4'
                            : ''
                    "
                    @click="toggle"
                  />
                </v-list-item-action>

                <v-list-item-content
                  :class="
                    !showQuestionResult && active
                      ? 'indigo accent-3'
                      : showQuestionResult &&
                        active &&
                        !question_alternative.correct
                        ? 'red accent-1 black--text'
                        : showQuestionResult && question_alternative.correct
                          ? 'green accent-1'
                          : ''
                  "
                  style="flex: -1"
                >
                  <v-container>
                    <v-row align-content-start no-gutters justify="start">
                      <v-col cols="1">
                        <span>{{ question_alternative.letter }} )</span>
                      </v-col>
                      <v-col cols="11">
                        <div class="text-left" v-html="question_alternative.content" />
                      </v-col>
                    </v-row>
                  </v-container>
                </v-list-item-content>
              </template>
            </v-list-item>
          </template>
        </v-list-item-group>
      </v-list>

      <p
        v-if="!outdatedQuestion && !cancelledQuestion && correctAnswer"
        class="green--text accent-1 font-weight-medium"
      >
        Você acertou.
      </p>

      <p
        v-if="!outdatedQuestion && !cancelledQuestion && wrongAnswer"
        class="red--text accent-1 font-weight-medium"
      >
        Você errou.
      </p>

      <p v-if="outdatedQuestion" class="red--text accent-1 font-weight-medium">
        Questão desatualizada
      </p>

      <p v-if="cancelledQuestion" class="red--text accent-1 font-weight-medium">
        Questão cancelada
      </p>

      <div>
        <v-btn
          v-if="!showQuestionResult"
          :disabled="answerQuestionInProgress || !selected_alternative"
          :loading="answerQuestionInProgress"
          color="green darken-1 white--text"
          @click="answerQuestion"
        >
          Responder
        </v-btn>
        <slot v-if="showQuestionResult" name="controlButtons" />
      </div>

      <div class="text-center my-4">
        <slot name="pagination" />
      </div>

      <v-divider v-if="hasVideo" class="ma-4" />


      <VideoVimeo v-if="hasVideo" ref="videoPlayer" :url="videoUrl" />
      <v-container>
        <v-row>
          <v-col cols="10">
            <div v-if="!hasVideo">
              <v-btn
                v-if="question.comment"
                text
                @click="showComment = !showComment"
              >
                <v-icon class="mr-2">
                  comment
                </v-icon>
                Mostrar comentário
              </v-btn>
              <p
                v-else
                class="font-weight-black"
              >
                Esta questão ainda não possui comentário. Você pode solicitar um comentário aos nossos professores clicando 
                <a
                  :href="`https://folhadirigida850580.typeform.com/to/ae40gB?id_questao=${question.id}&email=${current_user.email}`"
                  target="_blank"
                >aqui</a> 
                .
              </p>
            </div>
          </v-col>
          <v-col>
            <div class="text-right">
              <a
                :href="
                  `https://folhadirigida850580.typeform.com/to/m2uCtZ?id_questao=${
                    question.id
                  }`
                "
                target="_blank"
              >Reportar Questão</a>
            </div>
          </v-col>
        </v-row>
      </v-container>
      <div v-if="showComment">
        <h3>
          Professor(a): {{ question.comment.teacher.name }}
        </h3>
        <h3 v-if="question.comment.teacher.email">
          Email: {{ question.comment.teacher.email }}
        </h3>
        <br>
        <div class="pt-4 font-weight-bold" v-html="with_breaklines(question.comment.content)" />
      </div>
    </template>
    <v-dialog v-model="show_trial_invitation" max-width="400">
      <v-card>
        <v-card-title
          primary-title
        >
          Que tal garantir logo o seu acesso ilimitado?
        </v-card-title>

        <v-card-text>
          Veja como é fácil fazer sua assinatura agora mesmo.
        </v-card-text>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="show_trial_invitation = false">
            Mais tarde
          </v-btn>
          <v-spacer />
          <v-btn
            color="primary"
            href="https://assine.folhadirigida.com.br/planofdquestoes/"
            target="_blank"
            @click="signupPage()"
          >
            Assinar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
/* eslint-disable no-console */
import sortBy from "lodash/sortBy";
import VideoVimeo from "@/components/resources/Video";
import { path, pathEq, assoc, is, isEmpty } from "ramda";

export default {
  name: "Question",
  components: {
    VideoVimeo
  },
  props: {
    position: Number,
    parent: Object,
    showResult: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      loading: 0,
      selected_alternative: null,
      current_user: {},
      hasVideo: false,
      videoUrl: null,
      showComment: false,
      answerQuestionInProgress: false,
      show_trial_invitation: false
    };
  },
  computed: {
    organizationName() {
      return this.question.exams[0].organization.name;
    },
    authorName() {
      return this.question.exams[0].author.name;
    },
    jobName() {
      return path(["job", "name"], this.question.exams[0]);
    },
    examYear() {
      return this.question.exams[0].year;
    },
    questionDisciplines() {
      return this.question.tags.disciplines;
    },
    questionSubjects() {
      return this.question.tags.subjects;
    },
    questionEducationalLevel() {
      return this.question.exams[0].educational_level;
    },
    outdatedQuestion() {
      return this.question.response && this.question.outdated;
    },
    cancelledQuestion() {
      return this.question.response && this.question.cancelled;
    },
    correctAnswer() {
      return pathEq(
        ["response", "question_alternative", "correct"],
        true,
        this.question
      );
    },
    wrongAnswer() {
      return pathEq(
        ["response", "question_alternative", "correct"],
        false,
        this.question
      );
    },
    showQuestionResult() {
      return (
        this.showResult ||
        (!!this.question.response &&
          !!this.question.response.question_alternative)
      );
    },
    sortedAlternatives() {
      return sortBy(this.question.question_alternatives, ["letter"]);
    }
  },
  methods: {
    with_breaklines(content) {
      return content.replace(/\r\n/g, "<br>");
    },
    updateVideo() {
      if (this.question.tags.videos && this.question.tags.videos.length > 0) {
        this.videoUrl = this.question.tags.videos[0].name;
        this.hasVideo = true;

        if (this.$refs.videoPlayer) {
          this.$refs.videoPlayer.loadVideo(this.question.tags.videos[0].name);
        }
      } else {
        this.hasVideo = false;
      }
    },
    answerQuestion() {
      if (this.showQuestionResult) {
        return;
      }

      this.answerQuestionInProgress = true;

      const variables = {
        type: this.parent.__typename,
        id: this.parent.id,
        question_id: this.question.id,
        question_alternative_id: this.selected_alternative
      };

      this.$apollo
        .mutate({
          mutation: require("@/graphql/QuestionAnswerQuestionMutation.gql"),
          variables,
          refetchQueries: [
            {
              query: require("@/graphql/SessionQuery.gql"),
              variables: {
                id: Number(this.parent.id),
                type: this.parent.__typename
              }
            }
          ]
        })
        .then(({ data }) => {
          this.question.response = data.answer_question.question.response;
          const extractName = items =>
            is(Array, items) && !isEmpty(items) ? items.map(i => i.name) : null;

          let properties = {
            sessionType: this.parent.__typename,
            questionOrganizationName: this.organizationName,
            questionAuthorName: this.authorName,
            questionJobName: this.jobName,
            questionSubjects: extractName(this.questionSubjects),
            questionDisciplines: extractName(this.questionDisciplines),
            correctAnswer:
              data.answer_question.question.response.question_alternative
                .correct
          };

          if (this.parent.__typename == "ExamSession") {
            properties = assoc("examName", this.parent.exam.name, properties);
            properties = assoc("examId", this.parent.exam.id, properties);
          }

          this.$ma.trackEvent({
            category: "Question Resolver",
            action: "Answered Question",
            label: "Question",
            value: this.question.question_id,
            properties: properties
          });
          if (data.answer_question.show_trial_invitation) {
            this.show_trial_invitation = true;
          }
        })
        .catch(error => {
          const { graphQLErrors } = error;
          console.log(graphQLErrors);
        })
        .finally(() => {
          this.answerQuestionInProgress = false;
        });
    },
    signupPage: function() {
      this.$ma.trackEvent({
        category: "Signup Page",
        action: "Access Signup Page",
        label: "Signup Page",
        value: "Signup Page"
      });
      this.show_trial_invitation = false;
    }
  },
  apollo: {
    question: {
      query: require("@/graphql/QuestionQuery.gql"),
      fetchPolicy: "no-cache", //necessary line for avoiding bug with session cache, see card https://trello.com/c/wA84g0IG/308-bug-treinos-com-quest%C3%B5es-em-comum
      variables() {
        return {
          id: this.parent.id,
          type: this.parent.__typename,
          position: this.position
        };
      },
      result({ data }) {
        this.showComment = false;
        // this.$ma.trackEvent({
        //   category: "Question Resolver",
        //   action: "Viewed a Question",
        //   label: "Question",
        //   value: data.id,
        //   properties: {
        //     parent: this.parent
        //   }
        // });
        if (
          data.question.response != null &&
          data.question.response.question_alternative != null
        ) {
          this.selected_alternative =
            data.question.response.question_alternative.id;
        }
        this.updateVideo();
      }
    },
    current_user: {
      query: require("@/graphql/UserCurrentUserQuery.gql")
    }
  }
};
</script>
<style>
[class$="--disabled"],
[class*="--disabled "] * {
  color: #000 !important;
}
</style>
