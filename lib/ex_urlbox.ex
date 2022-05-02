defmodule ExUrlbox do
  @moduledoc """
  A light wrapper for the Urlbox API.

  **Compatible with Urlbox API Version:** `v1`

  A list of options that you can pass into `ExUrlBox.get/3` can be found here:
  https://urlbox.io/docs/options
  """

  alias ExUrlbox.Config
  @adapter Tesla.Adapter.Hackney



  @doc """
  Send a request to Urlbox for a screenshot.
  Refer to the official documentation for all the available options: https://urlbox.io/docs/options

   **Function signature is: `url, [options], timeout`**

    - Simple example:
    ```
    ExUrlbox.get("https://anthonymineo.com")
    ```

    - Example with options:
    ```
    ExUrlbox.get("https://anthonymineo.com", [format: "png", full_page: true])
    ```

    - Example with timeout (5s):
    ```
    ExUrlbox.get("https://anthonymineo.com", [], 5_000)
    ```

  """
  @spec get(String.t(), list(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def get(url, opts \\ [format: "png"], timeout \\ 30_000) when is_binary(url) and url != nil do
    [{:url, url} | opts]
    |> build_url()
    |> client_get(timeout)
  end

  @doc false
  def get, do: raise("No URL was passed in to screenshot!")




  @doc """
  Generates a URL token by taking the HMAC SHA1 of the query string and signing it with your :api_secret.

  Example URL Format:  `https://api.urlbox.io/v1/:api_key/hmac(:api_secret)/format?[options]`
  """
  @spec generate_url_token(String.t()) :: String.t()
  def generate_url_token(opts) do
    :crypto.mac(:hmac, :sha, Config.api_secret(), opts)
    |> Base.encode16()
    |> String.downcase()
  end

  @doc """
  Build the screenshot request URL

  Example URL:  `/png?url=https%3A%2F%2Fgoogle.com&width=1024&height=768"`
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



  # Setup Tesla client
  @doc false
  @spec client(integer()) :: Tesla.Client.t()
  def client(timeout) do
    middleware = [
      {Tesla.Middleware.BaseUrl, Config.api_endpoint},
      {Tesla.Middleware.Timeout, timeout: timeout},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware, @adapter)
  end



  # Handle the HTTP GET
  @doc false
  @spec client_get(String.t(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def client_get(opts, timeout) do
    client(timeout)
    |> Tesla.get(opts)
  end
end
