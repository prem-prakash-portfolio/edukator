<script>
import Vimeo from "@vimeo/player";

export default {
  name: "VueVimeo",
  props: {
    customClass: String,
    responsive: {
      type: Boolean,
      default: true
    },
    vimeoInitialized: {
      type: Function,
      default: function() {}
    },
    title: {
      type: Boolean,
      default: false
    },
    url: String
  },
  data() {
    return {
      vimeo: null
    };
  },
  mounted() {
    this.initVimeo();
  },
  methods: {
    initVimeo() {
      let el = this.$refs.vimeoContainer;

      let options = {
        title: this.title,
        responsive: this.responsive,
        url: this.url
      };

      el.addEventListener("update", ev => {
        this.$emit("update", ev.detail);
      });

      this.vimeo = new Vimeo(el, options);

      this.vimeoInitialized();
    },
    bind(options) {
      return this.vimeo.bind(options);
    },
    destroy() {
      this.vimeo.destroy();
    },
    loadVideo(value) {
      this.vimeo.loadVideo(value);
    },
    refresh() {
      this.vimeo.destroy();
      this.initVimeo();
    }
  },
  render(h) {
    return h("div", {
      class: this.customClass,
      ref: "vimeoContainer",
      id: "vimeoContainer"
    });
  }
};
</script>
