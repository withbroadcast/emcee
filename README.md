# Emcee

Elixir toolkit for working with language models.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `emcee` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:emcee, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/emcee>.

## Usage

```elixir
Emcee.new()
|> Emcee.put_params(%{...})
|> Emcee.put_prompt(...)
|> Emcee.run()
```

```elixir

```
