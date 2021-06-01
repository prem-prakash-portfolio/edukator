module.exports = {
  root: true,
  env: {
    node: true
  },
  extends: ["plugin:vue/recommended"],
  parserOptions: {
    parser: "babel-eslint"
  },
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? "error" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "error" : "off",
    "no-unused-vars": [
      "error",
      { "vars": "all", "args": "none", "ignoreRestSiblings": false }
    ],
    "vue/max-attributes-per-line": [
      "error",
      {
        "singleline": 10,
        "multiline": {
          "max": 1,
          "allowFirstLine": false
        }
      }
    ],
    "vue/require-default-prop": 0,
    "vue/prop-name-casing": 0,
    // "vue/singleline-html-element-content-newline": 0,
    // "vue/multiline-html-element-content-newline": 0,
    "vue/no-unused-vars": "error",
    // "quotes": ["error", "double"],
    "space-before-function-paren": ["error", "never"],
    "no-var": ["error"],
    "object-curly-spacing": ["error", "always"],
    "key-spacing": ["error", { "afterColon": true, "mode": "strict" }]
    // "semi": ["error", "always"]
    // "no-tabs": "error",
    // "vue/script-indent": ["error", 2],
    // "vue/html-indent": ["error", 2],
    // "indent": ["error", 2]
  },
  overrides: [
    {
      files: [
        "**/__tests__/*.{j,t}s?(x)",
        "**/tests/unit/**/*.spec.{j,t}s?(x)"
      ],
      env: {
        jest: true
      }
    }
  ]
};
