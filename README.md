# ExUrlbox

  A light wrapper for the Urlbox API. ExUrlbox's documentation could be found on [HexDocs](https://hexdocs.pm/ex_urlbox).

  **Compatible with Urlbox API:** `v1`

  A list of options that you can pass into [ExUrlBox.get/3](./lib/ex_urlbox.ex#L16) can be found here:
  https://urlbox.io/docs/options




## Usage
  ```elixir
      # Simple
      ExUrlbox.get("https://anthonymineo.com")

      # With options:
      ExUrlbox.get("https://anthonymineo.com", [format: "png", full_page: true])

      # With a timeout (5s):
      ExUrlbox.get("https://anthonymineo.com", [], 5_000)


      # Extract data from a response

      {:ok, screenshot} = ExUrlbox.get("https://anthonymineo.com")

      screenshot.body
      # => <<137, 80, 78, 71, 13, ...>>>

      screenshot.headers
      # => [{"content-type", "image/png"}, ...]

      screenshot.url
      # => https://api.urlbox.io/v1/:apikey/hmac(:apisecret)/png?url=https%3A%2F%2Fwww.google.com&width=1024&height=768

  ```




## Installation

This package can be installed by adding `ex_urlbox` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_urlbox, "~> 0.1.0"}
  ]
end
```



## Docs
The docs can be found at [https://hexdocs.pm/ex_urlbox](https://hexdocs.pm/ex_urlbox).

Documentation has been generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm).
