<template>
  <v-card>
    <v-progress-linear v-if="loading" indeterminate />

    <template v-if="session">
      <v-card-title primary-title>
        <h2 class="title">
          {{ sessionName }}
        </h2>
        <v-spacer />
      </v-card-title>

      <v-card-text>
        <Question
          :position="position"
          :parent="isExamSession ? session.exam_session : session.training"
        >
          <template v-slot:controlButtons>
            <v-btn
              v-if="totalQuestions != position"
              :to="{
                name: 'session',
                params: {
                  id: id,
                  type: type,
                  position: position + 1
                }
              }"
              dark
              color="indigo accent-2"
            >
              Próxima
            </v-btn>

            <v-btn
              v-if="viewResult"
              :to="{
                name: 'result',
                params: {
                  type: type,
                  id: id,
                  question_position: 1
                }
              }"
              dark
              right
              color="orange darken-3"
            >
              Ver Resultado
            </v-btn>
          </template>

          <template v-slot:pagination>
            <v-btn
              v-for="(question_position, index) in totalQuestions"
              :key="index"
              :outlined="question_position != position"
              :dark="question_position == position"
              :small="question_position != position"
              :color="
                noQuestion(question_position) || noResponse(question_position)
                  ? 'grey ligthen-1'
                  : correctAnswer(question_position)
                    ? 'green'
                    : wrongAnswer(question_position)
                      ? 'red'
                      : 'blue'
              "
              :to="{
                name: 'session',
                params: {
                  id: id,
                  type: type,
                  position: question_position
                }
              }"
              :disabled="noQuestion(question_position)"
              depressed
              fab
              class="ma-1"
            >
              {{ question_position }}
            </v-btn>
          </template>
        </Question>
      </v-card-text>
    </template>
  </v-card>
</template>

<script>
import Question from "@/components/resources/Question";
export default {
  name: "Session",
  components: {
    Question
  },
  props: {
    id: {
      type: Number
    },
    type: {
      type: String
    },
    position: {
      type: Number,
      default: 1
    }
  },
  data() {
    return {
      loading: 0,
      session: null
    };
  },
  computed: {
    isExamSession() {
      return this.session && this.type == "ExamSession";
    },
    isTraining() {
      return this.session && this.type == "Training";
    },
    viewResult() {
      return this.isExamSession
        ? this.session.exam_session.exam.exam_questions_count ==
            this.session.exam_session.responses_count
        : this.session.training.questions_count ==
            this.session.training.responses_count;
    },
    totalQuestions() {
      return this.isExamSession
        ? this.session.exam_session.exam.exam_questions_count
        : this.session.training.questions_count;
    },
    sessionName() {
      return this.isExamSession
        ? this.session.exam_session.exam.name
        : this.session.training.name;
    }
  },
  methods: {
    noQuestion(position) {
      return !this.findQuestion(position);
    },
    noResponse(position) {
      const question = this.findQuestion(position);
      return !question || !question.response;
    },
    correctAnswer(position) {
      const question = this.findQuestion(position);
      return (
        question &&
        question.response &&
        question.response.question_alternative &&
        question.response.question_alternative.correct
      );
    },
    wrongAnswer(position) {
      const question = this.findQuestion(position);
      return (
        question &&
        question.response &&
        question.response.question_alternative &&
        !question.response.question_alternative.correct
      );
    },
    findQuestion(position) {
      return this.session.questions.find(
        question => question.position == position
      );
    },
    nextQuestion() {
      // this.$ma.trackEvent({
      //   category: "Question Resolver",
      //   action: "Navigated to Question",
      //   label: "Question",
      //   value: newPosition,
      //   properties: {
      //     questionOldPosition: oldPosition,
      //     questionPosition: newPosition,
      //     sessionType: this.type,
      //     sessionId: this.id,
      //     itemName: this.sessionName,
      //     totalQuestions: this.totalQuestions
      //   }
      // });

      let question = this.session.questions.find(
        question => question.response === null
      );

      this.$router.push({
        name: "session",
        params: { id: this.id, type: this.type, position: question.position }
      });
    }
  },
  apollo: {
    session: {
      query: require("@/graphql/SessionQuery.gql"),
      fetchPolicy: "cache-and-network", //necessary line for avoiding bug with session cache, see card https://trello.com/c/wA84g0IG/308-bug-treinos-com-quest%C3%B5es-em-comum
      variables() {
        return {
          id: this.id,
          type: this.type
        };
      },
      result({ data }) {
        // this.$ma.trackEvent({
        //   category: this.type,
        //   action: `Acessed ${this.type}`,
        //   label: this.sessionName,
        //   value: this.id,
        //   properties: data
        // });
      }
    }
  }
};
</script>
