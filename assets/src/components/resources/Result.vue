<template>
  <v-card class="pa-2">
    <v-progress-linear v-if="loading" indeterminate />
    <template v-if="result">
      <v-card-title primary-title>
        <h2 class="headline">Resultado: {{ sessionName }}</h2>
      </v-card-title>

      <v-card-text>
        <h2 class="title mb-3">
          Você acertou {{ totalCorrect }} de {{ totalQuestions }} questões.
          <div
            v-if="isExamSession"
          >A média de acertos para esta prova é de {{ result.sessions_data.mean_percentage_correct }} questões.</div>
        </h2>

        <v-container fluid>
          <v-layout row>
            <v-flex xs12 md10 lg6>
              <ResultChart v-if="result.training || result.exam_session" :series="gradeSeries" />
            </v-flex>
          </v-layout>
        </v-container>

        <div class="mt-4">
          <v-btn
            v-for="(question, index) in result.questions"
            :key="index"
            :color="
              question.response.question_alternative.correct
                ? 'green lighten-1'
                : 'red darken-1'
            "
            :outlined="question_position != question.position"
            fab
            small
            dark
            class="ma-1"
            @click="showQuestion(question.position)"
          >{{ question.position }}</v-btn>
        </div>
      </v-card-text>
      <v-card-text>
        <Question
          :position="question_position"
          :parent="result.exam_session ? result.exam_session : result.training"
          :show-result="true"
        />
      </v-card-text>
    </template>
  </v-card>
</template>
<script>
import ResultChart from "@/components/resources/ResultChart";
import Question from "@/components/resources/Question";

export default {
  components: {
    ResultChart,
    Question
  },
  props: {
    id: Number,
    type: String,
    question_position: {
      type: Number,
      default: 1
    }
  },
  data() {
    return {
      loading: 0,
      result: null
    };
  },
  computed: {
    isExamSession() {
      return this.result && this.type == "ExamSession";
    },
    isTraining() {
      return this.result && this.type == "Training";
    },
    sessionName() {
      return this.isExamSession
        ? this.result.exam_session.exam.name
        : this.result.training.name;
    },
    totalQuestions() {
      if (this.type == "ExamSession") {
        return this.result.exam_session.exam.exam_questions_count;
      } else {
        return this.result.training.questions_count;
      }
    },
    totalCorrect() {
      return this.result.questions.filter(
        question => question.response.question_alternative.correct
      ).length;
    },
    userPercentageCorrect() {
      return Math.round((100.0 * this.totalCorrect) / this.totalQuestions);
    },
    totalPercentageCorrect() {
      if (this.isExamSession) {
        return Math.round(
          (100.0 * this.result.sessions_data.mean_percentage_correct) /
            this.totalQuestions
        );
      }
      return null;
    },
    gradeSeries() {
      if (this.isExamSession) {
        return [this.userPercentageCorrect, this.totalPercentageCorrect];
      } else return [this.userPercentageCorrect];
    }
  },
  methods: {
    showQuestion(question_position) {
      this.$ma.trackEvent({
        category: "Result",
        action: "Navigated to Question on Result",
        label: "Question",
        value: question_position,
        properties: {
          questionPosition: question_position,
          sessionType: this.type,
          sessionId: this.id,
          sessionName: this.sessionName,
          totalQuestions: this.totalQuestions
        }
      });
      this.$router.push({
        name: "result",
        params: {
          type: this.type,
          id: this.id,
          question_position: question_position
        }
      });
    },
    percentageCorrect(correctAnswers) {
      return Math.round((100.0 * this.correctAnswers) / this.totalQuestions);
    }
  },
  apollo: {
    result: {
      query: require("@/graphql/QuestionResultQuery.gql"),
      variables() {
        return {
          id: this.id,
          type: this.type
        };
      },
      result({ data }) {
        if (this.isExamSession) {
          data.result.sessions_data.mean_percentage_correct = Math.round(
            data.result.sessions_data.mean_percentage_correct
          );
        }
        // this.$ma.trackEvent({
        //   category: this.type,
        //   action: `Acessed Result of ${this.type}`,
        //   label: this.sessionName,
        //   value: this.id,
        //   properties: {
        //     sessionType: this.type,
        //     sessionId: this.id,
        //     sessionName: this.sessionName,
        //     totalQuestions: this.totalQuestions
        //   }
        // });
      }
    }
  }
};
</script>
