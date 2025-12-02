set dotenv-load := true

run *args:
    gleam run run {{args}}

new *args:
    gleam run new {{args}} --fetch --example --parse
