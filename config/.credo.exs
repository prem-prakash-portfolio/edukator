%{
  configs: [
    %{
      name: "default",
      files: %{
        excluded: [
          ~r"/_build/",
          ~r"/deps/",
          ~r"/test/",
          ~r"/assets/",
          ~r"/priv/",
          ~r"application.ex"
        ]
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.AliasOrder, false}
      ]
    }
  ]
}
