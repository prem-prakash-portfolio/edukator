const path = require("path");
const SentryWebpackPlugin = require("@sentry/webpack-plugin");
module.exports = {
  pwa: {
    workboxPluginMode: "InjectManifest",
    workboxOptions: {
      swSrc: "./src/sw.js",
      swDest: "service-worker.js"
    }
  },
  devServer: {
    port: 8080,
    proxy: {
      "^/api": {
        target: "http://localhost:4000/",
        ws: true,
        changeOrigin: true
      }
    }
  },
  outputDir: path.resolve(__dirname, "../priv/static"),
  configureWebpack: {
    plugins: [
      process.env.VUE_APP_MIX_ENV === "prod"
        ? new SentryWebpackPlugin({
          include: path.resolve(__dirname, "../priv/static"),
          release: process.env.VUE_APP_SOURCE_VERSION
        })
        : false
    ].filter(Boolean)
  },
  chainWebpack: config => {
    // GraphQL Loader
    config.module
      .rule("graphql")
      .test(/\.gql$/)
      .use("graphql-tag/loader")
      .loader("graphql-tag/loader")
      .end();
  },
  transpileDependencies: ["vuetify"]
};
