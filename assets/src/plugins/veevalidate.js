import Vue from "vue";
import { ValidationProvider, extend, localize } from "vee-validate";
import { required, email } from "vee-validate/dist/rules";
import pt_BR from "vee-validate/dist/locale/pt_BR.json";
// import CpfValidator from "components/validators/cpf.validator";
// import Dictionary from "components/validators/dictionary";
extend("required", required);
extend("email", email);
localize("pt_BR", pt_BR);

Vue.component("ValidationProvider", ValidationProvider);
// Validator.extend("cpf", CpfValidator);
//
// Vue.use(VeeValidator, {
//   locale: "pt_BR",
//   dictionary: Dictionary,
//   mode: "lazy"
// });
