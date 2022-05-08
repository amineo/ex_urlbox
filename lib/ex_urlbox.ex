defmodule ExUrlbox do
  @moduledoc """
  A light wrapper for the Urlbox API.

  **Compatible with Urlbox API Version:** `v1`

  A list of options that you can pass into `ExUrlBox.get/3`, `ExUrlBox.post/3`, `ExUrlBox.head/3`, and `ExUrlBox.delete/3` can be found here:
  https://urlbox.io/docs/options
  """

  require Logger
  alias ExUrlbox.Config
  alias ExUrlbox.Utils

  @adapter Tesla.Adapter.Hackney
  @default_options [format: "png"]

  @doc """
  Send a request to Urlbox for a screenshot.
  Refer to the official documentation for all the available options: https://urlbox.io/docs/options

    **This action is `synchronous`. **
    If you want to use an `async` flow that uses webhooks, use `ExUrlBox.post/3`.

   **Function signature is: `url, [options], timeout`**

    - Example request:
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
  def get(url, opts \\ @default_options, timeout \\ 30_000) when is_binary(url) and url != nil do
    [{:url, url} | opts]
    |> Utils.build_url()
    |> client_get(timeout)
  end

  @doc false
  def get, do: raise("No URL was passed in to screenshot!")



  @doc """
  Post a request to Urlbox for a screenshot.
  You should provide a `webhook_url` option to receive a postback to once the screenshot render is complete.

  **This action is `async`. **

    - Example request with options containing `webhook_url` for a postback:
    ```
    ExUrlbox.post("https://anthonymineo.com", [webhook_url: "https://app-waiting-for-incoming-post.com/"])
    ```

    - Initial response from a post:
    ```
    {
      "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
      "status": "created",
      "statusUrl": "https://api.urlbox.io/render/ebcbce5q-9657-435f-aeb6-5db207ee87b5"
    }
    ```

    - If you dont provide a `webhook_url` you will need to poll the `statusUrl` for the status of your request:
    ```
    {
      "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
      "status":	"succeeded",
      "renderUrl": "https://renders.urlbox.io/urlbox1/renders/a1d7g7d45f7am5a0a69cd3de/2022/5/7/ebcbce5q-9657-435f-aeb6-5db207ee87b5.png",
      "size": 34748
    }
    ```

    - Example of a postback to `webhook_url`:
    ```
    {
      "event": "render.succeeded",
      "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
      "result": {
        "renderUrl": "https://renders.urlbox.io/urlbox1/renders/a1d7g7d45f7am5a0a69cd3de/2022/5/7/ebcbce5q-9657-435f-aeb6-5db207ee87b5.png",
        "size": 34748
      },
      "meta": {
        "startTime":"2022-05-07T20:25:28.879Z",
        "endTime":"2022-05-07T20:25:31.646Z"
      }
    }
    ```
  """
  @spec post(String.t(), list(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def post(url, opts \\ @default_options, timeout \\ 30_000) when is_binary(url) and url != nil do

    if !Keyword.get(opts, :webhook_url) do
      Logger.warning("webhook_url option was not found! You will need to poll the statusUrl from the post response for your results")
    end

    [{:url, url} | opts]
    |> Enum.into(%{})
    |> client_post(timeout)
  end

  @doc false
  def post, do: raise("No URL was passed in to screenshot!")


  @doc """
  Urlbox will cache previously created screenshots for some time. Sending a delete request removes a previously created screenshot from the cache.

    - Example request:
    ```
    ExUrlbox.delete("https://anthonymineo.com")
    ```
  """
  @spec delete(String.t(), list(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def delete(url, opts \\ @default_options, timeout \\ 30_000) when is_binary(url) and url != nil do
    [{:url, url} | opts]
    |> Utils.build_url()
    |> client_delete(timeout)
  end

  @doc false
  def delete, do: raise("No URL was passed in to screenshot!")



  @doc """
  If you just want to get the response status/headers without pulling down the full response body.

    - Example request:
    ```
    ExUrlbox.head("https://anthonymineo.com")
    ```
  """
  @spec head(String.t(), list(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def head(url, opts \\ @default_options, timeout \\ 30_000) when is_binary(url) and url != nil do
    [{:url, url} | opts]
    |> Utils.build_url()
    |> client_head(timeout)
  end

  @doc false
  def head, do: raise("No URL was passed in to screenshot!")









  # Setup Tesla client
  @doc false
  @spec client(integer(), bool()) :: Tesla.Client.t()
  def client(timeout, is_post? \\ false) do
    middleware = [
      {Tesla.Middleware.Timeout, timeout: timeout},
      Tesla.Middleware.JSON
    ]
    |> determine_endpoint(is_post?)

    Tesla.client(middleware, @adapter)
  end

  @doc false
  @spec determine_endpoint(list(), boolean()) :: list()
  defp determine_endpoint(middleware, is_post?) do
    case is_post? do
      true  -> [{Tesla.Middleware.BaseUrl, Config.base_endpoint} | middleware] |> include_bearer_token()
      false -> [{Tesla.Middleware.BaseUrl, Config.api_key_endpoint} | middleware]
    end
  end

  @doc false
  @spec include_bearer_token(list()) :: list()
  defp include_bearer_token(middleware) do
    [{Tesla.Middleware.BearerAuth, token: Config.api_secret} | middleware]
  end


  # Handle the HTTP GET
  @doc false
  @spec client_get(String.t(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def client_get(opts, timeout) do
    client(timeout)
    |> Tesla.get(opts)
  end


  # Handle the HTTP DELETE
  @doc false
  @spec client_delete(String.t(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def client_delete(opts, timeout) do
    client(timeout)
    |> Tesla.delete(opts)
  end


  # Handle the HTTP HEAD
  @doc false
  @spec client_head(String.t(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def client_head(opts, timeout) do
    client(timeout)
    |> Tesla.head(opts)
  end

  # Handle the HTTP POST
  @doc false
  @spec client_post(String.t(), integer()) :: {:error, any()} | {:ok, Tesla.Env.t()}
  def client_post(post_body, timeout) do
    is_post? = true
    client(timeout, is_post?)
    |> Tesla.post(Config.api_post_endpoint, post_body)
  end


end
