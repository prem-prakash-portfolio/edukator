# Edukator

[![codecov](https://codecov.io/gl/garagem.com/edukator/branch/master/graph/badge.svg?token=lOzoD6tvOS)](https://codecov.io/gl/garagem.com/edukator)

### Machine Setup

  * Install asdf `brew install asdf`
  * Copy files ```echo -e '\n. $(brew --prefix asdf)/asdf.sh' >> ~/.zshrc
          echo -e '\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash' >> ~/.zshrc```
  * Install dependencies `brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc`
  * Install erlang `asdf plugin-add erlang`
  * `asdf install erlang 22.0.7`
  * `asdf global erlang 22.0.7`
  * Install elixir `asdf plugin-add elixir`
  * `asdf install elixir 1.9.1`
  * `asdf global elixir 1.9.1`
  * Install dependencies `asdf install`
  * `cd assets && npm install`
  * `mix ecto.migrate` migrate DB

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && npm install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: http://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
