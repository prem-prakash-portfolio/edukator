import axios from "axios"
import { QUESTOES_AUTH_TOKEN } from "@/constants/settings";

const http = axios.create();

http.interceptors.request.use(function(config) {
  const token = localStorage.getItem(QUESTOES_AUTH_TOKEN);

  config.headers = {
    authorization: token ? `Bearer ${token}` : "",
  }
  return config;
}, function(error) {
  // Do something with request error
  return Promise.reject(error);
});

class fetcher {
  static track(category = "Event", action, label = null, value = null, properties = {}) {
    return http.post("/api/events", { category, action, label, value, properties });
  }
}

export default fetcher;