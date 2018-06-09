locals_without_parens = []

[
  inputs: [
    "{lib,test,config}/**/*.{ex,exs}",
    ".formatter.exs",
    "mix.exs"
  ],
  import_deps: [:espec, :plug],
  line_length: 80,
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]
