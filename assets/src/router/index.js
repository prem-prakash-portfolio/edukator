import Vue from "vue";
import Router from "vue-router";
//import Signup from "components/auth/Signup";
import Login from "@/components/auth/Login";
import ExternalLogin from "@/components/auth/ExternalLogin";
import Logged from "@/components/resources/Logged";
import Exams from "@/components/resources/Exams";
import Session from "@/components/resources/Session";
import Start from "@/components/resources/Start";
import NewTraining from "@/components/resources/NewTraining";
import Result from "@/components/resources/Result";
import NotFound from "@/components/NotFound";
import Profile from "@/components/resources/Profile";

Vue.use(Router);

function propsValidator(route, component) {
  const props = { ...route.params };
  Object.entries(props).map(([key, prop]) => {
    // console.log(route.name, component.props, component.props[key], key, prop);
    if (!(prop instanceof component.props[key].type)) {
      props[key] = component.props[key].type(prop);
    }
  });
  return props;
}

let router = new Router({
  mode: "history",
  routes: [
    {
      path: "/e/:token",
      name: "external_login",
      meta: { analytics: "external_login" },
      component: ExternalLogin,
      props(route) {
        return propsValidator(route, ExternalLogin);
      }
    },
    {
      path: "/login",
      name: "login",
      alias: "/",
      component: Login
    },
    // {

    //   path: "/criar-conta",
    //   name: "signup",
    //   alias: "/",
    //   component: Signup
    // },

    {
      path: "/",
      component: Logged,
      children: [
        {
          path: "/inicio",
          name: "start",
          component: Start
        },
        {
          path: "/perfil",
          name: "profile",
          component: Profile
        },
        {
          path: "/simulados",
          name: "mocks",
          component: Exams,
          props: { headline: "Simulados Exclusivos", exam_type: "MOCK" }
        },
        {
          path: "/provas-anteriores",
          name: "exams",
          component: Exams,
          props: { headline: "Provas Anteriores", exam_type: "OLD_EXAM" }
        },
        {
          path: "/questoes",
          name: "new_training",
          component: NewTraining
        },
        {
          path: "/s/:type/:id/q/:position",
          name: "session",
          component: Session,
          props(route) {
            return propsValidator(route, Session);
          }
        },
        {
          path: "/r/:type/:id/:question_position",
          name: "result",
          component: Result,
          props(route) {
            return propsValidator(route, Result);
          }
        }
      ]
    },
    {
      path: "*",
      name: "NotFound",
      component: NotFound
    }
  ]
});

export default router;
