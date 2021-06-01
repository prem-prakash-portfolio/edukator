<template>
  <form @submit.prevent="doUpdateGoals()">
    <v-card class="pa-2">
      <v-card-title>
        <slot name="header" />
      </v-card-title>

      <v-card-text>
        <template v-for="(field, index) in goalsFields">
          <v-autocomplete
            :key="index"
            v-model="goalsSelected[field.name]"
            :items="organizations_and_jobs[field.name]"
            :name="field.name"
            :label="field.label"
            multiple
            hide-selected
            deletable-chips
            dense
            clearable
            small-chips
            autocomplete="off"
            item-text="name"
            item-value="id"
            @change="doUpdateGoals()"
          />
        </template>
      </v-card-text>
    </v-card>
  </form>
</template>

<script>
export default {
  name: "ProfileGoals",
  data() {
    return {
      goalsFields: [
        { name: "organizations", label: "Instituição" },
        { name: "jobs", label: "Cargo" }
      ],
      goalsSelected: {
        organizations: [],
        jobs: []
      },
      organizations_and_jobs: {
        organizations: [],
        jobs: []
      }
    };
  },
  methods: {
    doUpdateGoals: function() {
      this.$apollo.mutate({
        mutation: require("@/graphql/UserUpdateProfileMutation.gql"),
        variables: {
          goals: {
            organizations: this.goalsSelected.organizations,
            jobs: this.goalsSelected.jobs
          }
        }
      }).then(() => {
        this.$emit("updateGoals");
      });
    }
  },
  apollo: {
    organizations_and_jobs: {
      query: require("@/graphql/UserOrganizationsAndJobsQuery.gql")
    },
    current_user: {
      query: require("@/graphql/SuggestedExamsQuery.gql"),
      fetchPolicy: "no-cache",

      result({ data }) {
        this.goalsSelected.organizations = data.current_user.goals.organizations.map(
          o => o.id
        );
        this.goalsSelected.jobs = data.current_user.goals.jobs.map(o => o.id);
      }
    }
  }
};
</script>
