defmodule ExUrlbox.Utils do
  @moduledoc """
  Various helper utilities for working with Urlbox's API

  """

  require Logger
  alias ExUrlbox.Config




  @doc """
  Generates a URL token by taking the HMAC SHA1 of the query string and signing it with your :api_secret.

    - Example URL Format:
    ```html
    https://api.urlbox.io/v1/:api_key/hmac(:api_secret)/format?[options]
    ```
  """
  @spec generate_url_token(String.t()) :: String.t()
  def generate_url_token(opts) do
    :crypto.mac(:hmac, :sha, Config.api_secret(), opts)
    |> Base.encode16()
    |> String.downcase()
  end

  @doc """
  Build the screenshot request URL. Used with `get`, `delete` and `head` requests.

    - Example URL:
    ```html
    /png?url=https%3A%2F%2Fgoogle.com&width=1024&height=768"
    ```
  """
  @spec build_url(list()) :: String.t()
  def build_url(opts) do
    uri_options =
    opts
    |> Keyword.delete(:format)
    |> URI.encode_query()

    tokend_options = uri_options |> generate_url_token()

    [
      tokend_options,
      opts[:format]
    ]
    |> Enum.join("/")
    |> Kernel.<>("?#{uri_options}")
  end

end
