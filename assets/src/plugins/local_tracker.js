import fetcher from "@/plugins/fetcher";
import { logDebug } from 'vue-multianalytics';

class LocalTracker {
  constructor(name, config = {}) {
    this.name = name
    this.config = config
    this.superProperties = {};
  }

  init(initConf = {}) {
    this.config.debug = initConf.debug
  }

  trackView({ viewName, properties = {} }) {
    if (this.config.debug) {
      logDebug(viewName)
    }
    let fullProperties = Object.assign(properties, this.superProperties)
    fetcher.track("Router", "Page Viewed", viewName, null, fullProperties);
  }

  trackEvent({ category = "Event", action, label = null, value = null, properties = {} }) {
    if (this.config.debug) {
      logDebug(...arguments)
    }
    let fullProperties = Object.assign(properties, this.superProperties)
    fetcher.track(category, action, label, value, fullProperties);
  }

  /**
   * Define a property that will be sent across all the events
   *
   * @param {any} properties
   */
  setSuperProperties(properties) {
    if (this.config.debug) {
      logDebug(properties)
    }
    this.superProperties = properties
  }

  setUserProperties(properties = {}) {

  }

  identify(params = {}) {

  }

  setUsername(userId) {

  }


  setAlias(alias) {

  }

  reset() {

  }

}

export default LocalTracker;